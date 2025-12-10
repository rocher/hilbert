with Hilbert.Answer;
with Hilbert.Batch;
with Hilbert.Bit_Stream;
with Hilbert.Strings; use Hilbert.Strings;
with Hilbert.Types; use Hilbert.Types;

package Hilbert.Grade is

   type Grade_Type is record
      Answer : Hilbert.Answer.Answer_Type;
      --  The student's answer information.

      Exam : Hilbert.Batch.Batch_Item_Type;
      --  The Bit_Stream_Item of the correct answers.

      Match : Hilbert.Bit_Stream.Bit_Stream_Type;  -- UString;
      --  #TODO - Make Match more efficient
      --  Matches is a series of symbols that can help GUIs when displaying
      --  results:
      --
      --    Per each item, first character indicates overall match:
      --      'C' indicates a correct answer (typically in green)
      --      'W' indicates a wrong answer (typically in red)
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
      --  ANSWERS:  1101  0001  10    100110  1010  001   11010  1101
      --  CORRECT:  1101  0100  1010  1001    1111  0010  110    101
      --  MATCHES:  C     W     W??   C10     W     W?    C10   W1
      --
      --  The way GUIs interpret this information is up to them, but this
      --  convention allows for a richer representation of the grading
      --  results. The most common way would be to use colors: green for
      --  correct answers, red for wrong answers, and perhaps gray for extra
      --  or missing options.
      --
      --  For example, in a GUI, the first item could be displayed in green,
      --  the second item could be displayed in red. The third item could be
      --  displayed in red with two gray indicators for the missing options.
      --  The fourth item could be displayed in green with a gray indicator
      --  for the extra options '10', and so on.

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
