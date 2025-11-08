with Ada.Characters.Conversions;
with Ada.Strings.Wide_Unbounded;
with Ada.Wide_Text_IO;

package Hilbert.Strings is

   package WIO renames Ada.Wide_Text_IO;

   subtype BString is Wide_String;
   subtype UString is Ada.Strings.Wide_Unbounded.Unbounded_Wide_String;

   Null_BString : constant BString := "";
   Null_UString : constant UString :=
     Ada.Strings.Wide_Unbounded.Null_Unbounded_Wide_String;

   function To_BString (Item : String) return BString
   renames Ada.Characters.Conversions.To_Wide_String;

   function To_BString (Source : UString) return BString
   renames Ada.Strings.Wide_Unbounded.To_Wide_String;

   function To_UString (Source : BString) return UString
   renames Ada.Strings.Wide_Unbounded.To_Unbounded_Wide_String;

   function To_UString (Source : String) return UString
   is (To_UString (To_BString (Source)));

end Hilbert.Strings;
