with Ada.Directories;
with Ada.Strings;
with Ada.Strings.Wide_Unbounded;
with Ada.Text_IO;

with GNAT.OS_Lib;
with Simple_Logging;

with Hilbert.Bit_Stream_Item;
with Hilbert.Constants; use Hilbert.Constants;
with Hilbert.Convert;   use Hilbert.Convert;

package body Hilbert.Grade is

   package Log renames Simple_Logging;
   package TIO renames Ada.Text_IO;
   package WIO renames Hilbert.Strings.WIO;

   use all type Ada.Strings.Wide_Unbounded.Unbounded_Wide_String;
   use all type Hilbert.Strings.UString;
   use all type Hilbert.Bit_Stream_Item.Bit_Stream_Item_Type;

   Out_File : WIO.File_Type;

   ----------
   -- Open --
   ----------

   procedure Open (Grade_Name : Grades_Name_Type) is
      Filename : constant String := Grade_Name & Grades_Suffix;
   begin
      Out_File.Create (WIO.Out_File, Filename);
   end Open;

   -----------
   -- Close --
   -----------

   procedure Close is
   begin
      Out_File.Close;
   end Close;

   -----------
   -- Write --
   -----------

   procedure Write (Self : Grade_Type) is

      procedure Write_Bit_Stream
        (Bit_Stream : Hilbert.Bit_Stream.Bit_Stream_Type) is
      begin
         for I in 1 .. Bit_Stream.Num_Items loop
            Item : constant Hilbert.Bit_Stream_Item.Bit_Stream_Item_Type :=
              Bit_Stream.Element (I);
            Out_File.Put (To_BWString (Item.Bits));
            if I < Bit_Stream.Num_Items then
               Out_File.Put (",");
            end if;
         end loop;
      end Write_Bit_Stream;

   begin
      Out_File.Put
        (To_BWString ("ANSWERS")
         & ","
         & To_BWString (Self.Answer.Date_Time)
         & ","
         & To_BWString (Self.Answer.Email)
         & ","
         & To_BWString (Self.Answer.Name_Surname)
         & ","
         & To_BWString (Self.Answer.Exam_Id)
         & ",");
      Write_Bit_Stream (Self.Answer.Bit_Stream);
      Out_File.New_Line;

      Out_File.Put
        (To_BWString ("CORRECT")
         & ","
         & Integer'Wide_Image (Integer (Self.Exam.Num_Items))
         & ",");
      Write_Bit_Stream (Self.Exam.Bit_Stream);
      Out_File.New_Line;

      Out_File.Put (To_BWString ("MATCHES,"));
      Write_Bit_Stream (Self.Match);
      Out_File.New_Line;

      Out_File.Put
        (To_BWString ("SCORE")
         & ","
         & Integer'Wide_Image (Integer (Self.Score)));
      Out_File.New_Line;

   end Write;

   ------------------
   -- Grade_Answer --
   ------------------

   procedure Grade_Answer
     (Self   : in out Grade_Type;
      Answer : Hilbert.Answer.Answer_Type;
      Exam   : Hilbert.Batch.Batch_Item_Type)
   is
      Min_Items : constant Natural :=
        Natural'Min (Answer.Bit_Stream.Num_Items, Exam.Bit_Stream.Num_Items);
   begin
      Self.Answer := Answer;
      Self.Exam := Exam;
      Self.Match.Clear;
      Self.Score := 0;

      for I in 1 .. Min_Items loop
         Answer_Item : constant Hilbert.Bit_Stream_Item.Bit_Stream_Item_Type :=
           Answer.Bit_Stream.Element (I);
         Exam_Item : constant Hilbert.Bit_Stream_Item.Bit_Stream_Item_Type :=
           Exam.Bit_Stream.Element (I);
         Self.Match.Append
           (Hilbert.Bit_Stream_Item.Match (Answer_Item, Exam_Item));

         if Answer_Item.Bits.Length = Exam_Item.Bits.Length then
            if Answer_Item.Bits = Exam_Item.Bits then
               Self.Score := Self.Score + 1;
            end if;
         elsif Answer_Item.Bits.Length > Exam_Item.Bits.Length then
            --  Lengths differ, score depends on matching bits only
            Correct : Boolean := True;
            for J in 1 .. Exam_Item.Bits.Length loop
               if Answer_Item.Bits.Element (J) /= Exam_Item.Bits.Element (J)
               then
                  Correct := False;
               end if;
            end loop;
            Self.Score := Self.Score + (if Correct then 1 else 0);
         end if;
      end loop;

      if Answer.Bit_Stream.Num_Items < Exam.Bit_Stream.Num_Items then
         for I in Min_Items + 1 .. Exam.Bit_Stream.Num_Items loop
            Exam_Item :
              constant Hilbert.Bit_Stream_Item.Bit_Stream_Item_Type :=
                Exam.Bit_Stream.Element (I);

            Match_Item : Hilbert.Bit_Stream_Item.Bit_Stream_Item_Type;
            Match_Item.Bits := Exam_Item.Bits;
            for J in 1 .. Exam_Item.Bits.Length loop
               Match_Item.Bits.Replace_Element (J, '0');
            end loop;
            Match_Item.Is_Valid := True;
            Self.Match.Append (Match_Item);
            --  No score for unanswered items
         end loop;
      end if;
   end Grade_Answer;

   ----------------------
   -- Grade_Class_Exam --
   ----------------------

   procedure Grade_Class_Exam (Class_Exam : String) is
      Answer : Hilbert.Answer.Answer_Type;
      Batch  : Hilbert.Batch.Batch_Type;
      Grade  : Grade_Type;
      EOF    : Boolean;
   begin
      Class_Exam_Name : constant Class_Exam_Name_Type :=
        Class_Exam_Name_Type'(Class_Exam);

      Answers_Filename : constant String := Class_Exam & Answers_Suffix;
      if Ada.Directories.Exists (Answers_Filename) = False then
         Log.Error ("Answers file '" & Answers_Filename & "' does not exist.");
         GNAT.OS_Lib.OS_Exit (Status => 1);
      end if;

      Batch_Filename : constant String :=
        String'(Get_Exams_Name (Class_Exam_Name)) & Batch_Suffix;
      if Ada.Directories.Exists (Batch_Filename) = False then
         Log.Error ("Batch file '" & Batch_Filename & "' does not exist.");
         GNAT.OS_Lib.OS_Exit (Status => 1);
      end if;

      Batch.Read (Get_Exams_Name (Class_Exam_Name));
      Hilbert.Answer.Open (Class_Exam_Name);
      Hilbert.Grade.Open (Class_Exam_Name);

      loop
         Answer.Read (EOF);
         exit when EOF;

         WIO.Put
           (To_BWString (Answer.Name_Surname)
            & "  ("
            & To_BWString (Answer.Email)
            & ")");
         TIO.Put
           (ASCII.CR
            & ASCII.HT
            & ASCII.HT
            & ASCII.HT
            & ASCII.HT
            & ASCII.HT
            & ASCII.HT
            & ASCII.HT);

         if Batch.Map.Contains (Exam_ID_Type'(Answer.Exam_Id)) = False then
            Log.Error ("No exam found for Answer Exam ID: " & Answer.Exam_Id);
         else
            Batch_Item : constant Hilbert.Batch.Batch_Item_Type :=
              Batch.Map (Exam_ID_Type'(Answer.Exam_Id));
            Grade.Grade_Answer (Answer, Batch_Item);
            Grade.Write;

            Score_F : constant Float :=
              Float (Grade.Score) / Float (Batch_Item.Num_Items) * 10.0;
            Score_N : constant Natural :=
              Natural (Float'Truncation (Float'Rounding (Score_F)));
            TIO.Put_Line
              (Answer.Exam_Id
               & "  "
               & To_String (Format (Grade.Score, 2))
               & " "
               & Score_N'Image
               & " "
               & Score_F'Image);
         end if;
      end loop;

      Hilbert.Grade.Close;
      Hilbert.Answer.Close;

   end Grade_Class_Exam;

end Hilbert.Grade;
