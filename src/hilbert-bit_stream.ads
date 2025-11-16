with Ada.Containers.Vectors;

with Hilbert.Bit_Stream_Item;
with Hilbert.Strings; use Hilbert.Strings;

package Hilbert.Bit_Stream is

   package Bit_Stream_Vector_Type is new
     Ada.Containers.Vectors
       (Index_Type   => Positive,
        Element_Type => Hilbert.Bit_Stream_Item.Object,
        "="          => Hilbert.Bit_Stream_Item."=");

   type Object is record
      Bit_Stream  : Bit_Stream_Vector_Type.Vector;
      Valid_Items : Natural := 0;
      Extra_Items : Integer := 0;
   end record;

   function Length (Self : Object) return Natural
   is (Natural (Self.Bit_Stream.Length));
   --  Returns the number of Bit_Stream_Items in Self.Bit_Stream.

   procedure Count_Valid_Items (Self : in out Object);
   --  Counts the number of valid Bit_Stream_Items in Self.Bit_Stream and
   --  updates Self.Valid_Items accordingly.

   procedure Check_Extra_Items (Self : in out Object; Origin : Object);
   --  Compares the number of items in Self.Bit_Stream with Origin.Bit_Stream.
   --  If they differ, sets Self.Extra_Items to the difference.

   procedure Load_From_UString (Self : in out Object; Bits : UString);
   --  Loads the Bit_Stream from a UString by dividing it into chunks of
   --  and creating a Bit_Stream_Item for each chunk.

end Hilbert.Bit_Stream;
