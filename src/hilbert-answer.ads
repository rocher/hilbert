with Hilbert.Batch;
with Hilbert.Types;   use Hilbert.Types;
with Hilbert.Strings; use Hilbert.Strings;

package Hilbert.Answer is

   type Object is record
      Date_Time    : UWString := Null_WUString;
      Email        : UWString := Null_WUString;
      Name_Surname : UWString := Null_WUString;
      Exam_Id      : Exam_ID_Type;
      Bit_Stream   : UString := Null_UString;
   end record;
   --  with Put_Image => Put_Image_Answer;

   procedure Open (Answer_Name : Answers_Name_Type);
   procedure Close;

   procedure Read (Self : out Object; End_Of_File : out Boolean);

   function Get_Score
     (Self : Object; Batch : Hilbert.Batch.Object) return Float;

   --  procedure Put_Image_Answer
   --    (Output : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
   --     Self   : Object);
end Hilbert.Answer;
