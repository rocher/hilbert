with Hilbert.Item;

with Hilbert.Convert;   use Hilbert.Convert;
with Hilbert.Random;    use Hilbert.Random;
with Hilbert.Signature; use Hilbert.Signature;

package body Hilbert.Exam is

   -----------------
   -- Create_Exam --
   -----------------

   function Create_Exam
     (Pool : Hilbert.Pool.Object; Num_Items : Positive) return Object
   is
      use all type Hilbert.Item.Difficulty_Type;

      Origin   : Hilbert.Pool.Object := Pool;
      New_Exam : Object;

      Item_Number  : Natural := 1;
      Σ_Difficulty : Float := 0.0;
   begin
      if Num_Items > Positive (Pool.Items.Length) then
         raise Constraint_Error with "Not enough items in pool";
      end if;

      for I in 1 .. Num_Items loop
         declare
            Index    : constant Positive :=
              Random_Index (Positive (Origin.Items.Length));
            New_Item : Hilbert.Item.Object := Origin.Items.Element (Index);
         begin
            New_Item.Shuffle_Options;
            New_Item.Number := Item_Number;

            New_Exam.Num_Options := @ + New_Item.Num_Options;
            for I in 1 .. New_Item.Num_Options loop
               if New_Item.Options (I).Is_Correct then
                  New_Exam.Num_Trues := @ + 1;
               end if;
            end loop;

            Item_Number := @ + 1;
            Σ_Difficulty :=
              @
              + (if New_Item.Difficulty = Easy
                 then 1.0
                 elsif New_Item.Difficulty = Medium
                 then 2.0
                 else 3.0);

            New_Exam.Pool.Items.Append (New_Item, 1);
            Origin.Items.Delete (Index);
         end;
      end loop;

      New_Exam.Difficulty := Σ_Difficulty / Float (Num_Items);
      New_Exam.Signature := Compute_Signature (New_Exam);

      return New_Exam;
   end Create_Exam;

   ----------------
   -- Set_Number --
   ----------------

   procedure Set_Id (Self : in out Object; Id : UString) is
   begin
      Self.Id := Id;
   end Set_Id;

   ----------------
   -- Title_Line --
   ----------------

   function Title_Line (Self : Object) return BString is
   begin
      return
        "EXAM "
        & To_BString (Self.Id)
        & Integer'Wide_Image (Integer (Self.Pool.Items.Length))
        & " "
        & Format (Self.Num_Options, 3, '0')
        & "/"
        & Format (Self.Num_Trues, 3, '0')
        & "/"
        & Trim (Integer (Self.Difficulty * 100.0))
        & " "
        & To_BString (Get_Options_Stream (Self.Signature));
   end Title_Line;

   --------------
   -- Write_To --
   --------------

   procedure Write_To (Self : Object; Out_File : in out WIO.File_Type) is
   begin
      Out_File.Put_Line (Self.Title_Line);
      for I in 1 .. Positive (Self.Pool.Items.Length) loop
         declare
            Item : constant Hilbert.Item.Object := Self.Pool.Items.Element (I);
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
      Self   : Object) is
   begin
      Output.Wide_Put (Self.Title_Line);
   end Put_Image_Exam;

end Hilbert.Exam;
