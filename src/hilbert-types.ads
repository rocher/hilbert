with Hilbert.Constants; use Hilbert.Constants;
with Hilbert.Strings;   use Hilbert.Strings;

package Hilbert.Types is

   ---------------
   --  Lengths  --
   ---------------

   Cycle_Length  : constant Integer := 3;         --  SMX
   Level_Length  : constant Integer := 1;         --  1..9
   Course_Length : constant Integer :=            --  SMX1
     Cycle_Length
     + Level_Length;
   Group_Length  : constant Integer := 1;         --  A..Z
   Class_Length  : constant Integer :=            --  SMX1A
     Course_Length
     + Group_Length;

   Module_Length : constant Integer := 3;     --  MUN, DIG, SOS, ...
   RA_Length     : constant Integer := 3;     --  RA1 .. RA9 RAA .. RAF
   Date_Length   : constant Integer := 6;     --  YYYYMM

   Pool_Name_Length : constant Integer :=
     Cycle_Length + Level_Length + 1 + Module_Length + 1 + RA_Length;
   --  e.g., "SMX1_MUN_RA8" => File: "SMX1_MUN_RA8_Pool.txt"

   Pool_Filename_Length : constant Integer :=
     Pool_Name_Length + Pool_Suffix'Length;
   --  e.g., "SMX1_MUN_RA8_Pool.txt"

   Batch_Name_Length : constant Integer := Pool_Name_Length;
   --  e.g., "SMX1_MUN_RA8" => File: "SMX1_MUN_RA8_Batch.txt"

   Exam_Name_Length : constant Integer := Pool_Name_Length + 1 + Date_Length;
   --  e.g., SMX1_MUN_RA8_202511 => File: "SMX1_MUN_RA8_202511_Exams.txt"

   Exams_Filename_Length : constant Integer :=
     Exam_Name_Length + Exams_Suffix'Length;
   --  e.g., "SMX1_MUN_RA8_202511_Exams.txt"

   Batch_Filename_Length : constant Integer :=
     Exam_Name_Length + Batch_Suffix'Length;
   --  e.g., "SMX1_MUN_RA8_202511_Batch.txt"

   Sequence_Length : constant Integer := 3;     --  001 .. 999
   Sequence_Last   : constant Integer := 999;   --  Maximum sequence number

   Exam_ID_Length : constant Integer :=         --  SMX1A_MUN_RA8_202511/001
     Exam_Name_Length
     + 1
     + Sequence_Length;

   Class_Exam_Name_Length : constant Integer :=
     Class_Length + 1 + Module_Length + 1 + RA_Length + 1 + Date_Length;
   --  e.g., "SMX1A_MUN_RA8_202511" => File: "SMX1A_MUN_RA8_202511_Answers.csv"
   --                               => File: "SMX1A_MUN_RA8_202511_Grades.csv"

   Answers_Filename_Length : constant Integer :=
     Class_Exam_Name_Length + Answers_Suffix'Length;
   --  e.g., "SMX1A_MUN_RA8_202511" => File: "SMX1A_MUN_RA8_202511_Answers.csv"

   Grades_Filename_Length : constant Integer :=
     Class_Exam_Name_Length + Grades_Suffix'Length;
   --  e.g., "SMX1A_MUN_RA8_202511" => File: "SMX1A_MUN_RA8_202511_Grades.csv"

   -------------
   --  Types  --
   -------------

   subtype Cycle_Type is String (1 .. Cycle_Length);
   --  e.g., "SMX", "DAM", "DAW"

   subtype Level_Type is String (1 .. Level_Length);
   --  e.g., 1, 2, ..., 9

   subtype Course_Type is String (1 .. Course_Length);
   --  e.g., "SMX1", "DAM2", "DAW1"

   subtype Group_Type is String (1 .. Group_Length);
   --  e.g., 'A', 'B', ..., 'Z'

   subtype Class_Type is String (1 .. Class_Length);
   --  e.g., "SMX1A", "DAM2B", "DAW1C"

   subtype Module_Type is String (1 .. Module_Length);
   --  e.g., "MUN", "DIG", "SOS"

   subtype RA_Type is String (1 .. RA_Length);
   --  e.g., "RA1", "RA8", "RAA", "RAF"

   subtype Date_Type is String (1 .. Date_Length);
   --  e.g., "202511" (November 2025)

   subtype Pool_Name_Type is String (1 .. Pool_Name_Length);
   --  e.g., "SMX1_MUN_RA8"         => File: "SMX1_MUN_RA8_Pool.txt"

   subtype Pool_Filename_Type is String (1 .. Pool_Filename_Length);
   --  e.g., "SMX1_MUN_RA8_Pool.txt"

   subtype Exam_Name_Type is String (1 .. Exam_Name_Length);
   --  e.g., "SMX1_MUN_RA8_202511"  => File: "SMX1_MUN_RA8_202511_Exams.txt"
   --                               => File: "SMX1_MUN_RA8_202511_Exams.tex"
   --                               => File: "SMX1_MUN_RA8_202511_Exams.pdf"

   subtype Exams_Filename_Type is String (1 .. Exams_Filename_Length);
   --  e.g., "SMX1_MUN_RA8_202511_Exams.txt"

   subtype Batch_Filename_Type is String (1 .. Batch_Filename_Length);
   --  e.g., "SMX1_MUN_RA8_202511_Batch.txt"

   subtype Sequence_Type is Positive range 1 .. Sequence_Last;
   --  e.g., 1, 2, ..., 999

   subtype Exam_ID_Type is String (1 .. Exam_ID_Length);
   --  e.g., "SMX1_MUN_RA8_202511/001"

   subtype Class_Exam_Name_Type is String (1 .. Class_Exam_Name_Length);
   --  e.g., "SMX1A_MUN_RA8_202511"

   subtype Answers_Filename_Type is String (1 .. Answers_Filename_Length);
   --  e.g., "SMX1A_MUN_RA8_202511_Answers.csv"

   subtype Grades_Filename_Type is String (1 .. Grades_Filename_Length);
   --  e.g., "SMX1A_MUN_RA8_202511_Grades.csv"

   --------------------------
   --  Checking functions  --
   --------------------------

   function Is_Cycle (S : String) return Boolean;
   function Is_Cycle (U : UString) return Boolean
   is (Is_Cycle (To_String (U)));

   function Has_Cycle (S : String) return Boolean;
   function Has_Cycle (U : UString) return Boolean
   is (Has_Cycle (To_String (U)));

   function Is_Level (S : String) return Boolean;
   function Is_Level (U : UString) return Boolean
   is (Is_Level (To_String (U)));

   function Is_Course (S : String) return Boolean;
   function Is_Course (U : UString) return Boolean
   is (Is_Course (To_String (U)));

   function Has_Course (S : String) return Boolean;
   function Has_Course (U : UString) return Boolean
   is (Has_Course (To_String (U)));

   function Is_Group (S : String) return Boolean;
   function Is_Group (U : UString) return Boolean
   is (Is_Group (To_String (U)));

   function Is_Class (S : String) return Boolean;
   function Is_Class (U : UString) return Boolean
   is (Is_Class (To_String (U)));

   function Has_Class (S : String) return Boolean;
   function Has_Class (U : UString) return Boolean
   is (Has_Class (To_String (U)));

   function Is_Module (S : String) return Boolean;
   function Is_Module (U : UString) return Boolean
   is (Is_Module (To_String (U)));

   function Is_RA (S : String) return Boolean;
   function Is_RA (U : UString) return Boolean
   is (Is_RA (To_String (U)));

   function Is_Date (S : String) return Boolean;
   function Is_Date (U : UString) return Boolean
   is (Is_Date (To_String (U)));

   function Is_Pool_Name (S : String) return Boolean;
   function Is_Pool_Name (U : UString) return Boolean
   is (Is_Pool_Name (To_String (U)));

   function Has_Pool_Name (S : String) return Boolean;
   function Has_Pool_Name (U : UString) return Boolean
   is (Has_Pool_Name (To_String (U)));

   function Is_Pool_Filename (S : String) return Boolean;
   function Is_Pool_Filename (U : UString) return Boolean
   is (Is_Pool_Filename (To_String (U)));

   function Is_Exam_Name (S : String) return Boolean;
   function Is_Exam_Name (U : UString) return Boolean
   is (Is_Exam_Name (To_String (U)));

   function Has_Exam_Name (S : String) return Boolean;
   function Has_Exam_Name (U : UString) return Boolean
   is (Has_Exam_Name (To_String (U)));

   function Is_Exams_Filename (S : String) return Boolean;
   function Is_Exams_Filename (U : UString) return Boolean
   is (Is_Exams_Filename (To_String (U)));

   function Is_Batch_Filename (S : String) return Boolean;
   function Is_Batch_Filename (U : UString) return Boolean
   is (Is_Batch_Filename (To_String (U)));

   function Is_Exam_ID (S : String) return Boolean;
   function Is_Exam_ID (U : UString) return Boolean
   is (Is_Exam_ID (To_String (U)));

   function Is_Class_Exam_Name (S : String) return Boolean;
   function Is_Class_Exam_Name (U : UString) return Boolean
   is (Is_Class_Exam_Name (To_String (U)));

   function Has_Class_Exam_Name (S : String) return Boolean;
   function Has_Class_Exam_Name (U : UString) return Boolean
   is (Has_Class_Exam_Name (To_String (U)));

   function Is_Answers_Filename (S : String) return Boolean;
   function Is_Answers_Filename (U : UString) return Boolean
   is (Is_Answers_Filename (To_String (U)));

   function Is_Grades_Filename (S : String) return Boolean;
   function Is_Grades_Filename (U : UString) return Boolean
   is (Is_Grades_Filename (To_String (U)));

   ---------------
   --  Getters  --
   ---------------

   function Get_Cycle (S : String) return Cycle_Type
   with Pre => Has_Cycle (S), Post => Is_Cycle (Get_Cycle'Result);
   function Get_Cycle (U : UString) return Cycle_Type
   is (Get_Cycle (To_String (U)));

   function Get_Level (S : String) return Level_Type
   with Pre => Has_Course (S), Post => Is_Level (Get_Level'Result);
   function Get_Level (U : UString) return Level_Type
   is (Get_Level (To_String (U)));

   function Get_Course (S : String) return Course_Type
   with Pre => Has_Course (S), Post => Is_Course (Get_Course'Result);
   function Get_Course (U : UString) return Course_Type
   is (Get_Course (To_String (U)));

   function Get_Group (S : String) return Group_Type
   with Pre => Has_Class (S), Post => Is_Group (Get_Group'Result);
   function Get_Group (U : UString) return Group_Type
   is (Get_Group (To_String (U)));

   function Get_Class (S : String) return Class_Type
   with Pre => Has_Class (S), Post => Is_Class (Get_Class'Result);
   function Get_Class (U : UString) return Class_Type
   is (Get_Class (To_String (U)));

   function Get_Module (S : String) return Module_Type
   with
     Pre  => Has_Pool_Name (S) or else Has_Class_Exam_Name (S),
     Post => Is_Module (Get_Module'Result);
   function Get_Module (U : UString) return Module_Type
   is (Get_Module (To_String (U)));

   function Get_RA (S : String) return RA_Type
   with
     Pre  => Has_Pool_Name (S) or else Has_Class_Exam_Name (S),
     Post => Is_RA (Get_RA'Result);
   function Get_RA (U : UString) return RA_Type
   is (Get_RA (To_String (U)));

   function Get_Date (S : String) return Date_Type
   with
     Pre  => Has_Exam_Name (S) or else Has_Class_Exam_Name (S),
     Post => Is_Date (Get_Date'Result);
   function Get_Date (U : UString) return Date_Type
   is (Get_Date (To_String (U)));

   function Get_Pool_Name (S : String) return Pool_Name_Type
   with
     Pre  => Has_Pool_Name (S) or else Has_Class_Exam_Name (S),
     Post => Is_Pool_Name (Get_Pool_Name'Result);
   function Get_Pool_Name (U : UString) return Pool_Name_Type
   is (Get_Pool_Name (To_String (U)));

   function Get_Exam_Name (S : String) return Exam_Name_Type
   with
     Pre  => Has_Exam_Name (S) or else Has_Class_Exam_Name (S),
     Post => Is_Exam_Name (Get_Exam_Name'Result);
   function Get_Exam_Name (U : UString) return Exam_Name_Type
   is (Get_Exam_Name (To_String (U)));

   function Get_Class_Exam_Name (S : String) return Class_Exam_Name_Type
   with
     Pre  => Has_Class_Exam_Name (S),
     Post => Is_Class_Exam_Name (Get_Class_Exam_Name'Result);
   function Get_Class_Exam_Name (U : UString) return Class_Exam_Name_Type
   is (Get_Class_Exam_Name (To_String (U)));

   procedure Test_Hilbert_Types;

end Hilbert.Types;
