with Hilbert.Item;
with Hilbert.Pool;
with Hilbert.Strings; use Hilbert.Strings;

package Hilbert.Exam is

   type Exam_Type is record
      Items : Hilbert.Item.Item_Vector_Type;
      --  The items included in this exam.

      Id : UWString := Null_UWString;  --  #FIXME - Use type Exam_ID_Type
      --  The identifier of the exam.

      Num_Options : Natural := 0;
      --  The total number of options of all items.

      Num_Trues : Natural := 0;
      --  The number of correct options of all items.

      Difficulty : Float := 0.0;
      --  The average difficulty of the items in the exam.
   end record;
   --  Represents an exam created from a pool of items.

   function Create_Exam
     (Pool : Hilbert.Pool.Pool_Type; Num_Items : Positive) return Exam_Type
   with
     Pre =>
       Num_Items <= Pool.Num_Items
       and then Num_Items in 1 .. 255;
   --  Creates an exam with the specified number of items from the given pool
   --  of items.

   procedure Set_Id (Self : in out Exam_Type; Id : UWString);
   --  Sets the identifier of the exam to the specified Id.

   function Get_Answers_Bits (Self : Exam_Type) return UString;
   --  Returns the bits representing the correct answers of the exam.

   procedure Write_To (Self : Exam_Type; Out_File : in out WIO.File_Type);
   --  Writes the exam Self to the specified output file.

end Hilbert.Exam;
