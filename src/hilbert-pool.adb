with Hilbert.Constants; use Hilbert.Constants;
with Hilbert.Convert;   use Hilbert.Convert;
with Hilbert.Exam;      use Hilbert.Exam;

package body Hilbert.Pool is

   use all type UString;

   ----------
   -- Read --
   ----------

   procedure Read (Self : out Object; Pool_Name : String) is
      In_File  : WIO.File_Type;
      New_Item : Item.Object;
      Filename : constant String := Pool_Name & Pool_Suffix;
   begin
      Self.Name := To_Unbounded_String (Pool_Name);
      Self.Items.Clear;

      In_File.Open (Name => Filename, Mode => WIO.In_File);

      --  Read Title Line
      declare
         Line  : constant BString := In_File.Get_Line;
      begin
         Self.Title := To_UString (Line);
         In_File.Skip_Line; -- Skip blank line after title
      end;

      loop
         exit when In_File.End_Of_File;
         New_Item.Read_From (In_File);
         Self.Items.Append (New_Item);
      end loop;
      In_File.Close;
   end Read;

   ----------------
   -- Make_Exams --
   ----------------

   procedure Make_Exams
     (Self      : Pool.Object;
      Name      : String;
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
        (Name => To_String (Self.Name) & "_" & Name & "_Exams.txt",
         Mode => WIO.Out_File);
      Batch_File.Create
        (Name => To_String (Self.Name) & "_" & Name & "_Batch.txt",
         Mode => WIO.Out_File);

      for I in 1 .. Num_Exams loop
         declare
            New_Exam : Hilbert.Exam.Object :=
              Create_Exam (Pool => Self, Num_Items => Num_Items);
         begin
            New_Exam.Set_Id
              (To_UString (To_String (Self.Name))
               & "_"
               & To_UString (Name)
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
      Self   : Object) is
   begin
      Output.Wide_Put (To_BString (Self.Title));
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
