with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

--  with Hilbert.CLI;
with Hilbert.Answer;
with Hilbert.Types;   use Hilbert.Types;
with Hilbert.Strings; use Hilbert.Strings;

-----------------
-- Hilbert_CMD --
-----------------

procedure Hilbert_CMD is

   package HStr renames Hilbert.Strings;

   use all type Hilbert.Strings.UString;

   Answer : Hilbert.Answer.Answer_Type;
   EOF    : Boolean := False;
   Cursor : Natural := 1;
   Num    : Natural;

begin

   Hilbert.Answer.Open (Answers_Name_Type'("SMX1B_DIG_RA2_202511"));

   loop
      Answer.Read (EOF);
      exit when EOF;

      Put_Line
        (To_String (Answer.Name_Surname) & " - " & Answer.Exam_Id);
      Put_Line ("   " & Answer'Image);
      --  Num := 1;
      --  Cursor := 1;
      --  loop
      --     --  BS := Get_Next_Answer (Answer.Bit_Stream, Cursor);
      --     --  exit when BS = Null_UString;
      --     Put (Num, Width => 3);
      --     Put (if Is_Bit_String (BS) then "    " else " ERR");
      --     Put (BS.Length, Width => 2);
      --     Put (" |" & HStr.To_String (UString'(BS)) & "|");
      --     New_Line;
      --     Num := Num + 1;
      --  end loop;
   end loop;

   Hilbert.Answer.Close;

--  Hilbert.CLI.Initialize;
--  Hilbert.CLI.Execute;

end Hilbert_CMD;
