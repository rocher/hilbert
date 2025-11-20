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

      Extra_Bits : Integer := 0;
      --  Difference in length compared to an origin Bit_Stream_Item.

      Score : Natural := 0;
      --  Score assigned based on comparison with an origin Bit_Stream_Item.
   end record;
   --  Represents a single item in a bit stream.

   procedure Check_Validity (Self : in out Bit_Stream_Item_Type);
   --  Validates the Bit_Stream_Item by checking if the Bits field contains
   --  only '0' and '1' characters and is non-empty. Sets the Is_Valid field
   --  accordingly.

   procedure Check_Length
     (Self : in out Bit_Stream_Item_Type; Origin : Bit_Stream_Item_Type);
   --  Compares the length of Self.Bits with Origin.Bits. If they differ,
   --  sets Self.Extra_Bits to the difference.

   procedure Set_Score
     (Self : in out Bit_Stream_Item_Type; Origin : Bit_Stream_Item_Type);
   --  Sets the Score of Self based on comparison with Origin. If the Bits
   --  match, assigns Origin.Score to Self.Score; otherwise, sets it to 0.

   function Is_Valid (Self : in out Bit_Stream_Item_Type) return Boolean;
   --  Returns the validity of the Bit_Stream_Item based on its Bits field.

   function To_String (Self : Bit_Stream_Item_Type) return String
   is (Hilbert.Strings.To_String (Self.Bits))
   with Pre => Self.Is_Valid;
   --  Converts the Bits field of the Bit_Stream_Item to a standard String.

   overriding
   function "=" (Left, Right : Bit_Stream_Item_Type) return Boolean
   is (Left.Bits = Right.Bits);
   --  Compares two Bit_Stream_Items for equality based on their Bits fields.

end Hilbert.Bit_Stream_Item;
