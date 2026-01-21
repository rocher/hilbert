with Ada.Wide_Characters.Handling;

with Hilbert.Convert; use Hilbert.Convert;
with Hilbert.Random;  use Hilbert.Random;

package body Hilbert.Item is

   ---------------
   -- Get_Flags --
   ---------------

   procedure Get_Flags
     (Self : in out Item_Type; Line : UWString; Line_Number : Natural)
   is
      Low  : Natural := Line.Index ("--");
      High : Natural;
   begin
      while Low > 0 loop
         High := Line.Index (" ", From => Low);
         --  High := Line.Index_Non_Blank (High);
         if High = 0 then
            High := Line.Length + 1;
         end if;

         declare
            Flag : constant Wide_String := Line.Slice (Low + 2, High - 1);
         begin
            if Flag = "figure" or else Flag = "vspace" then
               Low := Line.Index_Non_Blank (From => High);
               High := Line.Index (" ", From => Low);
               if High = 0 then
                  High := Line.Length + 1;
               end if;
               if Flag = "figure" then
                  Self.Flags.Figure := Line.Unbounded_Slice (Low, High - 1);
               else
                  Self.Flags.VSpace := Line.Unbounded_Slice (Low, High - 1);
               end if;
            elsif Flag = "in-all-exams" then
               Self.Flags.In_All_Exams := True;
            else
               raise Constraint_Error
                 with
                   "line"
                   & Line_Number'Image
                   & ": invalid item flag: "
                   & To_String (Flag);
            end if;
         end;

         Low := Line.Index ("--", High);
      end loop;
   end Get_Flags;

   ---------------
   -- Read_From --
   ---------------

   procedure Read_From
     (Self        : out Item_Type;
      In_File     : in out WIO.File_Type;
      Line_Number : in out Natural)
   is
      procedure Skip_Line is
      begin
         Line_Number := Line_Number + 1;
         In_File.Skip_Line;
      end Skip_Line;

      function Get_Line return BWString is
      begin
         Line_Number := Line_Number + 1;
         return In_File.Get_Line;
      end Get_Line;

   begin
      Self :=
        (Number      => 0,
         Difficulty  => Easy,
         Question    => Null_UWString,
         Num_Options => 1,
         Options     =>
           [others => (Text => Null_UWString, Is_Correct => False)],
         Flags       =>
           (Figure       => Null_UWString,
            VSpace       => Null_UWString,
            In_All_Exams => False));

      declare
         WChar : Wide_Character;
         EOL   : Boolean;
      begin
         --  Skip Comment Lines
         loop
            In_File.Look_Ahead (WChar, EOL);
            exit when Ada.Wide_Characters.Handling.Is_Digit (WChar);
            Skip_Line;
         end loop;

         Line : constant BWString := Get_Line;
         if Line (1) = '1' then
            Self.Difficulty := Easy;
         elsif Line (1) = '2' then
            Self.Difficulty := Medium;
         elsif Line (1) = '3' then
            Self.Difficulty := Hard;
         else
            raise Constraint_Error
              with
                "line"
                & Line_Number'Image
                & ": invalid difficulty level; "
                & To_String (Line);
         end if;

         --  Discard difficulty prefix
         Self.Question := To_UWString (Line (3 .. Line'Length));
      end;

      --  Read Number of Options
      declare
         Line            : constant BWString := Get_Line;
         Num_Options_Int : constant Integer :=
           Integer'Value (To_String (Line));
      begin
         if Num_Options_Int < 1 or else Num_Options_Int > Max_Options then
            raise Constraint_Error
              with
                "line"
                & Line_Number'Image
                & ": number of options out of range: "
                & To_String (Line);
         end if;
         Self.Num_Options := Num_Options_Type (Num_Options_Int);
      end;

      --  Read Options
      for I in 1 .. Self.Num_Options loop
         --  Read Option Text prefixed by 0 or 1 (indicating correctness)
         declare
            Line : constant BWString := Get_Line;
         begin
            Self.Options (I).Text := To_UWString (Line (3 .. Line'Length));

            if Line'Length > 0 then
               if Line (1) = '0' then
                  Self.Options (I).Is_Correct := False;
               elsif Line (1) = '1' then
                  Self.Options (I).Is_Correct := True;
               else
                  raise Constraint_Error
                    with
                      "line"
                      & Line_Number'Image
                      & ": invalid correctness flag; "
                      & To_String (Line);
               end if;
            else
               raise Constraint_Error
                 with
                   "line" & Line_Number'Image & "empty line, option expected";
            end if;
         end;
      end loop;

      if not In_File.End_Of_Line then
         declare
            Line : constant BWString := Get_Line;
         begin
            if Line = "" then
               --  Skip blank line between items
               null;
            else
               if Line (1 .. 2) = "--" then
                  --  Get item's flags
                  Get_Flags (Self, To_UWString (Line), Line_Number);
               else
                  --  Invalid line between items
                  raise Constraint_Error
                    with
                      "line"
                      & Line_Number'Image
                      & ": expected blank line between items; "
                      & To_String (Line);
               end if;
               --  Skip blank line between items
               if not In_File.End_Of_File then
                  Skip_Line;
               end if;
            end if;
         end;
      end if;
   end Read_From;

   --------------
   -- Write_To --
   --------------

   procedure Write_To (Self : Item_Type; Out_File : in out WIO.File_Type) is
      Has_Flags : Boolean := False;
   begin
      Out_File.Put (Trim (Self.Number) & " ");
      Out_File.Put_Line (To_BWString (Self.Question));
      Out_File.Put_Line (Trim (Self.Num_Options));
      for I in 1 .. Self.Num_Options loop
         Out_File.Put (To_BWString (Self.Options (I).Text));
         Out_File.New_Line;
      end loop;

      if Self.Flags.Figure /= Null_UWString then
         Out_File.Put ("--figure " & To_BWString (Self.Flags.Figure));
         Has_Flags := True;
      end if;
      if Self.Flags.VSpace /= Null_UWString then
         Out_File.Put
           ((if Has_Flags then " " else "")
            & "--vspace "
            & To_BWString (Self.Flags.VSpace));
         Has_Flags := True;
      end if;
      if Has_Flags then
         Out_File.New_Line;
      end if;
   end Write_To;

   ---------------------
   -- Shuffle_Options --
   ---------------------

   procedure Shuffle_Options (Self : in out Item_Type) is

      procedure Swap (A, B : in out Option_Type) is
         Temp : Option_Type := A;
      begin
         A := B;
         B := Temp;
      end Swap;

      Num_Swaps : constant Positive := Self.Num_Options * 10;

   begin
      for I in 1 .. Num_Swaps loop
         declare
            Index1 : constant Positive := Random_Index (Self.Num_Options);
            Index2 : constant Positive := Random_Index (Self.Num_Options);
         begin
            Swap (Self.Options (Index1), Self.Options (Index2));
         end;
      end loop;
   end Shuffle_Options;

   ----------------------
   -- Get_Answers_Bits --
   ----------------------

   function Get_Answers_Bits (Self : Item_Type) return UString is
   begin
      return Result : UString := Null_UString do
         for I in 1 .. Self.Num_Options loop
            if Self.Options (I).Is_Correct then
               Result.Append ('1');
            else
               Result.Append ('0');
            end if;

         end loop;
      end return;
   end Get_Answers_Bits;

   --------------------
   -- Put_Image_Item --
   --------------------

   procedure Put_Image_Item
     (Output : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
      Self   : Item_Type)
   is
      Difficulty_Char : constant Character :=
        (if Self.Difficulty = Easy
         then '1'
         elsif Self.Difficulty = Medium
         then '2'
         else '3');
   begin
      Output.Put (Difficulty_Char & " ");
      Output.Wide_Put (To_BWString (Self.Question));
      Output.New_Line;
      Output.Put (Self.Num_Options'Image (2 .. Self.Num_Options'Image'Length));
      Output.New_Line;

      for I in 1 .. Self.Num_Options loop
         Output.Put ((if Self.Options (I).Is_Correct then '1' else '0') & " ");
         Output.Wide_Put (To_BWString (Self.Options (I).Text));
         if I < Self.Num_Options then
            Output.New_Line;
         end if;
      end loop;
   end Put_Image_Item;

end Hilbert.Item;
