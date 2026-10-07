with Ada.Containers.Hashed_Maps;
with Ada.Containers.Vectors;
with Ada.Strings.Text_Buffers;

with Hilbert.Strings; use Hilbert.Strings;

package Hilbert.Item is

   use all type Ada.Containers.Count_Type;
   use all type UWString;

   Max_Options : constant Positive := 16;

   subtype Num_Options_Type is Positive range 1 .. Max_Options;

   type Difficulty_Type is (Easy, Medium, Hard);

   type Option_Type is record
      Is_Correct : Boolean;
      --  Indicates whether this option is correct.

      Text : UWString;
      --  The text of the option.
   end record;

   type Item_Flags_Type is record
      Figure : UWString := Null_UWString;
      --  The figure associated with the item, if any.

      VSpace : UWString := Null_UWString;
      --  The vertical space after the item, in LaTeX units.

      Group : UWString := Null_UWString;
      --  The group of the item, if any. Group Null_UWString means the item is
      --  not part of any group. Items in the same non-zero group are related,
      --  and at least one item from each group must be included in all exams.

      Invalid : Boolean := False;
      --  Indicates whether the item is invalid. Invalid items are ignored
      --  when grading exams. If you already have printed all the exams, you
      --  can mark an item as invalid to avoid grading it without having to
      --  reprint the exams, but remember to regenerate the exams to grade
      --  them correctly. Invalid items are not included in the pool when
      --  generating exams.
   end record;

   type Options_Type is array (Num_Options_Type) of Option_Type;

   type Item_Type is record
      Number : Natural := 0;
      --  The number of the item in the exam.

      Difficulty : Difficulty_Type;
      --  The difficulty of the item.

      Question : UWString;
      --  The text of the question.

      Num_Options : Num_Options_Type;
      --  The number of options for this item.

      Options : Options_Type;
      --  The options for this item.

      Flags : Item_Flags_Type;
      --  The flags associated with this item.
   end record
   with Put_Image => Put_Image_Item;
   --  Represents an item (question) in a pool or exam.

   type Item_Access_Type is access all Item_Type;

   overriding
   function "=" (Left, Right : Item_Type) return Boolean
   is (Left.Difficulty = Right.Difficulty
       and then Left.Question = Right.Question
       and then Left.Num_Options = Right.Num_Options
       and then Left.Options = Right.Options);
   --  Compares two Items for equality based on their fields.

   procedure Read_From
     (Self        : out Item_Type;
      In_File     : in out WIO.File_Type;
      Line_Number : in out Natural);
   --  Reads an item from the specified input file into Self.

   procedure Write_To (Self : Item_Type; Out_File : in out WIO.File_Type);
   --  Writes the item Self to the specified output file.

   procedure Shuffle_Options (Self : in out Item_Type);
   --  Shuffles the options of the item Self randomly.

   function Get_Answers_Bits (Self : Item_Type) return UString;
   --  Returns a UString representing the correct answers of the item. The
   --  returned UString consists of '1' and '0' characters, where '1'
   --  indicates a correct option and '0' indicates an incorrect option.

   procedure Put_Image_Item
     (Output : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
      Self   : Item_Type);
   --  Outputs a textual representation of the item to the specified output
   --  buffer.

   package Item_Vector_Package is new
     Ada.Containers.Vectors
       (Index_Type   => Positive,
        Element_Type => Hilbert.Item.Item_Type,
        "="          => Hilbert.Item."=");
   --  A vector of Items.

   subtype Item_Vector_Type is Item_Vector_Package.Vector;

   function "=" (Left, Right : Item_Vector_Type) return Boolean
   is (Left.Length = Right.Length
       and then
         (for all I in
            Item_Vector_Package.To_Index (Left.First)
            .. Item_Vector_Package.To_Index (Right.Last) =>
            Left.Element (I) = Right.Element (I)));
   --  Compares two Item_Vectors for equality based on their elements.

   package Item_Map_Package is new
     Ada.Containers.Hashed_Maps
       (Key_Type        => UWString,
        Element_Type    => Item_Vector_Type,
        Hash            => Hilbert.Strings.Hash,
        Equivalent_Keys => Hilbert.Strings.Equivalent,
        "="             => "=");
   --  A hash map that maps groups to their items in the pool.

   subtype Item_Map_Type is Item_Map_Package.Map;

end Hilbert.Item;
