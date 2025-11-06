with Hilbert.Item;

with Ada.Containers.Vectors;
with Ada.Strings.Text_Buffers;
with Ada.Text_IO;

package Hilbert.Pool is

   use all type Hilbert.Item.Object;

   package Item_Vector_Type is new
     Ada.Containers.Vectors
       (Index_Type   => Positive,
        Element_Type => Item.Object,
        "="          => Item."=");

   type Object is new Item_Vector_Type.Vector with null record
   with Put_Image => Put_Image_Pool;

   procedure Read (Self : out Object; File : in out Ada.Text_IO.File_Type);

   procedure Put_Image_Pool
     (Output : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
      Self   : Object);

end Hilbert.Pool;
