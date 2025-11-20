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
   pragma Style_Checks (Off);
   --  Represents an answer submitted for an exam. It contains metadata about
   --  the submission as well as the bit stream of answers. The filename for the
   --  answers is expected to follow the format <Exam_ID>_Answers.csv.

   --  Each answer is stored in a CSV file with the following format:
   --  <Date_Time>,<Email>,<Name_Surname>,<Exam_ID>,<Bit_Stream>

   --  Example:
   --  14/11/2025 12:17:29,blah@inspalamos.cat,Blah Blah,SMX1_DIG_RA2_202511/010,1011 010 00110 101100 1010 0010 1111 0010 01111 1101 010 0100 0010 1001 1000 10100 1000 0001 0010 00111 0100 111 0111 10011 00101 1001 1000 111 1000 01101 010111 01001 0101 10011 0101 10110 101 110101
   pragma Style_Checks (On);

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
