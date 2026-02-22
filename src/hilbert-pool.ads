with Ada.Strings.Text_Buffers;

with Hilbert.Item;
with Hilbert.Strings; use Hilbert.Strings;

package Hilbert.Pool is

   use all type Hilbert.Item.Item_Type;

   type Pool_Type is record
      Name : UString := Null_UString;
      --  The name of the pool.

      Title : UWString := Null_UWString;
      --  The title of the pool.

      Items : Hilbert.Item.Item_Vector_Type;
      --  The collection of items in the pool.

      Groups : Hilbert.Item.Item_Map_Type;
      --  Groups of items defined in the pool.
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

   function Num_Items (Self : Pool_Type) return Positive
   is (Natural (Self.Items.Length) + Natural (Self.Groups.Length));
   --  Returns the number of items in the pool. This is the number of items in
   --  the Items vector plus the number of groups (only one item will be
   --  selected from each group).

   procedure Read (Self : out Pool_Type; Pool_Name : String);

   procedure Make_Exams
     (Self      : Pool_Type;
      Date      : String;
      Num_Exams : Positive;
      Num_Items : Positive);
   --  Creates Num_Exams exams for the specified date, each with Num_Items
   --  items, using the items in the pool Self.

   procedure Put_Image_Pool
     (Output : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
      Self   : Pool_Type);
   --  Outputs a textual representation of the pool to the specified output
   --  buffer.

end Hilbert.Pool;
