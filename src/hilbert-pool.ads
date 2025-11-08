with Hilbert.Item;

with Ada.Containers.Vectors;
with Ada.Strings.Text_Buffers;

package Hilbert.Pool is

   use all type Hilbert.Item.Object;
   use all type Ada.Containers.Count_Type;

   package Item_Vector_Type is new
     Ada.Containers.Vectors
       (Index_Type   => Positive,
        Element_Type => Hilbert.Item.Object,
        "="          => Hilbert.Item."=");

   type Object is new Item_Vector_Type.Vector with null record
   with Put_Image => Put_Image_Pool;

   procedure Read_From_File (Self : out Object; Filename : String);

   procedure Make_Exams
     (Self      : Object;
      Name      : String;
      Num_Exams : Positive;
      Num_Items : Positive);

   procedure Put_Image_Pool
     (Output : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
      Self   : Object);

end Hilbert.Pool;
