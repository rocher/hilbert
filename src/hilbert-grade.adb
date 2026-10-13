with Ada.Directories;
with Ada.Strings;
with Ada.Strings.Wide_Unbounded;
with Ada.Text_IO;

with Simple_Logging;

with Hilbert.Bit_Stream_Item;
with Hilbert.Constants; use Hilbert.Constants;
with Hilbert.Convert;   use Hilbert.Convert;
with Hilbert.Version;   use Hilbert.Version;

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

   procedure Open (Grade_Name : Class_Exam_Name_Type) is
      Filename : constant String := Grade_Name & Grades_Suffix;
   begin
      Out_File.Create (WIO.Out_File, Filename);
      if Get_Version /= Null_Version then
         Out_File.Put_Line (To_BWString (Version_Prefix & Get_Version));
      end if;
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

   begin
      if Get_Version = Null_Version then
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
      elsif Get_Version = "25.12" then
         Out_File.Put
           (To_BWString ("ANSWERS")
            & ","
            & To_BWString (Self.Answer.Date_Time)
            & ","
            & To_BWString (Self.Answer.Email)
            & ","
            & To_BWString (Self.Answer.Name_Surname)
            & ","
            & To_BWString (Self.Answer.Name)
            & ","
            & To_BWString (Self.Answer.Exam_Id)
            & ",");
      end if;
      Self.Answer.Bit_Stream.Write_To (Out_File);
      Out_File.New_Line;

      Out_File.Put
        (To_BWString ("CORRECT")
         & ","
         & Integer'Wide_Image (Integer (Self.Exam.Num_Items))
         & ",");
      Self.Exam.Bit_Stream.Write_To (Out_File);
      Out_File.New_Line;

      Out_File.Put (To_BWString ("MATCHES," & Self.Match.Values));
      Out_File.New_Line;

      Out_File.Put
        (To_BWString ("SCORE")
         & ","
         & Hilbert.Convert.Trim (Self.Score)
         & "/"
         & Hilbert.Convert.Trim (Self.Exam.Num_Items)
         & ","
         & Trim (Float (Self.Score) / Float (Self.Exam.Num_Items) * 10.0)
         & ","
         & Hilbert.Convert.Trim
             (Integer
                (Float (Self.Score) / Float (Self.Exam.Num_Items) * 10.0)));
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

      function Item_Is_Invalid
        (Item : Hilbert.Bit_Stream_Item.Bit_Stream_Item_Type) return Boolean
      is (for all Bit of Hilbert.Strings.To_String (Item.Bits) => Bit = '0');
   begin
      Self.Answer := Answer;
      Self.Exam := Exam;
      Self.Match := Null_CSV_String;
      Self.Score := 0;
      Self.Total_Valid := Self.Exam.Num_Items;

      for I in 1 .. Min_Items loop
         Answer_Item : constant Hilbert.Bit_Stream_Item.Bit_Stream_Item_Type :=
           Answer.Bit_Stream.Element (I);
         Exam_Item : constant Hilbert.Bit_Stream_Item.Bit_Stream_Item_Type :=
           Exam.Bit_Stream.Element (I);

         if Answer_Item.Bits.Length = Exam_Item.Bits.Length then
            if Item_Is_Invalid (Answer_Item) then
               --  Invalid item, no score
               Self.Total_Valid := Self.Total_Valid - 1;
               Self.Match.Append_Field
                 (To_UString ("i" & Exam_Item.Bits.To_String));
            elsif Answer_Item.Bits = Exam_Item.Bits then
               Self.Score := Self.Score + 1;
               Self.Match.Append_Field
                 (To_UString ("G" & Answer_Item.Bits.To_String));
            else
               Self.Match.Append_Field
                 (To_UString ("R" & Answer_Item.Bits.To_String));
            end if;
         elsif Answer_Item.Bits.Length > Exam_Item.Bits.Length then
            --  Lengths differ, score depends on matching bits only
            Correct : Boolean := True;
            for J in 1 .. Exam_Item.Bits.Length loop
               if Answer_Item.Bits.Element (J) /= Exam_Item.Bits.Element (J)
               then
                  Correct := False;
                  exit;
               end if;
            end loop;
            Self.Match.Append_Field
              ((if Correct then "G" else "R")
               & Head (Answer_Item, Exam_Item)
               & "g"
               & Tail (Answer_Item, Exam_Item));
            Self.Score := Self.Score + (if Correct then 1 else 0);
         else
            --  Answer_Item.Bits.Length < Exam_Item.Bits.Length
            --  Less bits than correct answer, no score, wrong answer
            Self.Match.Append_Field
              ("R"
               & To_UString (Answer_Item.Bits.To_String)
               & "g"
               & Tail (Answer_Item, Exam_Item));
         end if;
      end loop;

      if Answer.Bit_Stream.Num_Items < Exam.Bit_Stream.Num_Items then
         for I in Min_Items + 1 .. Exam.Bit_Stream.Num_Items loop
            Exam_Item :
              constant Hilbert.Bit_Stream_Item.Bit_Stream_Item_Type :=
                Exam.Bit_Stream.Element (I);
            Self.Match.Append_Field ("g" & Exam_Item.Mask);
            --  No score for unanswered items
         end loop;
      elsif Answer.Bit_Stream.Num_Items > Exam.Bit_Stream.Num_Items then
         for I in Min_Items + 1 .. Answer.Bit_Stream.Num_Items loop
            Answer_Item :
              constant Hilbert.Bit_Stream_Item.Bit_Stream_Item_Type :=
                Answer.Bit_Stream.Element (I);
            Self.Match.Append_Field
              ("g" & To_UString (Answer_Item.Bits.To_String));
            --  No score for additional items
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
         raise Constraint_Error
           with "Answers file '" & Answers_Filename & "' does not exist.";
      end if;

      Batch_Filename : constant String :=
        String'(Get_Exam_Name (Class_Exam_Name)) & Batch_Suffix;
      if Ada.Directories.Exists (Batch_Filename) = False then
         raise Constraint_Error
           with "Batch file '" & Batch_Filename & "' does not exist.";
      end if;

      Batch.Read (Get_Exam_Name (Class_Exam_Name));
      Hilbert.Answer.Open (Class_Exam_Name);
      Hilbert.Grade.Open (Class_Exam_Name);

      loop
         Answer.Read (EOF);
         exit when EOF;

         if Get_Version = Null_Version then
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
         else
            WIO.Put
              (To_BWString (Answer.Name_Surname)
               & ", "
               & To_BWString (Answer.Name));
            TIO.Put
              (ASCII.CR
               & ASCII.HT
               & ASCII.HT
               & ASCII.HT
               & ASCII.HT
               & ASCII.HT);
         end if;

         if Batch.Map.Contains (Exam_ID_Type'(Answer.Exam_Id)) = False then
            Log.Error ("No exam found for Answer Exam ID: " & Answer.Exam_Id);
         else
            Batch_Item : constant Hilbert.Batch.Batch_Item_Type :=
              Batch.Map (Exam_ID_Type'(Answer.Exam_Id));
            Grade.Grade_Answer (Answer, Batch_Item);
            Grade.Write;

            Score_F : constant Float :=
              Float (Grade.Score) / Float (Grade.Total_Valid) * 10.0;
            Score_N : constant Natural :=
              Natural (Float'Truncation (Float'Rounding (Score_F)));
            TIO.Put
              (Answer.Exam_Id
               & "  "
               & To_String (Format (Grade.Score, 2))
               & " "
               & Score_N'Image
               & " "
               & Score_F'Image
               & "  ");
            WIO.Put (To_BWString (Answer.Email));
            TIO.New_Line;
         end if;
      end loop;

      Hilbert.Grade.Close;
      Hilbert.Answer.Close;

   end Grade_Class_Exam;

end Hilbert.Grade;
