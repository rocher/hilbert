package body Hilbert.Bit_Stream_Item is

   --------------------
   -- Check_Validity --
   --------------------

   procedure Check_Validity (Self : in out Object) is
   begin
      Self.Is_Valid :=
        Self.Bits.Length > 0
        and then (for all C of Hilbert.Strings.To_String (Self.Bits) =>
                    C = '0' or else C = '1');
   end Check_Validity;

   ------------------
   -- Check_Length --
   ------------------

   procedure Check_Length (Self : in out Object; Origin : Object) is
   begin
      Self.Extra_Bits := Self.Bits.Length - Origin.Bits.Length;
   end Check_Length;

   ---------------
   -- Set_Score --
   ---------------

   procedure Set_Score (Self : in out Object; Origin : Object) is
   begin
      Self.Score := (if Self.Bits = Origin.Bits then Origin.Score else 0);
   end Set_Score;

   --------------
   -- Is_Valid --
   --------------

   function Is_Valid (Self : in out Object) return Boolean is
   (Self.Is_Valid);

end Hilbert.Bit_Stream_Item;
