with Hilbert.Batch;
with Hilbert.Bit_Stream;
with Hilbert.Types;   use Hilbert.Types;
with Hilbert.Strings; use Hilbert.Strings;

package Hilbert.Answer is

   type Answer_Type is record
      Date_Time : UWString := Null_WUString;
      --  The date and time when the answer was submitted.

      Email : UWString := Null_WUString;
      --  The email of the person who submitted the answer.

      Name_Surname : UWString := Null_WUString;
      --  The name and surname of the person who submitted the answer.

      Exam_Id : Exam_ID_Type;
      --  The ID of the exam for which this answer was submitted.

      Bit_Stream : Hilbert.Bit_Stream.Bit_Stream_Type;
      --  The bit stream representing the answers.
   end record;
   --  Represents an answer submitted for an exam.

   procedure Open (Answer_Name : Answers_Name_Type);
   --  Opens the answers file for reading.

   procedure Close;
   --  Closes the answers file.

   procedure Read (Self : out Answer_Type; End_Of_File : out Boolean);
   --  Reads the next answer from the answers file.

   function Get_Score
     (Self : Answer_Type; Batch : Hilbert.Batch.Batch_Type) return Float;
   --  Computes and returns the score for the given answer based on the
   --  provided batch information.

end Hilbert.Answer;
