with Ada.Characters.Conversions;
with Ada.Strings.Unbounded;
with Ada.Strings.Wide_Unbounded;
with Ada.Wide_Text_IO;

package Hilbert.Strings is

   package WIO renames Ada.Wide_Text_IO;

   subtype UString is Ada.Strings.Unbounded.Unbounded_String;

   Null_UString : constant UString :=
     Ada.Strings.Unbounded.Null_Unbounded_String;

   subtype BWString is Wide_String;
   subtype UWString is Ada.Strings.Wide_Unbounded.Unbounded_Wide_String;

   Null_BWString : constant BWString := "";
   Null_UWString : constant UWString :=
     Ada.Strings.Wide_Unbounded.Null_Unbounded_Wide_String;

   --  Conversions to BWString

   function To_BWString (Item : String) return BWString
   renames Ada.Characters.Conversions.To_Wide_String;

   function To_BWString (Source : UString) return BWString
   is (To_BWString (Source.To_String));

   function To_BWString (Source : UWString) return BWString
   renames Ada.Strings.Wide_Unbounded.To_Wide_String;

   --  Conversions to UWString

   function To_UWString (Source : BWString) return UWString
   renames Ada.Strings.Wide_Unbounded.To_Unbounded_Wide_String;

   function To_UWString (Source : String) return UWString
   is (To_UWString (To_BWString (Source)));

   --  Conversions to String

   function To_String (Item : UString) return String
   renames Ada.Strings.Unbounded.To_String;

   function To_String (Source : BWString) return String
   is (Ada.Characters.Conversions.To_String (Source));

   function To_String (Source : UWString) return String
   is (Ada.Characters.Conversions.To_String (To_BWString (Source)));

   --  Conversions to UString

   function To_UString (Item : String) return UString
   renames Ada.Strings.Unbounded.To_Unbounded_String;

   function To_UString (Source : BWString) return UString
   is (To_UString (To_String (Source)));

   function To_UString (Source : UWString) return UString
   is (To_UString (To_String (Source)));

end Hilbert.Strings;
