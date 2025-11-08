with Hilbert.Convert; use Hilbert.Convert;
with Hilbert.Random; use Hilbert.Random;

package body Hilbert.Item is

   ----------
   -- Read --
   ----------

   procedure Read (Self : out Object; In_File : in out WIO.File_Type) is
   begin
      Self :=
        (Number      => 0,
         Difficulty  => Easy,
         Question    => Null_UString,
         Num_Options => 1,
         Options     =>
           [others => (Text => Null_UString, Is_Correct => False)]);

      declare
         Line : constant BString := In_File.Get_Line;
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
         Self.Question := To_UString (Line (3 .. Line'Length));
      end;

      --  Read Number of Options
      declare
         Line : constant BString := WIO.Get_Line (In_File);

         Num_Options_Int : constant Integer :=
           Integer'Value (Line'Image (2 .. 2));
      begin
         if Num_Options_Int < 1 or else Num_Options_Int > Max_Options then
            raise Constraint_Error with "Number of options out of range";
         end if;
         Self.Num_Options := Num_Options_Type (Num_Options_Int);
      end;

      --  Read Options
      for I in 1 .. Self.Num_Options loop
         --  Read Option Text prefixed by 0 or 1 (indicating correctness)
         declare
            Line : constant BString := WIO.Get_Line (In_File);
         begin
            Self.Options (I).Text := To_UString (Line (3 .. Line'Length));

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
      if not WIO.End_Of_File (In_File) then
         In_File.Skip_Line;
      end if;
   end Read;

   -----------
   -- Write --
   -----------

   procedure Write (Self : Object; Out_File : in out WIO.File_Type) is
   begin
      Out_File.Put (Trim (Self.Number) & " ");
      Out_File.Put_Line (To_BString (Self.Question));
      for I in 1 .. Self.Num_Options loop
         Out_File.Put ("    " & To_BString (Self.Options (I).Text));
         Out_File.New_Line;
      end loop;
   end Write;

   ---------------------
   -- Shuffle_Options --
   ---------------------

   procedure Shuffle_Options (Self : in out Object) is

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

   --------------------
   -- Put_Image_Item --
   --------------------

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
      Output.Wide_Put (To_BString (Self.Question));
      Output.New_Line;
      Output.Put (Self.Num_Options'Image (2 .. Self.Num_Options'Image'Length));
      Output.New_Line;

      for I in 1 .. Self.Num_Options loop
         Output.Put ((if Self.Options (I).Is_Correct then '1' else '0') & " ");
         Output.Wide_Put (To_BString (Self.Options (I).Text));
         if I < Self.Num_Options then
            Output.New_Line;
         end if;
      end loop;
   end Put_Image_Item;

end Hilbert.Item;
