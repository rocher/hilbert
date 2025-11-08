--  with Ada.Integer_Text_IO;
with Ada.Integer_Wide_Text_IO;

package body Hilbert.Convert is

   --  package IntIO renames Ada.Integer_Text_IO;
   package IntIO renames Ada.Integer_Wide_Text_IO;

   ---------------------
   -- Byte_To_Integer --
   ---------------------

   function Byte_To_Integer (Byte : UString) return Integer is
      Int    : Integer;
      Pos    : Positive;
      In_Str : constant BString (1 .. 11) := "2#" & To_BString (Byte) & "#";
   begin
      IntIO.Get (In_Str, Int, Pos);
      return Int;
   end Byte_To_Integer;

   -------------------------
   -- Byte_To_Hexadecimal --
   -------------------------

   function Byte_To_Hexadecimal (Byte : UString) return UString is
      Int     : Integer;
      Pos     : Positive;
      In_Str  : constant BString (1 .. 11) := "2#" & To_BString (Byte) & "#";
      Out_Str : BString (1 .. 6);
      Hex     : UString;
   begin
      IntIO.Get (In_Str, Int, Pos);
      IntIO.Put (Out_Str, Int, 16);
      if Out_Str (1) = ' ' then
         Hex := To_UString ("0" & Out_Str (5));
      else
         Hex := To_UString (Out_Str (4 .. 5));
      end if;
      return Hex;
   end Byte_To_Hexadecimal;

   ---------------------
   -- Integer_To_Byte --
   ---------------------

   function Integer_To_Byte (Int : Integer) return UString is
      Str  : BString (1 .. 11);
      UStr : UString;
   begin
      IntIO.Put (Str, Int, 2);
      UStr := To_UString (Str (3 .. 10));  --  Skip "2#" and last "#"
      for I in 1 .. UStr.Length loop
         if UStr.Element (I) /= '0' and then UStr.Element (I) /= '1' then
            UStr.Replace_Element (I, '0');
         end if;
      end loop;
      return UStr;
   end Integer_To_Byte;

   -----------------------
   -- Integer_To_Nibble --
   -----------------------

   function Integer_To_Nibble (Int : Integer) return UString is
      Str  : BString (1 .. 7);
      UStr : UString;
   begin
      IntIO.Put (Str, Int, 2);
      UStr := To_UString (Str (3 .. 6));  --  Skip "2#" and last "#"
      for I in 1 .. UStr.Length loop
         if UStr.Element (I) /= '0' and then UStr.Element (I) /= '1' then
            UStr.Replace_Element (I, '0');
         end if;
      end loop;
      return UStr;
   end Integer_To_Nibble;

   -----------------------
   -- Nibble_To_Integer --
   -----------------------

   function Nibble_To_Integer (Nibble : UString) return Integer is
      Int    : Integer;
      Pos    : Positive;
      In_Str : constant BString (1 .. 7) := "2#" & To_BString (Nibble) & "#";
   begin
      IntIO.Get (In_Str, Int, Pos);
      return Int;
   end Nibble_To_Integer;

end Hilbert.Convert;
