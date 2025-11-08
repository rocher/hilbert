with Hilbert.Pool;

with Hilbert.Strings; use Hilbert.Strings;

with Ada.Strings.Text_Buffers;

package Hilbert.Exam is

   type Object is record
      Pool       : Hilbert.Pool.Object;
      Difficulty : Float := 0.0;
      Signature  : UString := To_UString ("");
   end record
   with Put_Image => Put_Image_Exam;

   function Create_Exam
     (Pool : Hilbert.Pool.Object; Num_Items : Positive) return Object
   with
     Pre => Num_Items <= Positive (Pool.Length) and then Num_Items in 1 .. 255;

   procedure Put_Image_Exam
     (Output : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
      Self   : Object);

end Hilbert.Exam;
