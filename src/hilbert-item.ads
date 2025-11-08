with Hilbert.Strings; use Hilbert.Strings;

with Ada.Strings.Text_Buffers;

package Hilbert.Item is

   use all type UString;

   Max_Options : constant Positive := 16;

   subtype Num_Options_Type is Positive range 1 .. Max_Options;

   type Difficulty_Type is (Easy, Medium, Hard);

   type Option_Type is record
      Is_Correct : Boolean;
      Text       : UString;
   end record;

   type Options_Type is array (Num_Options_Type) of Option_Type;

   type Object is record
      Number      : Natural := 0;
      Difficulty  : Difficulty_Type;
      Question    : UString;
      Num_Options : Num_Options_Type;
      Options     : Options_Type;
   end record
   with Put_Image => Put_Image_Item;

   overriding
   function "=" (Left, Right : Object) return Boolean
   is (Left.Difficulty = Right.Difficulty
       and then Left.Question = Right.Question
       and then Left.Num_Options = Right.Num_Options
       and then Left.Options = Right.Options);

   procedure Read (Self : out Object; In_File : in out WIO.File_Type);
   procedure Write (Self : Object; Out_File : in out WIO.File_Type);

   procedure Shuffle_Options (Self : in out Object);

   procedure Put_Image_Item
     (Output : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
      Self   : Object);

end Hilbert.Item;
