with Hilbert.Bit_Stream_Item;
with Hilbert.Constants; use Hilbert.Constants;
with Hilbert.Strings;   use Hilbert.Strings;

package body Hilbert.Grade is

   package WIO renames Hilbert.Strings.WIO;

   use all type Hilbert.Strings.UString;
   use all type Hilbert.Bit_Stream_Item.Bit_Stream_Item_Type;

   Out_File : WIO.File_Type;

   --------------
   -- Evaluate --
   --------------

   procedure Evaluate
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
   end Evaluate;

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
            Out_File.Put (To_BWString (Hilbert.Strings.To_String (Item.Bits)));
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

end Hilbert.Grade;
