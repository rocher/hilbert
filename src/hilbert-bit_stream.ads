with Ada.Containers.Vectors;

with Hilbert.Bit_Stream_Item;
with Hilbert.Strings; use Hilbert.Strings;
with Hilbert.Version; use Hilbert.Version;

package Hilbert.Bit_Stream is

   package Bit_Stream_Vector_Package is new
     Ada.Containers.Vectors
       (Index_Type   => Positive,
        Element_Type => Hilbert.Bit_Stream_Item.Bit_Stream_Item_Type,
        "="          => Hilbert.Bit_Stream_Item."=");

   type Bit_Stream_Type is new Bit_Stream_Vector_Package.Vector
   with null record;

   procedure Load_From_UString
     (Self    : in out Bit_Stream_Type;
      Bits    : UString;
      Version : Version_Type := Null_Version);
   --  Loads the Bit_Stream from a UString by dividing it into chunks of
   --  and creating a Bit_Stream_Item for each chunk.

   function Num_Items (Self : Bit_Stream_Type) return Natural
   is (Natural (Bit_Stream_Vector_Package.Vector (Self).Length));
   --  Returns the number of items in the Bit_Stream.

end Hilbert.Bit_Stream;
