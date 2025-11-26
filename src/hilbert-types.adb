with Ada.Characters.Handling; use Ada.Characters.Handling;

package body Hilbert.Types is

   -------------------
   -- Is_All_Digits --
   -------------------

   function Is_All_Digits (S : String) return Boolean
   is (for all C of S => Ada.Characters.Handling.Is_Digit (C));

   ------------------
   -- Is_All_Upper --
   ------------------

   function Is_All_Upper (S : String) return Boolean
   is (for all C of S => Ada.Characters.Handling.Is_Upper (C));

   --------------
   -- Is_Cycle --
   --------------

   function Is_Cycle (C : UString) return Boolean is
      S : constant String := To_String (C);
   begin
      return S'Length = Cycle_Length and then Is_All_Upper (S);
   end Is_Cycle;

   --------------
   -- Is_Level --
   --------------

   function Is_Level (L : UString) return Boolean is
      S : constant String := To_String (L);
   begin
      return S'Length = Level_Length and then Is_All_Digits (S);
   end Is_Level;

   --------------
   -- Is_Group --
   --------------

   function Is_Group (G : UString) return Boolean is
      S : constant String := To_String (G);
   begin
      return S'Length = Group_Length and then Is_All_Upper (S);
   end Is_Group;

   --------------
   -- Is_Class --
   --------------

   function Is_Class (C : UString) return Boolean is
      S : constant String := To_String (C);
   begin
      return
        S'Length = Class_Length
        and then Is_Cycle (C.Unbounded_Slice (1, Cycle_Length))
        and then Is_Level
                   (C.Unbounded_Slice
                      (Cycle_Length + 1, Cycle_Length + Level_Length))
        and then Is_Group
                   (C.Unbounded_Slice
                      (Cycle_Length + Level_Length + 1,
                       Cycle_Length + Level_Length + Group_Length));
   end Is_Class;

   ---------------
   -- Is_Module --
   ---------------

   function Is_Module (M : UString) return Boolean is
   begin
      return M.Length = Module_Length;
   end Is_Module;

   ---------------
   -- Is_Course --
   ---------------

   function Is_Course (C : UString) return Boolean is
      S : constant String := To_String (C);
   begin
      return S'Length = Module_Length and then Is_All_Upper (S);
   end Is_Course;

   -----------
   -- Is_RA --
   -----------

   function Is_RA (R : UString) return Boolean is
      S : constant String := To_String (R);
   begin
      return
        S'Length = RA_Length
        and then S (1 .. 2) = "RA"
        and then Is_Digit (S (3));
   end Is_RA;

   -------------
   -- Is_Date --
   -------------

   function Is_Date (D : UString) return Boolean is
      S : constant String := To_String (D);
   begin
      return
        S'Length = Date_Length
        and then Is_All_Digits (S)
        and then Integer'Value (S (1 .. 4)) >= 2000
        and then Integer'Value (S (5 .. 6)) >= 1
        and then Integer'Value (S (5 .. 6)) <= 12;
   end Is_Date;

   ------------------
   -- Is_Pool_Name --
   ------------------

   function Is_Pool_Name (P : UString) return Boolean is
      S : constant String := To_String (P);
   begin
      return
        S'Length = Pool_Name_Length
        and then Is_Cycle (P.Unbounded_Slice (1, Cycle_Length))
        and then Is_Level
                   (P.Unbounded_Slice
                      (Cycle_Length + 1, Cycle_Length + Level_Length))
        and then S (Cycle_Length + Level_Length + 1) = '_'
        and then Is_Course
                   (P.Unbounded_Slice
                      (Cycle_Length + Level_Length + 2,
                       Cycle_Length + Level_Length + Module_Length + 1))
        and then S (Cycle_Length + Level_Length + Module_Length + 2) = '_'
        and then Is_RA
                   (P.Unbounded_Slice
                      (Cycle_Length + Level_Length + Module_Length + 3,
                       Cycle_Length
                       + Level_Length
                       + Module_Length
                       + RA_Length
                       + 2));
   end Is_Pool_Name;

   ------------------
   -- Is_Exam_Name --
   ------------------

   function Is_Exam_Name (E : UString) return Boolean is
      S : constant String := To_String (E);
   begin
      return
        S'Length = Exams_Name_Length
        and then Is_Pool_Name (E.Unbounded_Slice (1, Pool_Name_Length))
        and then S (Pool_Name_Length + 1) = '_'
        and then Is_Date (E.Unbounded_Slice (Pool_Name_Length + 2, S'Last));
   end Is_Exam_Name;

   ------------------------
   -- Is_Class_Exam_Name --
   ------------------------

   function Is_Class_Exam_Name (C : UString) return Boolean is
      S : constant String := To_String (C);
   begin
      --  ccccc mmm rrr dddddd
      --  SMX1C_DIG_RA2_202511
      return
        S'Length = Class_Exam_Name_Length
        and then Is_Class (C.Unbounded_Slice (1, Class_Length))
        and then S (Class_Length + 1) = '_'
        and then Is_Module
                   (C.Unbounded_Slice
                      (Class_Length + 2, Class_Length + Module_Length + 1))
        and then S (Class_Length + Module_Length + 2) = '_'
        and then Is_RA
                   (C.Unbounded_Slice
                      (Class_Length + Module_Length + 3,
                       Class_Length + Module_Length + RA_Length + 2))
        and then S (Class_Length + Module_Length + RA_Length + 3) = '_'
        and then Is_Date
                   (C.Unbounded_Slice
                      (Class_Length + Module_Length + RA_Length + 4, S'Last));
   end Is_Class_Exam_Name;

   ----------------
   -- Is_Exam_ID --
   ----------------

   function Is_Exam_ID (I : UString) return Boolean is
      S : constant String := To_String (I);
   begin
      --  cccl mmm rrr dddddd/nnn
      --  SMX1_DIG_RA2_202511/011
      return
        S'Length = Exam_ID_Length
        and then Is_Exam_Name (I.Unbounded_Slice (1, Exams_Name_Length))
        and then S (Exams_Name_Length + 1) = '/'
        and then Is_All_Digits (S (Exams_Name_Length + 2 .. S'Last));
   end Is_Exam_ID;

   --------------------
   -- Get_Exams_Name --
   --------------------

   function Get_Exams_Name (C : Class_Exam_Name_Type) return Exams_Name_Type is
      Pool : constant String :=
        C (1 .. Cycle_Length + Level_Length)
        & C (Cycle_Length + Level_Length + 2 .. C'Length);
   begin
      return Exams_Name_Type'(Pool);
   end Get_Exams_Name;

end Hilbert.Types;
