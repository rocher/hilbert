with Ada.Containers.Vectors;
with Ada.Strings.Text_Buffers;

with Hilbert.Strings; use Hilbert.Strings;

package Hilbert.Item is

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

      In_All_Exams : Boolean := False;
      --  Indicates whether the item should appear in all exams.
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

end Hilbert.Item;
