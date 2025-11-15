with Hilbert.Strings; use Hilbert.Strings;

package Hilbert.Types is

   Cycle_Length : constant Integer := 3;
   Level_Length : constant Integer := 1;
   Group_Length : constant Integer := 1;
   Class_Length : constant Integer :=
     Cycle_Length + Level_Length + Group_Length;

   Course_Length    : constant Integer := 3;
   RA_Length        : constant Integer := 3;
   Date_Length      : constant Integer := 6;
   Pool_Name_Length : constant Integer :=
     Cycle_Length + Level_Length + 1 + Course_Length + 1 + RA_Length;

   Exams_Name_Length : constant Integer := Pool_Name_Length + 1 + Date_Length;
   Sequence_Length   : constant Integer := 3;
   Sequence_Last     : constant Integer := 999;

   Exam_ID_Length : constant Integer :=
     Exams_Name_Length + 1 + Sequence_Length;

   Answers_Name_Length : constant Integer :=
     Class_Length + 1 + Course_Length + 1 + RA_Length + 1 + Date_Length;

   subtype Cycle_Type is String (1 .. Cycle_Length);
   subtype Level_Type is Positive range 1 .. 9;
   subtype Group_Type is Character range 'A' .. 'Z';
   subtype Class_Type is String (1 .. Class_Length);
   subtype Course_Type is String (1 .. Course_Length);
   subtype RA_Type is String (1 .. RA_Length);
   subtype Date_Type is String (1 .. Date_Length);
   subtype Pool_Name_Type is String (1 .. Pool_Name_Length);
   subtype Exams_Name_Type is String (1 .. Exams_Name_Length);
   subtype Sequence_Type is Positive range 1 .. Sequence_Last;
   subtype Exam_ID_Type is String (1 .. Exam_ID_Length);
   subtype Answers_Name_Type is String (1 .. Answers_Name_Length);

   function Is_Cycle (C : UString) return Boolean;
   function Is_Level (L : UString) return Boolean;
   function Is_Group (G : UString) return Boolean;
   function Is_Class (C : UString) return Boolean;
   function Is_Course (C : UString) return Boolean;
   function Is_RA (R : UString) return Boolean;
   function Is_Date (D : UString) return Boolean;
   function Is_Pool_Name (P : UString) return Boolean;
   function Is_Exams_Name (E : UString) return Boolean;
   function Is_Exam_ID (I : UString) return Boolean;
   function Is_Answers_Name (A : UString) return Boolean;

   function Cycle (C : UString) return Cycle_Type
   is (Cycle_Type'(To_String (C)))
   with Pre => Is_Cycle (C);

   function Level (L : UString) return Level_Type
   is (Level_Type'Value (To_String (L)))
   with Pre => Is_Level (L);

   function Level_Char (L : Level_Type) return Character
   is (Character'Val (Character'Pos ('0') + L));

   function Group (S : UString) return Group_Type
   is (Group_Type'(To_String (S)(1)))
   with Pre => Is_Group (S);

   function Class (S : UString) return Class_Type
   is (Class_Type'(To_String (S)))
   with Pre => Is_Class (S);

   function Class
     (C : Cycle_Type; L : Level_Type; G : Group_Type) return Class_Type
   is (Class_Type'(C & Level_Char (L) & G));

   function Course (S : UString) return Course_Type
   is (Course_Type'(To_String (S)))
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
   with Pre => Is_Exams_Name (S);

   function Exam_ID (S : UString) return Exam_ID_Type
   is (Exam_ID_Type'(To_String (S)))
   with Pre => Is_Exam_ID (S);

   function Answers_Name (S : UString) return Answers_Name_Type
   is (Answers_Name_Type'(To_String (S)))
   with Pre => Is_Answers_Name (S);

end Hilbert.Types;
