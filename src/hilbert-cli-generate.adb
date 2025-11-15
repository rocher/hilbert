with GNAT.OS_Lib;

with CLIC.Subcommand; use CLIC.Subcommand;
with Simple_Logging;

with Hilbert.Constants; use Hilbert.Constants;
with Hilbert.Pool;
with Hilbert.Random;
with Hilbert.Types;     use Hilbert.Types;

package body Hilbert.CLI.Generate is

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
         Cmd.Num_Exams'Access,
         Switch      => "-e:",
         Long_Switch => "--exams=",
         Help        => "Number of exams to generate",
         Argument    => "NUM");
      Define_Switch
        (Config,
         Cmd.Num_Items'Access,
         Switch      => "-i:",
         Long_Switch => "--items=",
         Help        => "Number of items per exam",
         Argument    => "NUM");
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

      if Cmd.Num_Exams = Integer'First then
         Log.Error ("Specify number of exams.");
         GNAT.OS_Lib.OS_Exit (1);
      end if;
      if Cmd.Num_Exams <= 0 then
         Log.Error ("Number of exams must be positive.");
         GNAT.OS_Lib.OS_Exit (1);
      end if;

      if Cmd.Num_Items = Integer'First then
         Log.Error ("Specify number of items per exam.");
         GNAT.OS_Lib.OS_Exit (1);
      end if;
      if Cmd.Num_Items <= 0 then
         Log.Error ("Number of items per exam must be positive.");
         GNAT.OS_Lib.OS_Exit (1);
      end if;

      Log.Debug ("Date: " & Cmd.Date.all'Image);
      if Cmd.Date = null then
         Log.Error ("Specify date, in format YYYYMM.");
         GNAT.OS_Lib.OS_Exit (1);
      end if;

      Date_Str : constant String := Cmd.Date.all;
      if not Is_Date (To_UString (Date_Str)) then
         Log.Error ("Date must be in format YYYYMM, YYYY > 2000.");
         GNAT.OS_Lib.OS_Exit (1);
      end if;

      if Arg_Num /= 1 then
         Log.Error ("Pool name is missing.");
         GNAT.OS_Lib.OS_Exit (1);
      end if;

      Pool_Name : constant String := Args.Element (Args.First_Index);

      Log.Info
        ("Generating"
         & Cmd.Num_Exams'Image
         & " exams with"
         & Cmd.Num_Items'Image
         & " items from pool "
         & Pool_Name);

      Hilbert.Random.Initialize (Random_Seed);

      Pool : Hilbert.Pool.Object;
      Pool.Read (Pool_Name);
      Pool.Make_Exams
        (Date      => Date_Str,
         Num_Exams => Cmd.Num_Exams,
         Num_Items => Cmd.Num_Items);
   end Execute;

end Hilbert.CLI.Generate;
