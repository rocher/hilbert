with Hilbert.Convert; use Hilbert.Convert;
with Hilbert.Random;  use Hilbert.Random;

package body Hilbert.Exam is

   use Hilbert.Item.Item_Map_Package;

   -----------------
   -- Create_Exam --
   -----------------

   function Create_Exam
     (Pool : Hilbert.Pool.Pool_Type; Num_Items : Positive) return Exam_Type
   is
      use all type Hilbert.Item.Difficulty_Type;

      Origin   : Hilbert.Pool.Pool_Type := Pool;
      New_Exam : Exam_Type;

      Σ_Difficulty : Float := 0.0;

      procedure Append_Item (Item : in out Hilbert.Item.Item_Type) is
      begin
         Item.Shuffle_Options;

         New_Exam.Items.Append (Item);
         New_Exam.Num_Options := @ + Item.Num_Options;
         for I in 1 .. Item.Num_Options loop
            if Item.Options (I).Is_Correct then
               New_Exam.Num_Trues := @ + 1;
            end if;
         end loop;

         Σ_Difficulty :=
           @
           + (if Item.Difficulty = Easy
              then 1.0
              elsif Item.Difficulty = Medium
              then 2.0
              else 3.0);
      end Append_Item;

   begin
      if Num_Items > Pool.Num_Items then
         raise Constraint_Error with "Not enough items in pool";
      end if;

      --  Move one item from each group of the Origin pool to New_Exam.
      if Natural (Origin.Groups.Length) > 0 then
         declare
            Group : Hilbert.Item.Item_Map_Package.Cursor;
         begin
            Group := Origin.Groups.First;
            loop
               exit when Group = Hilbert.Item.Item_Map_Package.No_Element;
               declare
                  Index : constant Positive :=
                    Random_Index
                      (Positive (Origin.Groups.Reference (Group).Length));
               begin
                  Append_Item
                    (Origin.Groups.Reference (Group).Element (Index));
               end;
               Group := Group.Next;
            end loop;
         end;
      end if;

      --  Select random items from the Origin pool until New_Exam has the
      --  required number of items.
      loop
         exit when Natural (New_Exam.Items.Length) >= Num_Items;
         declare
            Index    : constant Positive :=
              Random_Index (Positive (Origin.Items.Length));
            New_Item : Hilbert.Item.Item_Type := Origin.Items.Element (Index);
         begin
            Append_Item (New_Item);
            Origin.Items.Delete (Index);
         end;
      end loop;

      --  Shuffle the items in New_Exam to ensure a random order.
      for I in 1 .. Num_Items loop
         declare
            Index1 : constant Positive := Random_Index (Num_Items);
            Index2 : constant Positive := Random_Index (Num_Items);
         begin
            New_Exam.Items.Swap (Index1, Index2);
         end;
      end loop;

      --  Renumber the items in New_Exam sequentially from 1 to Num_Items.
      for I in 1 .. Num_Items loop
         New_Exam.Items (I).Number := I;
      end loop;

      New_Exam.Difficulty := Σ_Difficulty / Float (Num_Items);

      return New_Exam;
   end Create_Exam;

   ----------------
   -- Set_Number --
   ----------------

   procedure Set_Id (Self : in out Exam_Type; Id : UWString) is
   begin
      Self.Id := Id;
   end Set_Id;

   ----------------------
   -- Get_Answers_Bits --
   ----------------------

   function Get_Answers_Bits (Self : Exam_Type) return UString is
   begin
      return Result : UString := Null_UString do
         for I in 1 .. Positive (Self.Items.Length) loop
            Result.Append (Self.Items.Element (I).Get_Answers_Bits);
            if I < Positive (Self.Items.Length) then
               Result.Append (' ');
            end if;
         end loop;
      end return;
   end Get_Answers_Bits;

   ----------------
   -- Title_Line --
   ----------------

   function Title_Line (Self : Exam_Type) return BWString is
   begin
      return
        "EXAM "
        & To_BWString (Self.Id)
        & Integer'Wide_Image (Integer (Self.Items.Length))
        & " "
        & Format (Self.Num_Options, 3, '0')
        & "/"
        & Format (Self.Num_Trues, 3, '0')
        & "/"
        & Trim (Integer (Self.Difficulty * 100.0))
        & " "
        & To_BWString (Self.Get_Answers_Bits);
   end Title_Line;

   --------------
   -- Write_To --
   --------------

   procedure Write_To (Self : Exam_Type; Out_File : in out WIO.File_Type) is
   begin
      Out_File.Put_Line (Self.Title_Line);
      for I in 1 .. Positive (Self.Items.Length) loop
         declare
            Item : constant Hilbert.Item.Item_Type := Self.Items.Element (I);
         begin
            Item.Write_To (Out_File);
         end;
      end loop;
   end Write_To;

   --------------------
   -- Put_Image_Exam --
   --------------------

   procedure Put_Image_Exam
     (Output : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
      Self   : Exam_Type) is
   begin
      Output.Wide_Put (Self.Title_Line);
   end Put_Image_Exam;

end Hilbert.Exam;
