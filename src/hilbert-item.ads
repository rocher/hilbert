with Ada.Containers;
with Hilbert.Strings; use Hilbert.Strings;

with Ada.Strings.Text_Buffers;
with Ada.Text_IO;

package Hilbert.Item is

   use all type UWWString;

   Max_Options : constant Positive := 16;

   subtype Number_Options_Type is Positive range 1 .. Max_Options;

   type Difficulty_Type is (Easy, Medium, Hard);

   type Option_Type is record
      Text       : UWWString;
      Is_Correct : Boolean;
   end record;

   type Options_Type is array (Number_Options_Type) of Option_Type;

   type Object is record
      Difficulty     : Difficulty_Type;
      Question       : UWWString;
      Number_Options : Number_Options_Type;
      Options        : Options_Type;
   end record
   with Put_Image => Put_Image_Item;

   overriding
   function "=" (Left, Right : Object) return Boolean
   is (Left.Difficulty = Right.Difficulty
       and then Left.Question = Right.Question
       and then Left.Number_Options = Right.Number_Options
       and then Left.Options = Right.Options);

   procedure Read (Self : out Object; File : in out Ada.Text_IO.File_Type);

   procedure Shuffle_Options (Self : in out Object);

   procedure Put_Image_Item
     (Output : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
      Self   : Object);

end Hilbert.Item;
