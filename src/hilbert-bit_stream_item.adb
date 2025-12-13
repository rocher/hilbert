package body Hilbert.Bit_Stream_Item is

   --------------------
   -- Check_Validity --
   --------------------

   procedure Check_Validity (Self : in out Bit_Stream_Item_Type) is
   begin
      Self.Is_Valid :=
        Self.Bits.Length > 0
        and then (for all C of Self.Bits.To_String => C = '0' or else C = '1');
   end Check_Validity;

   --------------
   -- Is_Valid --
   --------------

   function Is_Valid (Self : in out Bit_Stream_Item_Type) return Boolean
   is (Self.Is_Valid);

   ----------
   -- Head --
   ----------

   function Head (Left, Right : Bit_Stream_Item_Type) return UString is
   begin
      return Result : UString := Null_UString do
         for I in 1 .. Right.Bits.Length loop
            Result.Append (Left.Bits.Element (I));
         end loop;
      end return;
   end Head;

   ----------
   -- Tail --
   ----------

   function Tail (Left, Right : Bit_Stream_Item_Type) return UString is
   begin
      return Result : UString := Null_UString do
         if Left.Bits.Length < Right.Bits.Length then
            for I in Left.Bits.Length + 1 .. Right.Bits.Length loop
               Result.Append ('?');
            end loop;
            return;
         elsif Right.Bits.Length < Left.Bits.Length then
            for I in Right.Bits.Length + 1 .. Left.Bits.Length loop
               Result.Append (Left.Bits.Element (I));
            end loop;
         end if;
      end return;
   end Tail;

   ----------
   -- Mask --
   ----------

   function Mask (Self : Bit_Stream_Item_Type) return UString is
   begin
      return Result : UString := Null_UString do
         for I in 1 .. Self.Bits.Length loop
            Result.Append ('?');
         end loop;
      end return;
   end Mask;

end Hilbert.Bit_Stream_Item;
