with Ada.Containers.Vectors;

with Hilbert.Bit_Stream_Item;
with Hilbert.Strings; use Hilbert.Strings;

package Hilbert.Bit_Stream is

   package Bit_Stream_Vector_Type is new
     Ada.Containers.Vectors
       (Index_Type   => Positive,
        Element_Type => Hilbert.Bit_Stream_Item.Bit_Stream_Type,
        "="          => Hilbert.Bit_Stream_Item."=");

   type Bit_Stream_Type is record
      Bit_Stream : Bit_Stream_Vector_Type.Vector;
      --  The sequence of Bit_Stream_Items in this Bit_Stream.

      Valid_Items : Natural := 0;
      --  The number of valid Bit_Stream_Items in this Bit_Stream.

      Extra_Items : Integer := 0;
      --  The difference in number of items compared to an origin Bit_Stream.
   end record;
   --  Represents a stream of bits divided into items.

   function Length (Self : Bit_Stream_Type) return Natural
   is (Natural (Self.Bit_Stream.Length));
   --  Returns the number of Bit_Stream_Items in Self.Bit_Stream.

   procedure Count_Valid_Items (Self : in out Bit_Stream_Type);
   --  Counts the number of valid Bit_Stream_Items in Self.Bit_Stream and
   --  updates Self.Valid_Items accordingly.

   procedure Check_Extra_Items
     (Self : in out Bit_Stream_Type; Origin : Bit_Stream_Type);
   --  Compares the number of items in Self.Bit_Stream with Origin.Bit_Stream.
   --  If they differ, sets Self.Extra_Items to the difference.

   procedure Load_From_UString (Self : in out Bit_Stream_Type; Bits : UString);
   --  Loads the Bit_Stream from a UString by dividing it into chunks of
   --  and creating a Bit_Stream_Item for each chunk.

end Hilbert.Bit_Stream;
