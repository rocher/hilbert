with AAA.Strings;
with CLIC.Subcommand;
with GNAT.Strings;

with Hilbert.Strings; use Hilbert.Strings;

package Hilbert.CLI.Generate is

   type Cmd_Type is new CLIC.Subcommand.Command with private;

   overriding
   function Name (Self : Cmd_Type) return CLIC.Subcommand.Identifier
   is ("generate");

   overriding
   function Usage_Custom_Parameters (Self : Cmd_Type) return String
   is ("--exams=NUM_EXAMS --items=NUM_ITEMS --date=YYYYMM POOL_NAME");

   overriding
   function Short_Description (Self : Cmd_Type) return String
   is ("Generate exams.");

   pragma Style_Checks (off);
   overriding
   function Long_Description (Cmd : Cmd_Type) return AAA.Strings.Vector
   is (AAA.Strings.Empty_Vector.Append
         ("Generate a collection of exams from the given pool of items. ")
         .New_Line
         .Append ("POOL_NAME is the name of a Hilbert pool of items. EXAM_NAME is <POOL_NAME>_<DATE>. Generated exams are written to <EXAM_NAME>_Exams.txt, and the corresponding answer batches are written to <EXAM_NAME>_Batch.txt.")
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
      Num_Exams : aliased Integer := Integer'First;
      Num_Items : aliased Integer := Integer'First;
      Date      : aliased GNAT.Strings.String_Access := null;
   end record;

end Hilbert.CLI.Generate;
