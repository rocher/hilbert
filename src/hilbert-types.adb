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

   function Is_Cycle (S : String) return Boolean is
   begin
      --  ccc
      --  SMX
      return S'Length = Cycle_Length and then Is_All_Upper (S);
   end Is_Cycle;

   ---------------
   -- Has_Cycle --
   ---------------

   function Has_Cycle (S : String) return Boolean is
      β : constant Integer := S'First + Cycle_Length - 1;
   begin
      --  ccc
      --  SMX
      return S'Length >= Cycle_Length and then Is_Cycle (S (S'First .. β));
   end Has_Cycle;

   --------------
   -- Is_Level --
   --------------

   function Is_Level (S : String) return Boolean is
   begin
      --  l
      --  1
      return S'Length = Level_Length and then Is_All_Digits (S);
   end Is_Level;

   ---------------
   -- Is_Course --
   ---------------

   function Is_Course (S : String) return Boolean is
      β : constant Integer := S'First + Cycle_Length - 1;
   begin
      --  cccl
      --  SMX1
      return
        S'Length = Course_Length
        and then Is_Cycle (S (S'First .. β))
        and then Is_Level (S (β + 1 .. S'Last));
   end Is_Course;

   ----------------
   -- Has_Course --
   ----------------

   function Has_Course (S : String) return Boolean is
      β : constant Integer := S'First + Course_Length - 1;
   begin
      --  cccl
      --  SMX1
      return S'Length >= Course_Length and then Is_Course (S (S'First .. β));
   end Has_Course;

   --------------
   -- Is_Group --
   --------------

   function Is_Group (S : String) return Boolean is
   begin
      --  g
      --  A
      return S'Length = Group_Length and then Is_All_Upper (S);
   end Is_Group;

   --------------
   -- Is_Class --
   --------------

   function Is_Class (S : String) return Boolean is
      β : constant Integer := S'First + Cycle_Length - 1;
   begin
      --  ccclg
      --  SMX1A
      return
        S'Length = Class_Length
        and then Is_Cycle (S (S'First .. β))
        and then Is_Level (S (β + 1 .. β + Level_Length))
        and then Is_Group (S (β + Level_Length + 1 .. S'Last));
   end Is_Class;

   ---------------
   -- Has_Class --
   ---------------

   function Has_Class (S : String) return Boolean is
      β : constant Integer := S'First + Class_Length - 1;
   begin
      --  ccclg
      --  SMX1A
      return S'Length >= Class_Length and then Is_Class (S (S'First .. β));
   end Has_Class;

   ---------------
   -- Is_Module --
   ---------------

   function Is_Module (S : String) return Boolean is
   begin
      --  mmm
      --  DIG
      return S'Length = Module_Length and then Is_All_Upper (S);
   end Is_Module;

   -----------
   -- Is_RA --
   -----------

   function Is_RA (S : String) return Boolean is
   begin
      --  rrr
      --  RA2
      return
        S'Length = RA_Length
        and then S (S'First .. S'Last - 1) = "RA"
        and then Is_Digit (S (S'Last));
   end Is_RA;

   -------------
   -- Is_Date --
   -------------

   function Is_Date (S : String) return Boolean is
   begin
      --  yyyymm
      --  202511
      return
        S'Length = Date_Length
        and then Is_All_Digits (S)
        and then Integer'Value (S (S'First .. S'First + 3)) >= 2000
        and then Integer'Value (S (S'First + 4 .. S'First + 5)) >= 1
        and then Integer'Value (S (S'First + 4 .. S'First + 5)) <= 12;
   end Is_Date;

   ------------------
   -- Is_Pool_Name --
   ------------------

   function Is_Pool_Name (S : String) return Boolean is
      β : constant Integer := S'First + Cycle_Length - 1;
   begin
      --  cccl mmm rrr
      --  SMX1_MUN_RA8
      return
        S'Length = Pool_Name_Length
        and then Is_Cycle (S (S'First .. β))
        and then Is_Level (S (β + 1 .. β + Level_Length))
        and then S (β + Level_Length + 1) = '_'
        and then Is_Module
                   (S
                      (β
                       + Level_Length
                       + 2
                       .. β + Level_Length + Module_Length + 1))
        and then S (β + Level_Length + Module_Length + 2) = '_'
        and then Is_RA (S (β + Level_Length + Module_Length + 3 .. S'Last));
   end Is_Pool_Name;

   -------------------
   -- Has_Pool_Name --
   -------------------

   function Has_Pool_Name (S : String) return Boolean is
      β : constant Integer := S'First + Pool_Name_Length - 1;
   begin
      --  cccl mmm rrr
      --  SMX1_MUN_RA8
      return
        S'Length >= Pool_Name_Length and then Is_Pool_Name (S (S'First .. β));
   end Has_Pool_Name;

   ----------------------
   -- Is_Pool_Filename --
   ----------------------

   function Is_Pool_Filename (S : String) return Boolean is
      β : constant Integer := S'First + Pool_Name_Length - 1;
   begin
      --  cccl mmm rrr _Pool.txt
      --  SMX1_MUN_RA8_Pool.txt
      return
        S'Length = Pool_Filename_Length
        and then Is_Pool_Name (S (S'First .. β))
        and then S (β + 1) = '_'
        and then S (β + 2 .. β + S'Last) = Pool_Suffix;
   end Is_Pool_Filename;

   ------------------
   -- Is_Exam_Name --
   ------------------

   function Is_Exam_Name (S : String) return Boolean is
      β : constant Integer := S'First + Pool_Name_Length - 1;
   begin
      --  cccl mmm rrr dddddd
      --  SMX1_MUN_RA8_202511
      return
        S'Length = Exam_Name_Length
        and then Is_Pool_Name (S (S'First .. β))
        and then S (β + 1) = '_'
        and then Is_Date (S (β + 2 .. S'Last));
   end Is_Exam_Name;

   -------------------
   -- Has_Exam_Name --
   -------------------

   function Has_Exam_Name (S : String) return Boolean is
      β : constant Integer := S'First + Exam_Name_Length - 1;
   begin
      --  cccl mmm rrr dddddd
      --  SMX1_MUN_RA8_202511
      return
        S'Length >= Exam_Name_Length and then Is_Exam_Name (S (S'First .. β));
   end Has_Exam_Name;

   -----------------------
   -- Is_Exams_Filename --
   -----------------------

   function Is_Exams_Filename (S : String) return Boolean is
      β : constant Integer := S'First + Exam_Name_Length - 1;
   begin
      --  cccl mmm rrr dddddd
      --  SMX1_MUN_RA8_202511_Exams.txt
      return
        S'Length = Exams_Filename_Length
        and then Is_Exam_Name (S (S'First .. β))
        and then S (β + 1) = '_'
        and then S (β + 2 .. S'Last) = Exams_Suffix;
   end Is_Exams_Filename;

   -----------------------
   -- Is_Batch_Filename --
   -----------------------

   function Is_Batch_Filename (S : String) return Boolean is
      β : constant Integer := S'First + Exam_Name_Length - 1;
   begin
      --  cccl mmm rrr dddddd
      --  SMX1_MUN_RA8_202511_Batch.txt
      return
        S'Length = Batch_Filename_Length
        and then Is_Exam_Name (S (S'First .. β))
        and then S (β + 1) = '_'
        and then S (β + 2 .. S'Last) = Batch_Suffix;
   end Is_Batch_Filename;

   ----------------
   -- Is_Exam_ID --
   ----------------

   function Is_Exam_ID (S : String) return Boolean is
      β : constant Integer := S'First + Exam_Name_Length - 1;
   begin
      --  cccl mmm rrr dddddd/nnn
      --  SMX1_DIG_RA2_202511/011
      return
        S'Length = Exam_ID_Length
        and then Is_Exam_Name (S (S'First .. β))
        and then S (β + 1) = '/'
        and then Is_All_Digits (S (β + 2 .. S'Last));
   end Is_Exam_ID;

   ------------------------
   -- Is_Class_Exam_Name --
   ------------------------

   function Is_Class_Exam_Name (S : String) return Boolean is
      β : constant Integer := S'First + Class_Length - 1;
   begin
      --  ccccc mmm rrr dddddd
      --  SMX1C_DIG_RA2_202511
      return
        S'Length = Class_Exam_Name_Length
        and then Is_Class (S (S'First .. β))
        and then S (β + 1) = '_'
        and then Is_Module (S (β + 2 .. β + Module_Length + 1))
        and then S (β + Module_Length + 2) = '_'
        and then Is_RA
                   (S
                      (β
                       + Module_Length
                       + 3
                       .. β + Module_Length + RA_Length + 2))
        and then S (β + Module_Length + RA_Length + 3) = '_'
        and then Is_Date (S (β + Module_Length + RA_Length + 4 .. S'Last));
   end Is_Class_Exam_Name;

   -------------------------
   -- Has_Class_Exam_Name --
   -------------------------

   function Has_Class_Exam_Name (S : String) return Boolean is
      β : constant Integer := S'First + Class_Exam_Name_Length - 1;
   begin
      --  ccccc mmm rrr dddddd
      --  SMX1C_DIG_RA2_202511
      return
        S'Length >= Class_Exam_Name_Length
        and then Is_Class_Exam_Name (S (S'First .. β));
   end Has_Class_Exam_Name;

   -------------------------
   -- Is_Answers_Filename --
   -------------------------

   function Is_Answers_Filename (S : String) return Boolean is
      β : constant Integer := S'First + Class_Exam_Name_Length - 1;
   begin
      --  ccclg mmm rrr dddddd
      --  SMX1C_DIG_RA2_202511_Answers.csv
      return
        S'Length = Answers_Filename_Length
        and then Is_Class_Exam_Name (S (S'First .. β))
        and then S (β + 1) = '_'
        and then S (β + 2 .. S'Last) = Answers_Suffix;
   end Is_Answers_Filename;

   ------------------------
   -- Is_Grades_Filename --
   ------------------------

   function Is_Grades_Filename (S : String) return Boolean is
      β : constant Integer := S'First + Class_Exam_Name_Length - 1;
   begin
      --  ccccc mmm rrr dddddd
      --  SMX1C_DIG_RA2_202511_Grades.csv
      return
        S'Length = Grades_Filename_Length
        and then Is_Class_Exam_Name (S (S'First .. β))
        and then S (β + 1) = '_'
        and then S (β + 2 .. S'Last) = Grades_Suffix;
   end Is_Grades_Filename;

   ---------------
   -- Get_Cycle --
   ---------------

   function Get_Cycle (S : String) return Cycle_Type is
      β : constant Integer := S'First + Cycle_Length - 1;
   begin
      --  ccc
      --  SMX.*
      return Cycle_Type'(S (S'First .. β));
   end Get_Cycle;

   ---------------
   -- Get_Level --
   ---------------

   function Get_Level (S : String) return Level_Type is
      β : constant Integer := S'First + Cycle_Length;
   begin
      --  cccl
      --  SMX1.*
      --  Level_Length = 1, so
      Level : constant Level_Type := S (β .. β + Level_Length - 1);
      return Level;
   end Get_Level;

   ----------------
   -- Get_Course --
   ----------------

   function Get_Course (S : String) return Course_Type is
      β : constant Integer := S'First + Course_Length - 1;
   begin
      --  cccl
      --  SMX1.*
      Course : constant Course_Type := S (S'First .. β);
      return Course;
   end Get_Course;

   ---------------
   -- Get_Group --
   ---------------

   function Get_Group (S : String) return Group_Type is
      β : constant Integer := S'First + Course_Length;
   begin
      --  CCCCg
      --  SMX1A.*
      Group : constant Group_Type := S (β .. β + Group_Length - 1);
      return Group;
   end Get_Group;

   ---------------
   -- Get_Class --
   ---------------

   function Get_Class (S : String) return Class_Type is
      β : constant Integer := S'First + Class_Length - 1;
   begin
      --  ccclg
      --  SMX1A.*
      Class : constant Class_Type := S (S'First .. β);
      return Class;
   end Get_Class;

   ----------------
   -- Get_Module --
   ----------------

   function Get_Module (S : String) return Module_Type is
      β : Integer := S'First + Course_Length + 1;
   begin
      --  Has_Pool_Name           Has_Class_Exam_Name
      --  cccl mmm                ccclg mmm
      --  SMX1_DIG.*              SMX1A_DIG.*
      if Has_Class_Exam_Name (S) then
         β := β + 1;
      end if;
      Module : constant Module_Type := S (β .. β + Module_Length - 1);
      return Module;
   end Get_Module;

   ------------
   -- Get_RA --
   ------------

   function Get_RA (S : String) return RA_Type is
      β : Integer := S'First + Course_Length + Module_Length + 2;
   begin
      --  Has_Pool_Name           Hass_Class_Exam_Name
      --  cccl mmm rrr            ccclg mmm rrr
      --  SMX1_DIG_RA2            SMX1A_DIG_RA2
      if Has_Class_Exam_Name (S) then
         β := β + 1;
      end if;
      RA : constant RA_Type := S (β .. β + RA_Length - 1);
      return RA;
   end Get_RA;

   --------------
   -- Get_Date --
   --------------

   function Get_Date (S : String) return Date_Type is
      β : Integer := S'First + Course_Length + Module_Length + RA_Length + 3;
   begin
      --  Has_Exam_Name           Hass_Class_Exam_Name
      --  cccl mmm rrr dddddd     ccclg mmm rrr dddddd
      --  SMX1_DIG_RA2_202511     SMX1A_DIG_RA2_202511
      if Has_Class_Exam_Name (S) then
         β := β + 1;
      end if;
      Date : constant Date_Type := S (β .. β + Date_Length - 1);
      return Date;
   end Get_Date;

   -------------------
   -- Get_Pool_Name --
   -------------------

   function Get_Pool_Name (S : String) return Pool_Name_Type is
      β : constant Integer := S'First;
   begin
      --  Has_Pool_Name           Has_Class_Exam_Name
      --  cccl mmm rrr            ccclg mmm rrr dddddd
      --  SMX1_DIG_RA2            SMX1A_DIG_RA2_202511
      Pool_Name : Pool_Name_Type;
      if Has_Pool_Name (S) then
         Pool_Name := S (β .. β + Pool_Name_Length - 1);
      else
         --  Has_Class_Exam_Name
         Pool_Name :=
           S (β .. β + Course_Length - 1)
           & S
               (β
                + Class_Length
                .. β + Class_Length + Module_Length + 1 + RA_Length);
      end if;
      return Pool_Name;
   end Get_Pool_Name;

   -------------------
   -- Get_Exam_Name --
   -------------------

   function Get_Exam_Name (S : String) return Exam_Name_Type is
      β : constant Integer := S'First;
   begin
      --  Has_Exam_Name           Hass_Class_Exam_Name
      --  cccl mmm rrr dddddd     ccclg mmm rrr dddddd
      --  SMX1_DIG_RA2_202511     SMX1A_DIG_RA2_202511
      Exam_Name : Exam_Name_Type;
      if Has_Exam_Name (S) then
         Exam_Name := S (β .. β + Exam_Name_Length - 1);
      else
         Exam_Name :=
           S (β .. β + Course_Length - 1)
           & S
               (β
                + Class_Length
                .. β
                   + Class_Length
                   + Module_Length
                   + 1
                   + RA_Length
                   + 1
                   + Date_Length);
      end if;
      return Exam_Name;
   end Get_Exam_Name;

   -------------------------
   -- Get_Class_Exam_Name --
   -------------------------

   function Get_Class_Exam_Name (S : String) return Class_Exam_Name_Type is
      β : constant Integer := S'First;
   begin
      --  Has_Class_Exam_Name
      --  ccclg mmm rrr dddddd
      --  SMX1A_DIG_RA2_202511
      Class_Exam_Name : constant Class_Exam_Name_Type :=
        S (β .. β + Class_Exam_Name_Length - 1);
      return Class_Exam_Name;
   end Get_Class_Exam_Name;

   procedure Test_Hilbert_Types is separate;

end Hilbert.Types;
