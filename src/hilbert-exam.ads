with Hilbert.Pool;

with Hilbert.Strings; use Hilbert.Strings;

with Ada.Strings.Text_Buffers;

package Hilbert.Exam is

   type Object is record
      Pool       : Hilbert.Pool.Object;
      Number     : Natural := 0;
      Difficulty : Float := 0.0;
      Signature  : UString := Null_UString;
   end record
   with Put_Image => Put_Image_Exam;

   function Create_Exam
     (Pool : Hilbert.Pool.Object; Num_Items : Positive) return Object
   with
     Pre => Num_Items <= Positive (Pool.Length) and then Num_Items in 1 .. 255;

   procedure Set_Number (Self : in out Object; New_Number : Natural);

   procedure Write (Self : Object; Out_File : in out WIO.File_Type);

   procedure Put_Image_Exam
     (Output : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
      Self   : Object);

end Hilbert.Exam;
