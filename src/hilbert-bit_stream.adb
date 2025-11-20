package body Hilbert.Bit_Stream is

   use all type Hilbert.Strings.UString;

   -----------------------
   -- Count_Valid_Items --
   -----------------------

   procedure Count_Valid_Items (Self : in out Bit_Stream_Type) is
   begin
      Self.Valid_Items := 0;
      for Item of Self.Bit_Stream loop
         Item.Check_Validity;
         if Item.Is_Valid then
            Self.Valid_Items := @ + 1;
         end if;
      end loop;
   end Count_Valid_Items;

   -----------------------
   -- Check_Extra_Items --
   -----------------------

   procedure Check_Extra_Items
     (Self : in out Bit_Stream_Type; Origin : Bit_Stream_Type) is
   begin
      Self.Extra_Items :=
        Integer (Self.Bit_Stream.Length) - Integer (Origin.Bit_Stream.Length);
   end Check_Extra_Items;

   --------------------
   -- Get_Next_Chunk --
   --------------------

   function Get_Next_Chunk
     (Bit_String : UString; Cursor : in out Natural) return UString
   is
      Low  : constant Natural := Bit_String.Index_Non_Blank (From => Cursor);
      High : constant Natural := Bit_String.Index (" ", From => Low);
   begin
      if Low < High then
         Cursor := High;
         return Bit_String.Unbounded_Slice (Low, High - 1);
      elsif Low < Bit_String.Length and then High = 0 then
         Cursor := Bit_String.Length;
         return Bit_String.Unbounded_Slice (Low, Bit_String.Length - 1);
      else
         return Null_UString;
      end if;
   end Get_Next_Chunk;

   -----------------------
   -- Load_From_UString --
   -----------------------

   procedure Load_From_UString (Self : in out Bit_Stream_Type; Bits : UString)
   is
      Cursor : Natural := 1;
      Chunk  : UString;
      Item   : Hilbert.Bit_Stream_Item.Bit_Stream_Type;
   begin
      loop
         Chunk := Get_Next_Chunk (Bits, Cursor);
         exit when Chunk = Null_UString;
         Item.Bits := Chunk;
         Item.Check_Validity;
         Self.Bit_Stream.Append (Item);
      end loop;
   end Load_From_UString;

end Hilbert.Bit_Stream;
