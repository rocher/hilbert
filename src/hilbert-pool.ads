with Ada.Containers.Vectors;
with Ada.Strings.Text_Buffers;

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
   --  A vector of Items.

   type Object is record
      Name : UString := Null_UString;
      --  The name of the pool.

      Title : UWString := Null_WUString;
      --  The title of the pool.

      Items : Item_Vector_Type.Vector;
      --  The collection of items in the pool.
   end record
   with Put_Image => Put_Image_Pool;
   --  Represents a pool of items. A pool contains multiple items that can be
   --  used to create exams for a particular RA.

   --  For example, "SMX1_DIG_RA2_Pool.txt" contains the pool for the RA2. For
   --  example, "SMX1_DIG_RA2_202511" is the exam generated for the RA2 in
   --  November 2025 of the module DIG fo the cycle SMX1.

   --  First line: <Cycle> <Module> <RA Number> <Module Name>
   --  SMX1 DIG RA2 Digitalització Aplicada als Sectors Productius

   --  Subsequent lines: one per item,
   --  BLANK LINE
   --  <Item's difficulty> <Item's text>
   --  <Number of options N>
   --  <Bit> <Option 1>
   --  <Bit> <Option 2>
   --  ...
   --  <Bit> <Option N>

   --  Example lines:
   --  SMX1 DIG RA2 Digitalització Aplicada als Sectors Productius
   --
   --  1 Quina revolució industrial es coneix com la "digital"?
   --  4
   --  0 Primera
   --  0 Segona
   --  0 Tercera
   --  1 Quarta

   --  <Bit> is '1' for correct options and '0' for incorrect options.

   procedure Read (Self : out Object; Pool_Name : String);

   procedure Make_Exams
     (Self      : Object;
      Date      : String;
      Num_Exams : Positive;
      Num_Items : Positive);
   --  Creates Num_Exams exams for the specified date, each with Num_Items
   --  items, using the items in the pool Self.

   procedure Put_Image_Pool
     (Output : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
      Self   : Object);
   --  Outputs a textual representation of the pool to the specified output
   --  buffer.

end Hilbert.Pool;
