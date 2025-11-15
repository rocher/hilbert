with GNAT.OS_Lib;

with CLIC.Subcommand; use CLIC.Subcommand;
with Simple_Logging;

with Hilbert.CLI.Internal; use Hilbert.CLI.Internal;

package body Hilbert.CLI.Grade is

   package Log renames Simple_Logging;

   use all type GNAT.Strings.String_Access;

   --------------------
   -- Setup_Switches --
   --------------------

   overriding
   procedure Setup_Switches
     (Cmd    : in out Cmd_Type;
      Config : in out CLIC.Subcommand.Switches_Configuration) is
   begin
      Define_Switch
        (Config,
         Cmd.Date'Access,
         Switch      => "-d:",
         Long_Switch => "--date=",
         Help        => "Date, in YYYYMM format",
         Argument    => "DATE");
   end Setup_Switches;

   -------------
   -- Execute --
   -------------

   overriding
   procedure Execute (Cmd : in out Cmd_Type; Args : AAA.Strings.Vector) is
      Arg_Num : constant Natural := Natural (Args.Length);
   begin
      Log.Debug ("Cmd.Settings = " & Cmd'Image);
      Log.Debug ("Args = " & Args'Image);
      for I in Args.First_Index .. Args.Last_Index loop
         Log.Debug ("Args(" & I'Image & ") = " & Args.Element (I));
      end loop;

      Log.Debug ("Date: " & Cmd.Date.all'Image);
      if Cmd.Date = null then
         Log.Error ("Specify date, in format YYYYMM.");
         GNAT.OS_Lib.OS_Exit (1);
      end if;

      Date_Str : constant String := Cmd.Date.all;
      Check_Date (Date_Str);

      if Arg_Num /= 1 then
         Log.Error ("Pool name is missing.");
         GNAT.OS_Lib.OS_Exit (1);
      end if;

      Pool_Name : constant String := Args.Element (Args.First_Index);
      Exams_Name : constant String := Pool_Name & "_" & Date_Str;

      Log.Info ("Grading exams " & Date_Str);
   end Execute;

end Hilbert.CLI.Grade;
