with Hilbert.Convert; use Hilbert.Convert;
with Hilbert.Exam;    use Hilbert.Exam;
with Hilbert.Strings; use Hilbert.Strings;

package body Hilbert.Pool is

   use all type UString;

   --------------------
   -- Read_From_File --
   --------------------

   procedure Read_From_File (Self : out Object; Filename : String) is
      In_File  : WIO.File_Type;
      New_Item : Item.Object;
   begin
      Self.Clear;

      In_File.Open (Name => Filename, Mode => WIO.In_File);
      loop
         exit when In_File.End_Of_File;
         New_Item.Read (In_File);
         Self.Append (New_Item);
      end loop;
      In_File.Close;
   end Read_From_File;

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
      if Num_Items > Positive (Self.Length) then
         raise Constraint_Error with "Not enough items in pool";
      end if;

      Exams_File.Create (Name => Name & "_Exams.txt", Mode => WIO.Out_File);
      Batch_File.Create (Name => Name & "_Batch.txt", Mode => WIO.Out_File);

      for I in 1 .. Num_Exams loop
         declare
            New_Exam : Hilbert.Exam.Object :=
              Create_Exam (Pool => Self, Num_Items => Num_Items);
         begin
            New_Exam.Set_Id (To_UString (Name) & "/" & Format (I, 3, '0'));
            New_Exam.Write (Exams_File);
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
      for Item of Self loop
         Output.Put (Item'Image);
         if Item /= Self.Last_Element then
            Output.New_Line;
            Output.New_Line;
         end if;
      end loop;
   end Put_Image_Pool;

end Hilbert.Pool;
