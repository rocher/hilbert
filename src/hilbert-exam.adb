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
        & Integer'Wide_Image (Integer (Self.Pool.Length))
        & " "
        & Trim (Self.Num_Options)
        & "/"
        & Trim (Self.Num_Trues)
        & "/"
        & Trim (Integer (Self.Difficulty * 100.0))
        & " "
        & To_BString (Self.Signature);
   end Title_Line;

   -----------
   -- Write --
   -----------

   procedure Write (Self : Object; Out_File : in out WIO.File_Type) is
   begin
      Out_File.Put_Line (Self.Title_Line);
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
      Output.Wide_Put (Self.Title_Line);
   end Put_Image_Exam;

end Hilbert.Exam;
