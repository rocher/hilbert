with GNAT.OS_Lib;

with CLIC.Subcommand; use CLIC.Subcommand;
with Simple_Logging;

with Hilbert.Grade;
with Hilbert.Types;

package body Hilbert.CLI.Grade is

   package Log renames Simple_Logging;

   --------------------
   -- Setup_Switches --
   --------------------

   overriding
   procedure Setup_Switches
     (Cmd    : in out Cmd_Type;
      Config : in out CLIC.Subcommand.Switches_Configuration) is
   begin
      null;
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
      Log.Debug ("Arg_Num =" & Arg_Num'Image);

      if Arg_Num < 1 then
         Log.Error ("Class exam name is missing.");
         GNAT.OS_Lib.OS_Exit (1);
      elsif Arg_Num > 1 then
         Log.Error ("Too many arguments.");
         GNAT.OS_Lib.OS_Exit (1);
      end if;

      Class_Exam_Name : constant String := Args.Element (Args.First_Index);
      if Hilbert.Types.Is_Class_Exam_Name (Class_Exam_Name) = False then
         Log.Error ("Invalid class exam name: " & Class_Exam_Name);
         GNAT.OS_Lib.OS_Exit (1);
      end if;

      Log.Info ("Grading exams " & Class_Exam_Name & "...");
      Hilbert.Grade.Grade_Class_Exam (Class_Exam_Name);
   end Execute;

end Hilbert.CLI.Grade;
