with Ada.Strings.Text_Buffers;

with Hilbert.Pool;
with Hilbert.Strings; use Hilbert.Strings;

package Hilbert.Exam is

   type Object is record
      Pool : Hilbert.Pool.Object;
      --  The pool of items contained in this exam.

      Id : UWString := Null_WUString;
      --  The identifier of the exam.

      Signature : UWString := Null_WUString;
      --  The signature of the exam.

      Num_Options : Natural := 0;
      --  The total number of options of all items.

      Num_Trues : Natural := 0;
      --  The number of correct options of all items.

      Difficulty : Float := 0.0;
      --  The average difficulty of the items in the exam.
   end record
   with Put_Image => Put_Image_Exam;
   --  Represents an exam created from a pool of items.

   function Create_Exam
     (Pool : Hilbert.Pool.Object; Num_Items : Positive) return Object
   with
     Pre =>
       Num_Items <= Positive (Pool.Items.Length)
       and then Num_Items in 1 .. 255;
   --  Creates an exam with the specified number of items from the given pool
   --  of items.

   procedure Set_Id (Self : in out Object; Id : UWString);
   --  Sets the identifier of the exam to the specified Id.

   procedure Write_To (Self : Object; Out_File : in out WIO.File_Type);
   --  Writes the exam Self to the specified output file.

   procedure Put_Image_Exam
     (Output : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
      Self   : Object);
   --  Outputs a textual representation of the exam to the specified output
   --  buffer.

end Hilbert.Exam;
