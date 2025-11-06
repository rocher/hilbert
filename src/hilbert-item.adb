with Ada.Strings.UTF_Encoding; use Ada.Strings.UTF_Encoding;

with Ada.Strings.UTF_Encoding.Wide_Wide_Strings;
use Ada.Strings.UTF_Encoding.Wide_Wide_Strings;

package body Hilbert.Item is

   procedure Read (Self : out Object; File : in out Ada.Text_IO.File_Type) is
   begin
      Self :=
        (Difficulty     => Easy,
         Question       => Null_UString,
         Number_Options => 1,
         Options        =>
           [others => (Text => Null_UString, Is_Correct => False)]);

      declare
         --  Read Difficulty + Question
         Line_UTF8 : constant UTF_8_String := Ada.Text_IO.Get_Line (File);
         Line      : constant WWString := Decode (Line_UTF8);
      begin
         if Line (1) = '1' then
            Self.Difficulty := Easy;
         elsif Line (1) = '2' then
            Self.Difficulty := Medium;
         elsif Line (1) = '3' then
            Self.Difficulty := Hard;
         else
            raise Constraint_Error with "Invalid difficulty level";
         end if;

         --  Discard difficulty prefix
         Self.Question := To_UWWString (Line (3 .. Line'Length));
      end;

      --  Read Number of Options
      declare
         Line_UTF8 : constant UTF_8_String := Ada.Text_IO.Get_Line (File);
         Line      : constant WWString := Decode (Line_UTF8);

         Num_Options_Int : constant Integer :=
           Integer'Value (Line'Image (2 .. 2));
      begin
         if Num_Options_Int < 1 or else Num_Options_Int > Max_Options then
            raise Constraint_Error with "Number of options out of range";
         end if;
         Self.Number_Options := Number_Options_Type (Num_Options_Int);
      end;

      --  Read Options
      for I in 1 .. Self.Number_Options loop
         --  Read Option Text prefixed by 0 or 1 (indicating correctness)
         declare
            Line_UTF8 : constant UTF_8_String := Ada.Text_IO.Get_Line (File);
            Line      : constant WWString := Decode (Line_UTF8);
         begin
            Self.Options (I).Text := To_UWWString (Line (3 .. Line'Length));

            if Line (1) = '0' then
               Self.Options (I).Is_Correct := False;
            elsif Line (1) = '1' then
               Self.Options (I).Is_Correct := True;
            else
               raise Constraint_Error with "Invalid correctness flag";
            end if;
         end;
      end loop;

      --  Skip blank line between items
      if not Ada.Text_IO.End_Of_File (File) then
         File.Skip_Line;
      end if;
   end Read;

   procedure Put_Image_Item
     (Output : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
      Self   : Object)
   is
      Difficulty_Char : constant Character :=
        (if Self.Difficulty = Easy
         then '1'
         elsif Self.Difficulty = Medium
         then '2'
         else '3');
   begin
      Output.Put (Difficulty_Char & " ");
      Output.Wide_Wide_Put (To_WWString (Self.Question));
      Output.New_Line;
      Output.Put
        (Self.Number_Options'Image (2 .. Self.Number_Options'Image'Length));
      Output.New_Line;

      for I in 1 .. Self.Number_Options loop
         Output.Put ((if Self.Options (I).Is_Correct then '1' else '0') & " ");
         Output.Wide_Wide_Put (To_WWString (Self.Options (I).Text));
         if I < Self.Number_Options then
            Output.New_Line;
         end if;
      end loop;
   end Put_Image_Item;

end Hilbert.Item;
