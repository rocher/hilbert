with AAA.Strings;
with CLIC.Subcommand;
with GNAT.Strings;

with Hilbert.Strings; use Hilbert.Strings;

package Hilbert.CLI.Grade is

   type Cmd_Type is new CLIC.Subcommand.Command with private;

   overriding
   function Name (Self : Cmd_Type) return CLIC.Subcommand.Identifier
   is ("grade");

   overriding
   function Usage_Custom_Parameters (Self : Cmd_Type) return String
   is ("POOL_NAME");

   overriding
   function Short_Description (Self : Cmd_Type) return String
   is ("Grade exams.");

   pragma Style_Checks (off);
   overriding
   function Long_Description (Cmd : Cmd_Type) return AAA.Strings.Vector
   is (AAA.Strings.Empty_Vector.Append
         ("Grade a collection of exams from a set of answers. ")
         .New_Line
         .Append ("POOL_NAME is a Hilbert pool name. EXAM_NAME is <POOL_NAME>_<DATE>. Answers are expected to be in a file named <EXAM_NAME>_Answers.txt. Grades are produced using the correct answers in <EXAM_NAME>_Batch.txt, and the results will be written to <EXAM_NAME>_Grades.txt.")
         .New_Line
         .Append
            ("Please visit https://rocher.github.io/hilbert for a complete reference.")
         .New_Line);
   pragma Style_Checks (on);

   overriding
   function Switch_Parsing
     (Self : Cmd_Type) return CLIC.Subcommand.Switch_Parsing_Kind
   is (CLIC.Subcommand.Parse_All);

   overriding
   procedure Setup_Switches
     (Cmd    : in out Cmd_Type;
      Config : in out CLIC.Subcommand.Switches_Configuration);

   overriding
   procedure Execute (Cmd : in out Cmd_Type; Args : AAA.Strings.Vector);

private

   type Cmd_Type is new CLIC.Subcommand.Command with record
      Pool_Name : UString := Null_UString;
      Date      : aliased GNAT.Strings.String_Access := null;
   end record;

end Hilbert.CLI.Grade;
