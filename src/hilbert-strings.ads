with Ada.Strings.Wide_Wide_Unbounded;

package Hilbert.Strings is

   subtype WWString is Wide_Wide_String;

   subtype UWWString is
     Ada.Strings.Wide_Wide_Unbounded.Unbounded_Wide_Wide_String;

   Null_UString : constant UWWString :=
     Ada.Strings.Wide_Wide_Unbounded.Null_Unbounded_Wide_Wide_String;

   function To_UWWString (S : WWString) return UWWString
   renames Ada.Strings.Wide_Wide_Unbounded.To_Unbounded_Wide_Wide_String;

   function To_WWString (S : UWWString) return WWString
   renames Ada.Strings.Wide_Wide_Unbounded.To_Wide_Wide_String;

end Hilbert.Strings;
