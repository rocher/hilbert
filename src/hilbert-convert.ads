with Hilbert.Strings; use Hilbert.Strings;

package Hilbert.Convert is

   function Byte_To_Integer (Byte : UString) return Integer
   with Pre => Byte.Length = 8, Post => Byte_To_Integer'Result in 0 .. 255;

   function Byte_To_Hexadecimal (Byte : UString) return UString
   with Pre => Byte.Length = 8, Post => Byte_To_Hexadecimal'Result.Length = 2;

   function Hexadecimal_To_Byte (Hex : UString) return UString
   with Pre => Hex.Length = 2, Post => Hexadecimal_To_Byte'Result.Length = 8;

   function Integer_To_Byte (Int : Integer) return UString
   with Pre => Int in 0 .. 255, Post => Integer_To_Byte'Result.Length = 8;

   function Integer_To_Nibble (Int : Integer) return UString
   with Pre => Int in 0 .. 15, Post => Integer_To_Nibble'Result.Length = 4;

   function Nibble_To_Integer (Nibble : UString) return Integer
   with Pre => Nibble.Length = 4, Post => Nibble_To_Integer'Result in 0 .. 15;

   function Format
     (Int : Integer; Width : Positive; Padding : Wide_Character := ' ')
      return BString;

   function Trim (Int : Integer) return BString;

end Hilbert.Convert;
