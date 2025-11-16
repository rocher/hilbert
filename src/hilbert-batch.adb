with Ada.Text_IO;
with GNAT.OS_Lib;

with Simple_Logging; use Simple_Logging;

with Hilbert.Constants; use Hilbert.Constants;

package body Hilbert.Batch is

   package Log renames Simple_Logging;

   ----------
   -- Read --
   ----------

   --           111111111122222222223333333333444444444
   --  123456789012345678901234567890123456789012345678
   --  EXAM SMX1_DIG_RA2_202511/011 38 166/085/189 0001

   procedure Read (Self : out Object; Exams_Name : Exams_Name_Type) is
      Filename : constant String := Exams_Name & Batch_Suffix;
      In_File  : Ada.Text_IO.File_Type;
   begin
      Self.Exams_Name := Exams_Name;
      Self.Batch.Clear;

      Ada.Text_IO.Open (In_File, Ada.Text_IO.In_File, Filename);
      while not In_File.End_Of_File loop
         Line : constant String := In_File.Get_Line;
         if Line (1 .. 4) = "EXAM" then
            Exam_Id_Str : constant String (1 .. Exam_ID_Length) :=
              Line (6 .. 6 + Exam_ID_Length - 1);
            if not Is_Exam_ID (To_UString (Exam_Id_Str)) then
               Log.Error
                 ("Invalid Exam ID '" & Exam_Id_Str & "' in batch file.");
               GNAT.OS_Lib.OS_Exit (Status => 1);
            end if;
            Exam_Id : constant Exam_ID_Type := Exam_ID_Type'(Exam_Id_Str);
            Bit_Stream : Hilbert.Bit_Stream.Object;
            Bit_Stream.Load_From_UString (To_UString (Line (45 .. Line'Last)));
            Self.Batch.Insert
              (Key      => Exam_Id,
               New_Item =>
                 (Num_Items  => Positive'Value (Line (30 .. 31)),
                  Bit_Stream => Bit_Stream));
         end if;
      end loop;
      Ada.Text_IO.Close (In_File);
   end Read;

   ---------------------
   -- Put_Image_Batch --
   ---------------------

   procedure Put_Image_Batch
     (Output : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
      Self   : Object) is
   begin
      Output.Put (Self.Exams_Name);
      Output.New_Line;
      for Cursor in Self.Batch.Iterate loop
         Output.Put
           (Cursor.Key
            & Cursor.Element.Num_Items'Image
            & " "
            & Cursor.Element.Bit_Stream'Image);
         Output.New_Line;
      end loop;
   end Put_Image_Batch;

end Hilbert.Batch;
