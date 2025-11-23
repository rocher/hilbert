with Hilbert.Strings; use Hilbert.Strings;

package Hilbert.Bit_Stream_Item is

   use all type UString;

   type Bit_Stream_Item_Type is record
      Bits : UString := Null_UString;
      --  The bit string representing the item, consisting of '0' and '1'
      --  characters.

      Is_Valid : Boolean := False;
      --  Indicates whether the Bits field is valid. Basically, it should only
      --  contain '0' and '1' characters and be non-empty.
   end record;
   --  Represents a single item in a bit stream.

   procedure Check_Validity (Self : in out Bit_Stream_Item_Type);
   --  Validates the Bit_Stream_Item by checking if the Bits field contains
   --  only '0' and '1' characters and is non-empty. Sets the Is_Valid field
   --  accordingly.

   function Is_Valid (Self : in out Bit_Stream_Item_Type) return Boolean;
   --  Returns the validity of the Bit_Stream_Item based on its Bits field.

   function To_String (Self : Bit_Stream_Item_Type) return String
   is (Hilbert.Strings.To_String (Self.Bits))
   with Pre => Self.Is_Valid;
   --  Converts the Bits field of the Bit_Stream_Item to a standard String.

   function Match
     (Answer, Correct : Bit_Stream_Item_Type) return Bit_Stream_Item_Type;
   --  Compares the Answer Bit_Stream_Item with the Correct one and returns a
   --  Bit_Stream_Item indicating which bits match (1) and which do not (0).
   --  For each position in the Bits field, if the bits match, the resulting
   --  Bit_Stream_Item will have '1' at that position; otherwise, it will have
   --  '0'. If the Answer have fewer bits than Correct, the remaining bits
   --  included in the result will be '0'. If Answer have more bits than
   --  Correct, the extra bits will be ignored.
   --
   --  Precondition: Both Answer and Correct must be valid.

   overriding
   function "=" (Left, Right : Bit_Stream_Item_Type) return Boolean
   is (Left.Bits = Right.Bits);
   --  Compares two Bit_Stream_Items for equality based on their Bits fields.

end Hilbert.Bit_Stream_Item;
