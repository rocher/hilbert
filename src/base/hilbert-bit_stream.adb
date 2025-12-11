with Hilbert.Version; use Hilbert.Version;

package body Hilbert.Bit_Stream is

   use all type Hilbert.Strings.UString;

   ----------------------
   -- Get_Next_Chunk_0 --
   ----------------------

   function Get_Next_Chunk_0
     (Bit_String : UString; Cursor : in out Natural) return UString is
   begin
      Low : constant Natural := Bit_String.Index_Non_Blank (From => Cursor);
      High : constant Natural := Bit_String.Index (" ", From => Low);
      if Low < High then
         Cursor := High;
         return Bit_String.Unbounded_Slice (Low, High - 1);
      elsif Low < Bit_String.Length and then High = 0 then
         Cursor := Bit_String.Length;
         return Bit_String.Unbounded_Slice (Low, Bit_String.Length);
      else
         return Null_UString;
      end if;
   end Get_Next_Chunk_0;

   --------------------------
   -- Get_Next_Chunk_25_12 --
   --------------------------

   function Get_Next_Chunk_25_12
     (Bit_String : UString; Cursor : in out Natural) return UString is
   begin
      --  skip non-binary characters
      Low : Natural := Cursor;
      while Low <= Bit_String.Length
        and then Bit_String.Element (Low) /= '0'
        and then Bit_String.Element (Low) /= '1'
      loop
         Low := Low + 1;
      end loop;

      --  check for end of string
      if Low > Bit_String.Length then
         Cursor := Low;
         return Null_UString;
      end if;

      --  find end of binary chunk
      High : Natural := Low;
      while High <= Bit_String.Length
        and then ((Bit_String.Element (High) = '0'
                   or else Bit_String.Element (High) = '1'))
      loop
         High := High + 1;
      end loop;
      Cursor := High;
      High := High - 1;

      --  extract chunk
      return Bit_String.Unbounded_Slice (Low, High);
   end Get_Next_Chunk_25_12;

   -----------------------
   -- Load_From_UString --
   -----------------------

   procedure Load_From_UString (Self : in out Bit_Stream_Type; Bits : UString)
   is
      Cursor : Natural := 1;
      Chunk  : UString;
      Item   : Hilbert.Bit_Stream_Item.Bit_Stream_Item_Type;
   begin
      loop
         if Get_Version = "25.12" then
            Chunk := Get_Next_Chunk_25_12 (Bits, Cursor);
         else
            Chunk := Get_Next_Chunk_0 (Bits, Cursor);
         end if;
         exit when Chunk = Null_UString;
         Item.Bits := Chunk;
         Item.Check_Validity;
         Self.Append (Item);
      end loop;
   end Load_From_UString;

end Hilbert.Bit_Stream;
