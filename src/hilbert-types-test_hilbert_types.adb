with Simple_Logging;

separate (Hilbert.Types)
procedure Test_Hilbert_Types is

   package Log renames Simple_Logging;

   S : constant String := "CYC1A_MOD_RA2_202602";

begin

   Log.Info ("S(1) = " & S (1 .. 1));

   Log.Info ("Testing Hilbert Types...");
   Log.Info ("Class_Exam_Name: " & S);

   Log.Info ("Has_Cycle: " & Boolean'Image (Has_Cycle (S)));
   Log.Info ("Cycle    : " & Cycle_Type'Image (Get_Cycle (S)));
   Log.Info ("Level    : " & Level_Type'Image (Get_Level (S)));
   Log.Info ("Course   : " & Course_Type'Image (Get_Course (S)));
   Log.Info ("Group    : " & Group_Type'Image (Get_Group (S)));
   Log.Info ("Class    : " & Class_Type'Image (Get_Class (S)));
   Log.Info ("Module   : " & Module_Type'Image (Get_Module (S)));
   Log.Info ("RA       : " & RA_Type'Image (Get_RA (S)));
   Log.Info ("Date     : " & Date_Type'Image (Get_Date (S)));
   Log.Info ("Pool_Name: " & Pool_Name_Type'Image (Get_Pool_Name (S)));
   Log.Info ("Exam_Name: " & Exam_Name_Type'Image (Get_Exam_Name (S)));

   if Has_Class_Exam_Name (S) then
      Log.Info
        ("Class_Exam_Name: "
         & Class_Exam_Name_Type'Image (Get_Class_Exam_Name (S)));
   else
      Log.Info ("No Class_Exam_Name found.");
   end if;

end Test_Hilbert_Types;
