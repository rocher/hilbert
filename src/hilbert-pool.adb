with Hilbert.Exam; use Hilbert.Exam;

package body Hilbert.Pool is

   ----------
   -- Read --
   ----------

   procedure Read (Self : out Object; File : in out Ada.Text_IO.File_Type) is
      New_Item : Item.Object;
   begin
      Self.Clear;
      loop
         exit when Ada.Text_IO.End_Of_File (File);
         New_Item.Read (File);
         Self.Append (New_Item);
      end loop;
   end Read;

   ----------------
   -- Make_Exams --
   ----------------

   procedure Make_Exams
     (Self      : Pool.Object;
      Num_Exams : Positive;
      Num_Items : Positive;
      Out_File  : Ada.Text_IO.File_Type) is
   begin
      if Num_Items > Positive (Self.Length) then
         raise Constraint_Error with "Not enough items in pool";
      end if;

      for Exam in 1 .. Num_Exams loop
         declare
            New_Exam : constant Hilbert.Exam.Object :=
              Create_Exam (Pool => Self, Num_Items => Num_Items);
         begin
            Out_File.Put_Line (New_Exam'Image);
         end;
      end loop;
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
