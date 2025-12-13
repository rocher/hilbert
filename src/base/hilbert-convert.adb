with Ada.Integer_Wide_Text_IO;
with Ada.Float_Wide_Text_IO;
with Ada.Strings;
with Ada.Strings.Wide_Unbounded;

---------------------
-- Hilbert.Convert --
---------------------

package body Hilbert.Convert is

   package IntIO renames Ada.Integer_Wide_Text_IO;
   package FloatIO renames Ada.Float_Wide_Text_IO;

   ---------------------
   -- Byte_To_Integer --
   ---------------------

   function Byte_To_Integer (Byte : UWString) return Integer is
      Int    : Integer;
      Pos    : Positive;
      In_Str : constant BWString (1 .. 11) := "2#" & To_BWString (Byte) & "#";
   begin
      IntIO.Get (In_Str, Int, Pos);
      return Int;
   end Byte_To_Integer;

   -------------------------
   -- Byte_To_Hexadecimal --
   -------------------------

   function Byte_To_Hexadecimal (Byte : UWString) return UWString is
      Int     : Integer;
      Pos     : Positive;
      In_Str  : constant BWString (1 .. 11) := "2#" & To_BWString (Byte) & "#";
      Out_Str : BWString (1 .. 6);
      Hex     : UWString;
   begin
      IntIO.Get (In_Str, Int, Pos);
      IntIO.Put (Out_Str, Int, 16);
      if Out_Str (1) = ' ' then
         Hex := To_UWString ("0" & Out_Str (5));
      else
         Hex := To_UWString (Out_Str (4 .. 5));
      end if;
      return Hex;
   end Byte_To_Hexadecimal;

   -------------------------
   -- Hexadecimal_To_Byte --
   -------------------------

   function Hexadecimal_To_Byte (Hex : UWString) return UWString is
      Int     : Integer;
      Pos     : Positive;
      In_Str  : constant BWString (1 .. 6) := "16#" & To_BWString (Hex) & "#";
      Out_Str : BWString (1 .. 11);
      Byte    : UWString;
   begin
      IntIO.Get (In_Str, Int, Pos);
      IntIO.Put (Out_Str, Int, 2);
      Byte := To_UWString (Out_Str (3 .. 10));  --  Skip "2#" and last "#"
      for I in 1 .. Byte.Length loop
         if Byte.Element (I) /= '0' and then Byte.Element (I) /= '1' then
            Byte.Replace_Element (I, '0');
         end if;
      end loop;
      return Byte;
   end Hexadecimal_To_Byte;

   ---------------------
   -- Integer_To_Byte --
   ---------------------

   function Integer_To_Byte (Int : Integer) return UWString is
      Byte    : UWString;
      Out_Str : BWString (1 .. 11);
   begin
      IntIO.Put (Out_Str, Int, 2);
      Byte := To_UWString (Out_Str (3 .. 10));  --  Skip "2#" and last "#"
      for I in 1 .. Byte.Length loop
         if Byte.Element (I) /= '0' and then Byte.Element (I) /= '1' then
            Byte.Replace_Element (I, '0');
         end if;
      end loop;
      return Byte;
   end Integer_To_Byte;

   -----------------------
   -- Integer_To_Nibble --
   -----------------------

   function Integer_To_Nibble (Int : Integer) return UWString is
      Nibble  : UWString;
      Out_Str : BWString (1 .. 7);
   begin
      IntIO.Put (Out_Str, Int, 2);
      Nibble := To_UWString (Out_Str (3 .. 6));  --  Skip "2#" and last "#"
      for I in 1 .. Nibble.Length loop
         if Nibble.Element (I) /= '0' and then Nibble.Element (I) /= '1' then
            Nibble.Replace_Element (I, '0');
         end if;
      end loop;
      return Nibble;
   end Integer_To_Nibble;

   -----------------------
   -- Nibble_To_Integer --
   -----------------------

   function Nibble_To_Integer (Nibble : UWString) return Integer is
      Int    : Integer;
      Pos    : Positive;
      In_Str : constant BWString (1 .. 7) := "2#" & To_BWString (Nibble) & "#";
   begin
      IntIO.Get (In_Str, Int, Pos);
      return Int;
   end Nibble_To_Integer;

   ------------
   -- Format --
   ------------

   function Format
     (Int : Integer; Width : Positive; Padding : Wide_Character := ' ')
      return BWString
   is
      Str : BWString (1 .. Width);
   begin
      IntIO.Put (Str, Int);

      if Padding /= ' ' then
         for I in 1 .. Width loop
            if Str (I) = ' ' then
               Str (I) := Padding;
            end if;
         end loop;
      end if;
      return Str;
   end Format;

   ----------
   -- Trim --
   ----------

   function Trim (I : Integer) return BWString is
      Str  : BWString (1 .. 20);
      UStr : UWString;
   begin
      IntIO.Put (Str, I);
      UStr :=
        Ada.Strings.Wide_Unbounded.Trim (To_UWString (Str), Ada.Strings.Left);
      return To_BWString (UStr);
   end Trim;

   ----------
   -- Trim --
   ----------

   function Trim (F : Float) return BWString is
      Str  : BWString (1 .. 40);
      UStr : UWString;
   begin
      FloatIO.Put (Str, F);
      UStr :=
        Ada.Strings.Wide_Unbounded.Trim (To_UWString (Str), Ada.Strings.Left);
      return To_BWString (UStr);
   end Trim;

end Hilbert.Convert;
