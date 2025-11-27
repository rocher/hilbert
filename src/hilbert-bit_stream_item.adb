package body Hilbert.Bit_Stream_Item is

   --------------------
   -- Check_Validity --
   --------------------

   procedure Check_Validity (Self : in out Bit_Stream_Item_Type) is
   begin
      Self.Is_Valid :=
        Self.Bits.Length > 0
        and then (for all C of Self.Bits.To_String =>
                    C = '0' or else C = '1');
   end Check_Validity;

   --------------
   -- Is_Valid --
   --------------

   function Is_Valid (Self : in out Bit_Stream_Item_Type) return Boolean
   is (Self.Is_Valid);

   -----------
   -- Match --
   -----------

   function Match
     (Answer, Correct : Bit_Stream_Item_Type) return Bit_Stream_Item_Type
   is
      Result  : Bit_Stream_Item_Type;
      Min_Len : constant Natural :=
        Natural'Min (Answer.Bits.Length, Correct.Bits.Length);
   begin
      Result.Bits := Hilbert.Strings.Null_UString;
      Result.Is_Valid := True;

      for I in 1 .. Min_Len loop
         if Answer.Bits.Element (I) = Correct.Bits.Element (I) then
            Result.Bits.Append ('1');
         else
            Result.Bits.Append ('0');
         end if;
      end loop;

      if Answer.Bits.Length < Correct.Bits.Length then
         for I in Min_Len + 1 .. Correct.Bits.Length loop
            Result.Bits.Append ('0');
         end loop;
      end if;

      return Result;
   end Match;

end Hilbert.Bit_Stream_Item;
