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

   type Options_Type is array (Num_Options_Type) of Option_Type;

   type Object is record
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
   end record
   with Put_Image => Put_Image_Item;
   --  Represents an item (question) in a pool or exam.

   overriding
   function "=" (Left, Right : Object) return Boolean
   is (Left.Difficulty = Right.Difficulty
       and then Left.Question = Right.Question
       and then Left.Num_Options = Right.Num_Options
       and then Left.Options = Right.Options);
   --  Compares two Items for equality based on their fields.

   procedure Read_From (Self : out Object; In_File : in out WIO.File_Type);
   --  Reads an item from the specified input file into Self.

   procedure Write_To (Self : Object; Out_File : in out WIO.File_Type);
   --  Writes the item Self to the specified output file.

   procedure Shuffle_Options (Self : in out Object);
   -- Shuffles the options of the item Self randomly.

   procedure Put_Image_Item
     (Output : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
      Self   : Object);
   --  Outputs a textual representation of the item to the specified output
   --  buffer.

end Hilbert.Item;
