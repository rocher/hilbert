with Hilbert.Item;

with Hilbert.Constants; use Hilbert.Constants;
with Hilbert.Convert;   use Hilbert.Convert;
with Hilbert.Random;    use Hilbert.Random;

package body Hilbert.Exam is

   -----------------------
   -- Compute_Signature --
   -----------------------

   procedure Compute_Signature (Exam : in out Hilbert.Exam.Object) is
      Binary : UString := Signature_Sentinel;
   begin
      Binary.Append (Integer_To_Byte (Integer (Exam.Pool.Length)));
      for I in 1 .. Integer (Exam.Pool.Length) loop
         declare
            Item : constant Hilbert.Item.Object := Exam.Pool.Element (I);
         begin
            Binary.Append (Integer_To_Nibble (Item.Num_Options));
            for J in 1 .. Item.Num_Options loop
               Binary.Append
                 (if Item.Options (J).Is_Correct then "1" else "0");
            end loop;
         end;
      end loop;

      --  Add padding bits to align to byte boundary
      while Binary.Length mod Signature_Mod_Length /= 0 loop
         Binary.Append (Signature_Padding_Bit);
      end loop;

      --  Convert to hexadecimal
      declare
         Num_Bytes : constant Positive := Binary.Length / Signature_Mod_Length;
         Low       : Positive;
         High      : Natural;
      begin
         Exam.Signature := Null_UString;
         for I in 0 .. Num_Bytes - 1 loop
            Low := I * 8 + 1;
            High := Natural (Low) + 7;
            Exam.Signature.Append
              (Byte_To_Hexadecimal (Binary.Unbounded_Slice (Low, High)));
         end loop;
      end;
   end Compute_Signature;

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
      if Num_Items > Positive (Pool.Length) then
         raise Constraint_Error with "Not enough items in pool";
      end if;

      for I in 1 .. Num_Items loop
         declare
            Index    : constant Positive :=
              Random_Index (Positive (Origin.Length));
            New_Item : Hilbert.Item.Object := Origin.Element (Index);
         begin
            New_Item.Shuffle_Options;
            New_Item.Number := Item_Number;

            Item_Number := @ + 1;
            Σ_Difficulty :=
              @
              + (if New_Item.Difficulty = Easy
                 then 1.0
                 elsif New_Item.Difficulty = Medium
                 then 2.0
                 else 3.0);

            New_Exam.Pool.Append (New_Item, 1);
            Origin.Delete (Index);
         end;
      end loop;

      New_Exam.Difficulty := Σ_Difficulty / Float (Num_Items);
      Compute_Signature (New_Exam);

      return New_Exam;
   end Create_Exam;

   ----------------
   -- Set_Number --
   ----------------

   procedure Set_Number (Self : in out Object; New_Number : Natural) is
   begin
      Self.Number := New_Number;
   end Set_Number;

   -----------
   -- Write --
   -----------

   procedure Write (Self : Object; Out_File : in out WIO.File_Type) is
      Title_Line : constant BString :=
        "EXAM"
        & Integer'Wide_Image (Integer (Self.Number))
        & Integer'Wide_Image (Integer (Self.Pool.Length))
        & Integer'Wide_Image (Integer (Self.Difficulty * 100.0))
        & " "
        & To_BString (Self.Signature);
   begin
      Out_File.Put_Line (Title_Line);
      for I in 1 .. Positive (Self.Pool.Length) loop
         declare
            Item : constant Hilbert.Item.Object := Self.Pool.Element (I);
         begin
            Item.Write (Out_File);
         end;
      end loop;
   end Write;

   --------------------
   -- Put_Image_Exam --
   --------------------

   procedure Put_Image_Exam
     (Output : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
      Self   : Object) is
   begin
      Output.Put ("EXAM");
      Output.Put (Self.Number'Image);
      Output.Put (Self.Pool.Length'Image);
      Output.Wide_Put (Integer'Wide_Image (Integer (Self.Difficulty * 100.0)));
      Output.Put (" ");
      Output.Wide_Put (To_BString (Self.Signature));
   end Put_Image_Exam;

end Hilbert.Exam;
