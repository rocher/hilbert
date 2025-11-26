with Hilbert.Strings; use Hilbert.Strings;

package Hilbert.Types is

   Cycle_Length : constant Integer := 3;         --  SMX
   Level_Length : constant Integer := 1;         --  1..9
   Group_Length : constant Integer := 1;         --  A..Z
   Class_Length : constant Integer :=            --  SMX1A
     Cycle_Length
     + Level_Length
     + Group_Length;

   Module_Length : constant Integer := 3;     --  MUN, DIG, SOS, ...
   RA_Length     : constant Integer := 3;     --  RA1 .. RA9 RAA .. RAF
   Date_Length   : constant Integer := 6;     --  YYYYMM

   Pool_Name_Length : constant Integer :=
     Cycle_Length + Level_Length + 1 + Module_Length + 1 + RA_Length;
   --  e.g., "SMX1_MUN_RA8" => File: "SMX1_MUN_RA8_Pool.txt"

   Batch_Name_Length : constant Integer := Pool_Name_Length;
   --  e.g., "SMX1_MUN_RA8" => File: "SMX1_MUN_RA8_Batch.txt"

   Exams_Name_Length : constant Integer := Pool_Name_Length + 1 + Date_Length;
   --  e.g., SMX1_MUN_RA8_202511 => File: "SMX1_MUN_RA8_202511_Exams.txt"

   Sequence_Length : constant Integer := 3;     --  001 .. 999
   Sequence_Last   : constant Integer := 999;   --  Maximum sequence number

   Class_Exam_Name_Length : constant Integer :=
     Class_Length + 1 + Module_Length + 1 + RA_Length + 1 + Date_Length;
   --  e.g., "SMX1A_MUN_RA8_202511" => File: "SMX1A_MUN_RA8_202511_Answers.csv"
   --                               => File: "SMX1A_MUN_RA8_202511_Grades.csv"

   Exam_ID_Length : constant Integer :=          --  SMX1A_MUN_RA8_202511/001
     Exams_Name_Length
     + 1
     + Sequence_Length;

   Answers_Name_Length : constant Integer := Class_Exam_Name_Length;
   --  e.g., "SMX1A_MUN_RA8_202511" => File: "SMX1A_MUN_RA8_202511_Answers.csv"

   Grades_Name_Length : constant Integer := Class_Exam_Name_Length;
   --  e.g., "SMX1A_MUN_RA8_202511" => File: "SMX1A_MUN_RA8_202511_Grades.csv"

   subtype Cycle_Type is String (1 .. Cycle_Length);
   --  e.g., "SMX", "DAM", "DAW"

   subtype Level_Type is Positive range 1 .. 9;
   --  e.g., 1, 2, ..., 9

   subtype Group_Type is Character range 'A' .. 'Z';
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

   subtype Exams_Name_Type is String (1 .. Exams_Name_Length);
   --  e.g., "SMX1_MUN_RA8_202511"  => File: "SMX1_MUN_RA8_202511_Exams.txt"
   --                               => File: "SMX1_MUN_RA8_202511_Exams.tex"
   --                               => File: "SMX1_MUN_RA8_202511_Exams.pdf"

   subtype Sequence_Type is Positive range 1 .. Sequence_Last;
   --  e.g., 1, 2, ..., 999

   subtype Class_Exam_Name_Type is String (1 .. Class_Exam_Name_Length);
   --  e.g., "SMX1A_MUN_RA8_202511"

   subtype Exam_ID_Type is String (1 .. Exam_ID_Length);
   --  e.g., "SMX1_MUN_RA8_202511/001"

   subtype Answers_Name_Type is String (1 .. Answers_Name_Length);
   --  e.g., "SMX1A_MUN_RA8_202511" => File: "SMX1A_MUN_RA8_202511_Answers.csv"

   subtype Grades_Name_Type is String (1 .. Grades_Name_Length);
   --  e.g., "SMX1A_MUN_RA8_202511" => File: "SMX1A_MUN_RA8_202511_Grades.csv"

   function Is_Cycle (C : UString) return Boolean;
   function Is_Level (L : UString) return Boolean;
   function Is_Group (G : UString) return Boolean;
   function Is_Class (C : UString) return Boolean;
   function Is_Module (M : UString) return Boolean;
   function Is_Course (C : UString) return Boolean;
   function Is_RA (R : UString) return Boolean;
   function Is_Date (D : UString) return Boolean;
   function Is_Pool_Name (P : UString) return Boolean;
   function Is_Exam_Name (E : UString) return Boolean;
   function Is_Class_Exam_Name (C : UString) return Boolean;
   function Is_Exam_ID (I : UString) return Boolean;

   function Is_Class_Exam_Name (S : String) return Boolean
   is (Is_Class_Exam_Name (To_UString (S)));

   function Is_Answers_Name (A : UString) return Boolean
   renames Is_Class_Exam_Name;

   function Is_Grades_Name (G : UString) return Boolean
   renames Is_Class_Exam_Name;

   function Cycle (C : UString) return Cycle_Type
   is (Cycle_Type'(To_String (C)))
   with Pre => Is_Cycle (C);

   function Level (L : UString) return Level_Type
   is (Level_Type'Value (To_String (L)))
   with Pre => Is_Level (L);

   function Level_Char (L : Level_Type) return Character
   is (Character'Val (Character'Pos ('0') + L));

   function Group (S : UString) return Group_Type
   is (Group_Type'(To_String (S) (1)))
   with Pre => Is_Group (S);

   function Class (S : UString) return Class_Type
   is (Class_Type'(To_String (S)))
   with Pre => Is_Class (S);

   function Class
     (C : Cycle_Type; L : Level_Type; G : Group_Type) return Class_Type
   is (Class_Type'(C & Level_Char (L) & G));

   function Course (S : UString) return Module_Type
   is (Module_Type'(To_String (S)))
   with Pre => Is_Course (S);

   function RA (S : UString) return RA_Type
   is (RA_Type'(To_String (S)))
   with Pre => Is_RA (S);

   function Date (S : UString) return Date_Type
   is (Date_Type'(To_String (S)))
   with Pre => Is_Date (S);

   function Pool_Name (S : UString) return Pool_Name_Type
   is (Pool_Name_Type'(To_String (S)))
   with Pre => Is_Pool_Name (S);

   function Exams_Name (S : UString) return Exams_Name_Type
   is (Exams_Name_Type'(To_String (S)))
   with Pre => Is_Exam_Name (S);

   function Exam_ID (S : UString) return Exam_ID_Type
   is (Exam_ID_Type'(To_String (S)))
   with Pre => Is_Exam_ID (S);

   function Answers_Name (A : UString) return Answers_Name_Type
   is (Answers_Name_Type'(To_String (A)))
   with Pre => Is_Answers_Name (A);

   function Get_Cycle (C : Class_Type) return Cycle_Type
   is (Cycle_Type'(C (1 .. Cycle_Length)))
   with Pre => Is_Class (To_UString (C));

   function Get_Level (C : Class_Type) return Level_Type
   is (Level_Type'Value (String'("" & C (Cycle_Length + 1))))
   with Pre => Is_Class (To_UString (C));

   function Get_Exams_Name (C : Class_Exam_Name_Type) return Exams_Name_Type;

end Hilbert.Types;
