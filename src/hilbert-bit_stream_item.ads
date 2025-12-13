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
   is (Self.Bits.To_String)
   with Pre => Self.Is_Valid;
   --  Converts the Bits field of the Bit_Stream_Item to a standard String.

   function Head (Left, Right : Bit_Stream_Item_Type) return UString
   with Pre => Left.Bits.Length > Right.Bits.Length;
   --  Returns a UString representing the leading bits of the Left
   --  Bit_Stream_Item. The result contains bits from the start up to the
   --  length of the Right Bit_Stream_Item. For example, if Left has bits
   --  "11010" and Right has bits "101", the result will be "110".

   function Tail (Left, Right : Bit_Stream_Item_Type) return UString;
   --  If Left has more bits than Right, Tail returns the trailing bits of
   --  Left. For example, if Left has bits "11010" and Right has bits "101",
   --  the result will be "10". If Left has less bits than Right, this
   --  function returns a series of '?' characters representing the missing
   --  bits. For example, if Left has bits "101" and Right has bits "11010",
   --  the result will be "??". If Left and Right have the same length, the
   --  result is an empty UString.

   function Mask (Self : Bit_Stream_Item_Type) return UString;
   --  Returns a UString representing a mask for the Bit_Stream_Item. The
   --  result contains as many '?' characters as the length of Self.Bits.

   overriding
   function "=" (Left, Right : Bit_Stream_Item_Type) return Boolean
   is (Left.Bits = Right.Bits);
   --  Compares two Bit_Stream_Items for equality based on their Bits fields.

end Hilbert.Bit_Stream_Item;
