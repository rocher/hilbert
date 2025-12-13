with Hilbert.Answer;
with Hilbert.Batch;
with Hilbert.Strings;
with Hilbert.Types;

use Hilbert.Strings;
use Hilbert.Strings.CSV_UStrings;
use Hilbert.Types;

package Hilbert.Grade is

   type Grade_Type is record
      Answer : Hilbert.Answer.Answer_Type;
      --  The student's answer information.

      Exam : Hilbert.Batch.Batch_Item_Type;
      --  The Bit_Stream_Item of the correct answers.

      Match : CSV_String;
      --  Matches is a series of symbols that can help GUIs when displaying
      --  results:
      --
      --    Per each item, first character indicates overall match:
      --      'G' indicates a correct answer, in Green
      --      'R' indicates a wrong answer, in Red
      --      'g' indicates an missing or additional options, as well as
      --      unanswered or an additional item, in gray
      --
      --    Subsequent characters, if any, indicate the status of each
      --    additional or missing option of the item:
      --
      --     * '?' indicates that the answer included less options than the
      --       correct one
      --
      --     * '0' or '1' indicates that the answer included extra options
      --       that was not in the correct answer
      --
      --  Example:
      --  ANSWERS:  1101   100110    0001   10      1101          |  10101
      --  CORRECT:  1101   1001      0100   1010    101     1101  |
      --  MATCHES: G1101  G1001g10  R0001  R10g??  R110g1  g????  |  g10101
      --
      --  The way GUIs interpret this information is clear:
      --
      --     'G1101'      <green>1101</green>
      --     'G1001g10'   <green>1001</green><gray>10</gray>
      --     'R0001'      <red>0001</red>
      --     'R10g??'     <red>10</red><gray>??</gray>
      --     'R110g1'     <red>110</red><gray>1</gray>
      --     'g????'      <gray>????</gray>
      --     'g10101'     <gray>10101</gray>

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

   procedure Grade_Class_Exam (Class_Exam : String)
   with Pre => Is_Class_Exam_Name (To_UString (Class_Exam));
   --  Grades all exams for the specified CLASS_EXAM. The answers are read
   --  from the file named <CLASS_EXAM>_Answers.csv, the correct answers are
   --  read from <CLASS_EXAM>_Batch.txt, and the results are written to
   --  <CLASS_EXAM>_Grades.csv.

end Hilbert.Grade;
