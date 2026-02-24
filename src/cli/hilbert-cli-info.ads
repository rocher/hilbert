with AAA.Strings;
with CLIC.Subcommand;

with Hilbert.Strings; use Hilbert.Strings;

package Hilbert.CLI.Info is

   type Cmd_Type is new CLIC.Subcommand.Command with private;

   overriding
   function Name (Self : Cmd_Type) return CLIC.Subcommand.Identifier
   is ("info");

   overriding
   function Usage_Custom_Parameters (Self : Cmd_Type) return String
   is ("NAME");

   overriding
   function Short_Description (Self : Cmd_Type) return String
   is ("Show information about a pool, exam or answers entity.");

   pragma Style_Checks (off);
   overriding
   function Long_Description (Cmd : Cmd_Type) return AAA.Strings.Vector
   is (AAA.Strings.Empty_Vector.Append
         ("Show information about the given pool, exam or answers. ")
         .New_Line
         .Append ("NAME is the (file)name of a Hilbert pool, exam or answers entity. Please visit https://rocher.github.io/hilbert for a complete reference.")
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
   end record;

end Hilbert.CLI.Info;
