with Simple_Logging;

with Hilbert.Constants; use Hilbert.Constants;
with Hilbert.Exam;

package body Hilbert.Answer is

   package Log renames Simple_Logging;
   package WIO renames Hilbert.Strings.WIO;

   In_File : WIO.File_Type;

   ----------
   -- Open --
   ----------

   procedure Open (Answer_Name : Answers_Name_Type) is
      Filename : constant String := Answer_Name & Answers_Suffix;
   begin
      In_File.Open (WIO.In_File, Filename);
   end Open;

   -----------
   -- Close --
   -----------

   procedure Close is
   begin
      In_File.Close;
   end Close;

   ----------
   -- Read --
   ----------

   procedure Read (Self : out Object; End_Of_File : out Boolean) is
   begin
      Self.Bit_Stream.Bit_Stream.Clear;
      End_Of_File := In_File.End_Of_File;

      if not End_Of_File then
         Line : constant UWString := To_UWString (In_File.Get_Line);
         From : Positive := 1;
         Pos : Natural;

         --  Date_Time
         Pos := Line.Index (",", From);
         if Pos > 0 then
            Self.Date_Time := Line.Unbounded_Slice (From, Pos - 1);
            From := Pos + 1;
         end if;

         --  Email
         Pos := Line.Index (",", From);
         if Pos > 0 then
            Self.Email := Line.Unbounded_Slice (From, Pos - 1);
            From := Pos + 1;
         end if;

         --  Name_Surname
         Pos := Line.Index (",", From);
         if Pos > 0 then
            Self.Name_Surname := Line.Unbounded_Slice (From, Pos - 1);
            From := Pos + 1;
         end if;

         --  Exam_Id
         Pos := Line.Index (",", From);
         if Pos > 0 then
            Self.Exam_Id :=
              Exam_ID_Type'(To_String (Line.Unbounded_Slice (From, Pos - 1)));
            From := Pos + 1;
         end if;

         --  Bit_Stream
         Self.Bit_Stream.Load_From_UString
           (To_UString (Line.Unbounded_Slice (From, Line.Length)));
         Self.Bit_Stream.Count_Valid_Items;
      end if;
   end Read;

   ---------------
   -- Get_Score --
   ---------------

   function Get_Score
     (Self : Object; Batch : Hilbert.Batch.Object) return Float is
   begin
      if Batch.Map.Contains (Self.Exam_Id) then
         null;
      else
         Log.Error
           ("Exam ID '"
            & Self.Exam_Id
            & "' not found in batch for scoring "
            & "the answers of '"
            & To_String (Self.Name_Surname)
            & "'.");
         return 0.0;
      end if;

      Score : Float := 0.0;
      Batch_Item : constant Hilbert.Batch.Batch_Item_Type :=
        Batch.Map.Element (Self.Exam_Id);

   --  for I in 1 .. Batch_Item.Num_Items loop
   --     if Self.Bit_Stream.Is_Bit_Set (I) then
   --        Score := Score + 1.0;
   --     end if;
   --  end loop;

   end Get_Score;

end Hilbert.Answer;
