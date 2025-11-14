with Ada.Containers.Vectors;
with Ada.Strings.Text_Buffers;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with Hilbert.Item;
with Hilbert.Strings; use Hilbert.Strings;

package Hilbert.Pool is

   use all type Hilbert.Item.Object;
   use all type Ada.Containers.Count_Type;

   package Item_Vector_Type is new
     Ada.Containers.Vectors
       (Index_Type   => Positive,
        Element_Type => Hilbert.Item.Object,
        "="          => Hilbert.Item."=");

   type Object is record
      Name  : Unbounded_String := Null_Unbounded_String;
      Title : UWString := Null_WUString;
      Items : Item_Vector_Type.Vector;
   end record
   with Put_Image => Put_Image_Pool;

   procedure Read (Self : out Object; Pool_Name : String);

   procedure Make_Exams
     (Self      : Object;
      Date      : String;
      Num_Exams : Positive;
      Num_Items : Positive);

   procedure Put_Image_Pool
     (Output : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
      Self   : Object);

end Hilbert.Pool;
