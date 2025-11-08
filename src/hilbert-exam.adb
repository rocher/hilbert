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

      Σ_Difficulty : Float := 0.0;
      Origin       : Hilbert.Pool.Object := Pool;
      New_Exam     : Object;
   begin
      if Num_Items > Positive (Pool.Length) then
         raise Constraint_Error with "Not enough items in pool";
      end if;

      for I in 1 .. Num_Items - 1 loop
         declare
            Index    : Positive;
            New_Item : Hilbert.Item.Object;
         begin
            Index := Random_Index (Positive (Origin.Length));
            New_Item := Origin.Element (Index);
            Origin.Delete (Index);

            New_Item.Shuffle_Options;
            New_Exam.Pool.Append (New_Item, 1);
            Σ_Difficulty :=
              @
              + (if New_Item.Difficulty = Easy
                 then 1.0
                 elsif New_Item.Difficulty = Medium
                 then 2.0
                 else 3.0);
         end;
      end loop;
      New_Exam.Pool.Append (Origin.Element (1));

      New_Exam.Difficulty := Σ_Difficulty / Float (Num_Items);
      Compute_Signature (New_Exam);

      return New_Exam;
   end Create_Exam;

   --------------------
   -- Put_Image_Exam --
   --------------------

   procedure Put_Image_Exam
     (Output : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
      Self   : Object) is
   begin
      Output.Put
        ("EXAM"
         & Self.Pool.Length'Image
         & " "
         & To_String (Self.Signature)
         & Integer'Image (Integer (Self.Difficulty * 100.0)));
   end Put_Image_Exam;

end Hilbert.Exam;
