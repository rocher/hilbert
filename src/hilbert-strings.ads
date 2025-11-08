with Ada.Strings.Wide_Unbounded;
with Ada.Wide_Text_IO;

package Hilbert.Strings is

   package WIO renames Ada.Wide_Text_IO;

   subtype BString is Wide_String;
   subtype UString is Ada.Strings.Wide_Unbounded.Unbounded_Wide_String;

   Null_BString : constant BString := "";
   Null_UString : constant UString :=
     Ada.Strings.Wide_Unbounded.Null_Unbounded_Wide_String;

   --  function "&" (Left : String; Right : UString) return UString
   --  renames Ada.Strings.Unbounded."&";

   --  function "&" (Left : UString; Right : String) return UString
   --  renames Ada.Strings.Unbounded."&";

   --  function To_String (S : UString) return String
   --  renames Ada.Strings.Unbounded.To_String;

   --  function To_UString (S : String) return UString
   --  renames Ada.Strings.Unbounded.To_Unbounded_String;

   --  function To_UWWString (S : WWString) return UWWString
   --  renames Ada.Strings.Wide_Wide_Unbounded.To_Unbounded_Wide_Wide_String;

   --  function To_WWString (S : UWWString) return WWString
   --  renames Ada.Strings.Wide_Wide_Unbounded.To_Wide_Wide_String;

   function To_UString (Source : BString) return UString
   renames Ada.Strings.Wide_Unbounded.To_Unbounded_Wide_String;

   function To_BString (Source : UString) return BString
   renames Ada.Strings.Wide_Unbounded.To_Wide_String;

end Hilbert.Strings;
