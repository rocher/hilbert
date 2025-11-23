with Hilbert.Answer;
with Hilbert.Batch;
with Hilbert.Bit_Stream;
with Hilbert.Types;   use Hilbert.Types;

package Hilbert.Grade is

   type Grade_Type is record
      Answer : Hilbert.Answer.Answer_Type;
      --  The student's answer information.

      Exam : Hilbert.Batch.Batch_Item_Type;
      --  The Bit_Stream_Item of the correct answers.

      Match : Hilbert.Bit_Stream.Bit_Stream_Type;
      --  The bitwise comparison between the Batch.Bit_Stream and
      --  Answer.Bit_Stream. '1's indicate bits that match, '0' indicates bits
      --  that differ. If the Answer has fewer bits, the missing bits are zero
      --  in Match. If the Answer has extra bits, those bits are ignored in
      --  Match.

      --  For example:
      --  ANSWERS: 1101 0001 1010 100  10010
      --  CORRECT: 1101 0100 1010 1001 1111
      --  MATCHES: 1111 1010 1111 1110 1111

      Score : Natural := 0;
      --  The score assigned to this exam based on the total number of
      --  matching bits.
   end record;
   pragma Style_Checks (Off);
   --  Represents the grading information for a single Bit_Stream_Item (exam
   --  answers).

   --  The filename is expected to follow the format
   --  <GROUP_EXAM_ID>_Grades.csv, where GROUP_EXAM_ID is the identifier of
   --  the exam group. For example: SMX1A_DIG_RA2_202511_Grades.csv

   --  The format of the grades file is as follows. For each exam, there are
   --  three lines:
   --  1. The line starting with "ANSWERS" contains the submitted answers.
   --     Format:
   --     ANSWERS,<Date_Time>,<Email>,<Name_Surname>,<Exam_ID>,<Bit_Stream>
   --  2. The line starting with "CORRECT" contains the correct answers.
   --     Format:
   --     CORRECT,<Exam_ID>,<Bit_Stream>
   --  3. The line starting with "MATCHES" contains the bitwise comparison
   --     between the submitted answers and the correct answers. '1's indicate
   --     matching bits, '0's indicate differing bits.
   --     Format:
   --     MATCHES,<Email>,<Name_Surname>,<Exam_ID>,<Bit_Stream>
   --  4. The line starting with "SCORES" contains the scoring information.
   --     Format:
   --     SCORES,<Email>,<Name_Surname>,<Exam_ID>,<Total_Score>/<Max_Possible>,<Final_Score_Over_10>,<Rounded_Final_Score_Over_10>
   pragma Style_Checks (On);

   procedure Evaluate
     (Self   : in out Grade_Type;
      Answer : Hilbert.Answer.Answer_Type;
      Exam   : Hilbert.Batch.Batch_Item_Type);
   --  Determines the Match and Score fields of the Grade based on the
   --  provided Answer and Exam. The Match field is computed by comparing the
   --  bits of the Answer's Bit_Stream with the Exam's Bit_Stream. The Score
   --  is the count of fully correct Bit_Stream_Items (where all bits match).

   procedure Open (Grade_Name : Grades_Name_Type);
   --  Opens the grades file for writing.

   procedure Close;
   --  Closes the grades file.

   procedure Write (Self : Grade_Type);
   --  Writes the grading information of the Grade to the opened grades file.

end Hilbert.Grade;
