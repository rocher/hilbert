package body Hilbert.Bit_Stream is

   use all type Hilbert.Strings.UString;

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
      Item   : Hilbert.Bit_Stream_Item.Bit_Stream_Item_Type;
   begin
      loop
         Chunk := Get_Next_Chunk (Bits, Cursor);
         exit when Chunk = Null_UString;
         Item.Bits := Chunk;
         Item.Check_Validity;
         Self.Append (Item);
      end loop;
   end Load_From_UString;

end Hilbert.Bit_Stream;
