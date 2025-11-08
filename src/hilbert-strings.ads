with Ada.Strings.Unbounded;
with Ada.Strings.Wide_Wide_Unbounded;

package Hilbert.Strings is

   subtype UString is Ada.Strings.Unbounded.Unbounded_String;

   subtype WWString is Wide_Wide_String;

   subtype UWWString is
     Ada.Strings.Wide_Wide_Unbounded.Unbounded_Wide_Wide_String;

   Null_UString : constant UString :=
     Ada.Strings.Unbounded.Null_Unbounded_String;

   Null_UWWString : constant UWWString :=
     Ada.Strings.Wide_Wide_Unbounded.Null_Unbounded_Wide_Wide_String;

   function "&" (Left : String; Right : UString) return UString
   renames Ada.Strings.Unbounded."&";

   function "&" (Left : UString; Right : String) return UString
   renames Ada.Strings.Unbounded."&";

   function To_String (S : UString) return String
   renames Ada.Strings.Unbounded.To_String;

   function To_UString (S : String) return UString
   renames Ada.Strings.Unbounded.To_Unbounded_String;

   function To_UWWString (S : WWString) return UWWString
   renames Ada.Strings.Wide_Wide_Unbounded.To_Unbounded_Wide_Wide_String;

   function To_WWString (S : UWWString) return WWString
   renames Ada.Strings.Wide_Wide_Unbounded.To_Wide_Wide_String;

end Hilbert.Strings;
