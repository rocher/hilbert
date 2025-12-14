with Ada.Directories;

with GNAT.OS_Lib;
with Simple_Logging;

with Hilbert.Constants; use Hilbert.Constants;
with Hilbert.Convert;   use Hilbert.Convert;
with Hilbert.Exam;      use Hilbert.Exam;

package body Hilbert.Pool is

   package Log renames Simple_Logging;

   use all type UWString;

   ----------
   -- Read --
   ----------

   procedure Read (Self : out Pool_Type; Pool_Name : String) is
      In_File  : WIO.File_Type;
      New_Item : Item.Item_Type;
      Filename : constant String := Pool_Name & Pool_Suffix;
   begin
      if Ada.Directories.Exists (Filename) = False then
         Log.Error ("Pool file '" & Filename & "' does not exist.");
         GNAT.OS_Lib.OS_Exit (Status => 1);
      end if;

      Self.Name := To_UString (Pool_Name);
      Self.Items.Clear;

      In_File.Open (Name => Filename, Mode => WIO.In_File);

      --  Read Title Line
      declare
         Line : constant BWString := In_File.Get_Line;
      begin
         Self.Title := To_UWString (Line);
         In_File.Skip_Line; -- Skip blank line after title
      end;

      Line_Number : Natural := 2;
      loop
         exit when In_File.End_Of_File;
         New_Item.Read_From (In_File, Line_Number);
         Self.Items.Append (New_Item);
      end loop;
      In_File.Close;
   end Read;

   ----------------
   -- Make_Exams --
   ----------------

   procedure Make_Exams
     (Self      : Pool.Pool_Type;
      Date      : String;
      Num_Exams : Positive;
      Num_Items : Positive)
   is
      Exams_File : WIO.File_Type;
      Batch_File : WIO.File_Type;
   begin
      if Num_Items > Positive (Self.Items.Length) then
         raise Constraint_Error with "Not enough items in pool";
      end if;

      Exams_File.Create
        (Name => To_String (Self.Name) & "_" & Date & "_Exams.txt",
         Mode => WIO.Out_File);

      Batch_File.Create
        (Name => To_String (Self.Name) & "_" & Date & "_Batch.txt",
         Mode => WIO.Out_File);

      Exams_File.Put_Line (To_BWString (Self.Title));
      Batch_File.Put_Line (To_BWString (Self.Title));

      for I in 1 .. Num_Exams loop
         declare
            New_Exam : Hilbert.Exam.Exam_Type :=
              Create_Exam (Pool => Self, Num_Items => Num_Items);
         begin
            New_Exam.Set_Id
              (To_UWString (To_String (Self.Name))
               & "_"
               & To_UWString (Date)
               & "/"
               & Format (I, 3, '0'));
            New_Exam.Write_To (Exams_File);
            Batch_File.Put_Line (New_Exam'Wide_Image);
         end;
      end loop;

      Exams_File.Close;
      Batch_File.Close;
   end Make_Exams;

   --------------------
   -- Put_Image_Pool --
   --------------------

   procedure Put_Image_Pool
     (Output : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
      Self   : Pool_Type) is
   begin
      Output.Wide_Put (To_BWString (Self.Title));
      Output.New_Line;
      Output.New_Line;
      for Item of Self.Items loop
         Output.Put (Item'Image);
         if Item /= Self.Items.Last_Element then
            Output.New_Line;
            Output.New_Line;
         end if;
      end loop;
   end Put_Image_Pool;

end Hilbert.Pool;
