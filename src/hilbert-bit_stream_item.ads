with Hilbert.Strings; use Hilbert.Strings;

package Hilbert.Bit_Stream_Item is

   use all type UString;

   type Object is record
      Bits       : UString := Null_UString;
      Is_Valid   : Boolean := False;
      Extra_Bits : Integer := 0;
      Score      : Natural := 0;
   end record;

   procedure Check_Validity (Self : in out Object);
   --  Validates the Bit_Stream_Item by checking if the Bits field contains
   --  only '0' and '1' characters and is non-empty. Sets the Is_Valid field
   --  accordingly.

   procedure Check_Length (Self : in out Object; Origin : Object);
   --  Compares the length of Self.Bits with Origin.Bits. If they differ,
   --  sets Self.Extra_Bits to the difference.

   procedure Set_Score (Self : in out Object; Origin : Object);
   --  Sets the Score of Self based on comparison with Origin. If the Bits
   --  match, assigns Origin.Score to Self.Score; otherwise, sets it to 0.

   function Is_Valid (Self : in out Object) return Boolean;
   --  Returns the validity of the Bit_Stream_Item based on its Bits field.

   function To_String (Self : Object) return String
   is (Hilbert.Strings.To_String (Self.Bits))
   with Pre => Self.Is_Valid;
   --  Converts the Bits field of the Bit_Stream_Item to a standard String.

   overriding
   function "=" (Left, Right : Object) return Boolean
   is (Left.Bits = Right.Bits);
   --  Compares two Bit_Stream_Items for equality based on their Bits fields.

end Hilbert.Bit_Stream_Item;
