with Ada.Strings.Unbounded;

with Simple_Logging;

with Hilbert.CSV_Strings;
with Hilbert.Strings; use Hilbert.Strings;
with Hilbert.Types; use Hilbert.Types;

package body Hilbert.Unit_Test is

   package Log renames Simple_Logging;
   package HStr renames Hilbert.Strings;

   use all type HStr.UString;

   --------------------
   -- All_Unit_Tests --
   --------------------

   procedure All_Unit_Tests is
   begin
      CSV_Strings_Unit_Test;
      Types_Unit_Test;
   end All_Unit_Tests;

   ---------------------------
   -- CSV_Strings_Unit_Test --
   ---------------------------

   procedure CSV_Strings_Unit_Test is

      use Ada.Strings.Unbounded;

      function Index_Of_Char
        (Source : UString; Char : Character; From : Natural) return Natural
      is (Ada.Strings.Unbounded.Index (Source, "" & Char, From));

      package CSV_UStrings is new
        Hilbert.CSV_Strings
          (Base_String      => UString,
           Null_Base_String => Null_UString,
           Length           => Ada.Strings.Unbounded.Length,
           Index_Of         => Index_Of_Char,
           Substring        => Ada.Strings.Unbounded.Unbounded_Slice,
           Append_Char      => Ada.Strings.Unbounded.Append,
           Append_String    => Ada.Strings.Unbounded.Append);
      use CSV_UStrings;

      Test_CSV : CSV_String := Null_CSV_String;

      procedure Report_CSV_Test is
      begin
         Log.Info
           ("CSV Test: '"
            & Hilbert.Strings.To_String (Test_CSV.Values)
            & "'"
            & ", Fields:"
            & Fields (Test_CSV)'Image);
         Found : Boolean := True;
         Pos : Natural := 1;
         CSV_Field : UString;
         while Found loop
            CSV_Field := Get_Next_Field (Test_CSV, Pos, Found);
            if Found then
               Log.Info
                 ("Next filed: '"
                  & Hilbert.Strings.To_String (CSV_Field)
                  & "', Pos:"
                  & Pos'Image);
            else
               Log.Warning ("No more fields.");
            end if;
         end loop;
         Log.Info ("");
      end Report_CSV_Test;

   begin

      Test_CSV.Append_Field (Null_UString);
      Test_CSV.Append_Field (Null_UString);
      Test_CSV.Append_Field (To_UString (String'("""")));
      Test_CSV.Append_Field (To_UString (String'("X0")));
      Test_CSV.Append_Field (To_UString (String'("X1")));
      Test_CSV.Append_Field (Null_UString);
      Test_CSV.Append_Field (Null_UString);
      Test_CSV.Append_Field (To_UString (String'("")));
      Test_CSV.Append_Field (To_UString (String'("X2")));
      Test_CSV.Append_Field (To_UString (String'("X3")));
      Test_CSV.Append_Field (To_UString (String'(",")));
      Test_CSV.Append_Field (Null_UString);
      Test_CSV.Append_Field (Null_UString);
      Report_CSV_Test;

      Test_CSV := Null_CSV_String;
      Test_CSV.Append_Field (To_UString (String'("""Y1""")));
      Test_CSV.Append_Field (To_UString (String'("""Y2")));
      Test_CSV.Append_Field (To_UString (String'("Y3""")));
      Report_CSV_Test;

      Test_CSV := Null_CSV_String;
      Test_CSV.Append_Field (To_UString (String'(",x,,y,")));
      Test_CSV.Append_Field (To_UString (String'("Z1")));
      Test_CSV.Append_Field (To_UString (String'("Z2")));
      Test_CSV.Append_Field (To_UString (String'("Z3")));
      Report_CSV_Test;

      Load_Fields_From_String
        (Test_CSV, To_UString (String'("""X0,X1,,X3,,X5""")));
      Report_CSV_Test;

   end CSV_Strings_Unit_Test;

   ---------------------
   -- Types_Unit_Test --
   ---------------------

   procedure Types_Unit_Test is
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

   end Types_Unit_Test;

end Hilbert.Unit_Test;
