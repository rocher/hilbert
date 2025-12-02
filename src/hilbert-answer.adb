with Hilbert.Constants; use Hilbert.Constants;
with Hilbert.Version;   use Hilbert.Version;

package body Hilbert.Answer is

   package WIO renames Hilbert.Strings.WIO;

   In_File : WIO.File_Type;
   Version : Version_Type := Null_Version;

   ----------
   -- Open --
   ----------

   procedure Open (Name : Class_Exam_Name_Type) is
      Filename : constant String := Name & Answers_Suffix;
   begin
      In_File.Open (WIO.In_File, Filename);
      Line : constant String := To_String (In_File.Get_Line);
      if Has_Version (Line) then
         Version := Get_Version (Line);
      else
         In_File.Reset;
      end if;
   end Open;

   -----------
   -- Close --
   -----------

   procedure Close is
   begin
      In_File.Close;
   end Close;

   ------------
   -- Read_0 --
   ------------

   procedure Read_0 (Self : out Answer_Type; End_Of_File : out Boolean) is
   begin
      Self.Bit_Stream.Clear;
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
      end if;
   end Read_0;

   ----------
   -- Read --
   ----------

   procedure Read (Self : out Answer_Type; End_Of_File : out Boolean) is
   begin
      if Version = Null_Version then
         Read_0 (Self, End_Of_File);
      end if;
   end Read;

end Hilbert.Answer;
