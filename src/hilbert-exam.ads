with Hilbert.Pool;

with Hilbert.Strings; use Hilbert.Strings;

with Ada.Strings.Text_Buffers;

package Hilbert.Exam is

   type Object is record
      Pool        : Hilbert.Pool.Object;
      Id          : UString := Null_UString;
      Signature   : UString := Null_UString;
      Num_Options : Natural := 0;
      Num_Trues   : Natural := 0;
      Difficulty  : Float := 0.0;
   end record
   with Put_Image => Put_Image_Exam;

   function Create_Exam
     (Pool : Hilbert.Pool.Object; Num_Items : Positive) return Object
   with
     Pre => Num_Items <= Positive (Pool.Length) and then Num_Items in 1 .. 255;

   procedure Set_Id (Self : in out Object; Id : UString);

   procedure Write_To (Self : Object; Out_File : in out WIO.File_Type);

   procedure Put_Image_Exam
     (Output : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
      Self   : Object);

end Hilbert.Exam;
