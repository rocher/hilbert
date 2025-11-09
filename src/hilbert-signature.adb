with Hilbert.Item;

with Hilbert.Constants; use Hilbert.Constants;
with Hilbert.Convert;   use Hilbert.Convert;

package body Hilbert.Signature is

   use all type UString;

   -----------------------
   -- Compute_Signature --
   -----------------------

   function Compute_Signature (Exam : Hilbert.Exam.Object) return UString is
      Signature : UString := Null_UString;
      Binary    : UString := Signature_Sentinel;
   begin
      Binary.Append (Integer_To_Byte (Integer (Exam.Pool.Length)));
      for I in 1 .. Integer (Exam.Pool.Length) loop
         declare
            Item : constant Hilbert.Item.Object := Exam.Pool.Element (I);
         begin
            Binary.Append (Integer_To_Nibble (Item.Num_Options));
            for J in 1 .. Item.Num_Options loop
               Binary.Append
                 (if Item.Options (J).Is_Correct then "1" else "0");
            end loop;
         end;
      end loop;

      --  Add padding bits to align to byte boundary
      while Binary.Length mod Signature_Mod_Length /= 0 loop
         Binary.Append (Signature_Padding_Bit);
      end loop;

      --  Convert to hexadecimal
      declare
         Num_Bytes : constant Positive := Binary.Length / Signature_Mod_Length;
         Low       : Positive;
         High      : Natural;
      begin
         for I in 0 .. Num_Bytes - 1 loop
            Low := I * 8 + 1;
            High := Natural (Low) + 7;
            Signature.Append
              (Byte_To_Hexadecimal (Binary.Unbounded_Slice (Low, High)));
         end loop;
      end;

      return Signature;
   end Compute_Signature;

   -----------------------
   -- Get_Option_Stream --
   -----------------------

   function Get_Options_Stream (Signature : UString) return UString is
      --  10000111100001111...
      --       |      |
      --    Low'6 High'13
      Low  : Positive := 6;  --  skip sentinel + version
      High : Positive := Low + 7;  --  next byte for number of items

      Bit_Stream : UString := Null_UString;
      Num_Bytes  : constant Positive := Signature.Length / 2;

      Option_Stream : UString := Null_UString;
      Num_Items     : Positive;
   begin
      for I in 1 .. Num_Bytes loop
         declare
            Pos : constant Positive := (I - 1) * 2 + 1;
         begin
            Bit_Stream.Append
              (Hexadecimal_To_Byte (Signature.Unbounded_Slice (Pos, Pos + 1)));
         end;
      end loop;

      Num_Items := Byte_To_Integer (Bit_Stream.Unbounded_Slice (Low, High));

      for I in 1 .. Num_Items loop
         Low := High + 1;
         High := Low + 3;
         declare
            Num_Options : constant Positive :=
              Nibble_To_Integer (Bit_Stream.Unbounded_Slice (Low, High));
         begin
            Low := High + 1;
            High := Low + Num_Options - 1;
            Option_Stream.Append (Bit_Stream.Unbounded_Slice (Low, High));
         end;
         if I < Num_Items then
            Option_Stream.Append (' ');
         end if;
      end loop;

      return Option_Stream;
   end Get_Options_Stream;

end Hilbert.Signature;
