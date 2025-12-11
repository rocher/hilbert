package body Hilbert.CSV_Strings is

   Enc_Str : Base_String := Null_Base_String;
   Sep_Str : Base_String := Null_Base_String;

   ---------------
   -- Substring --
   ---------------

   function Substring
     (Source : CSV_String; Low : Positive; High : Natural) return Base_String
   is (Substring (Source.Values, Low, High));

   --------------------
   -- Escaped_String --
   --------------------

   function Escaped_String (Field : Base_String) return Base_String is
      Escaped : Base_String := Null_Base_String;
   begin
      for I in 1 .. Length (Field) loop
         C : constant Base_String := Substring (Field, I, I);
         if C = Enc_Str then
            Append_Char (Escaped, Enclosure);
         end if;
         --  if C = Esc_Str then
         --     Append_Char (Escaped, Escape);
         --  end if;
         Append_String (Escaped, C);
      end loop;
      return Escaped;
   end Escaped_String;

   --------------------
   -- Get_Next_Field --
   --------------------

   function Get_Next_Field
     (Self : CSV_String; Cursor : in out Positive; Found : out Boolean)
      return Base_String
   is
      Result : Base_String := Null_Base_String;
      I      : Positive := Cursor;
      Len    : constant Natural := Length (Self.Values);
      --  In_Quotes : Boolean := False;
   begin
      Found := False;

      if I > Len + 1 then
         return Null_Base_String;
      end if;

      Found := True;

      if I = Len + 1 then
         --  empty field only after last separator
         Cursor := I + 1;
         Pre_Str : constant Base_String :=
           Substring (Self.Values, I - 1, I - 1);
         if Pre_Str = Sep_Str then
            return Null_Base_String;
         else
            --  no more fields
            Found := False;
            return Null_Base_String;
         end if;
      end if;

      --  Check if field starts with quote
      if I <= Len and then Substring (Self, I, I) = Enc_Str then
         --  In_Quotes := True;
         I := I + 1;  --  Skip opening quote

         --  Read quoted field
         while I <= Len loop
            if Substring (Self, I, I) = Enc_Str then
               if I < Len and then Substring (Self, I + 1, I + 1) = Enc_Str
               then
                  --  Doubled quote -> literal quote
                  Append_String (Result, Enc_Str);
                  I := I + 2;
               else
                  --  Closing quote
                  I := I + 1;
                  exit;
               end if;
            else
               Append_String (Result, Substring (Self, I, I));
               --  I := I + 1;
               I := I + 1;
            end if;
         end loop;
      else
         --  Read unquoted field
         while I <= Len and then Substring (Self, I, I) /= Sep_Str loop
            Append_String (Result, Substring (Self, I, I));
            I := I + 1;
         end loop;
      end if;

      --  Skip separator if present
      if I <= Len and then Substring (Self, I, I) = Sep_Str then
         I := I + 1;
      end if;

      Cursor := I;
      return Result;
   end Get_Next_Field;

   ------------------
   -- Append_Field --
   ------------------

   procedure Append_Field (Self : in out CSV_String; Field : Base_String) is
   begin
      Has_Enclosure : constant Boolean := Index_Of (Field, Enclosure, 1) > 0;
      Has_Separator : constant Boolean := Index_Of (Field, Separator, 1) > 0;

      Self.Fields := Self.Fields + 1;
      if Self.Fields > 1 then
         Append_Char (Self.Values, Separator);
      end if;

      if Has_Enclosure or else Has_Separator then
         Append_Char (Self.Values, Enclosure);
         Append_String (Self.Values, Escaped_String (Field));
         Append_Char (Self.Values, Enclosure);
      else
         Append_String (Self.Values, Field);
      end if;
   end Append_Field;

   -----------------------------
   -- Load_Fields_From_String --
   -----------------------------

   procedure Load_Fields_From_String
     (Self : in out CSV_String; Str : Base_String) is
   begin
      Self := Null_CSV_String;
      Found : Boolean := True;
      Cursor : Positive := 1;
      Origin : constant CSV_String := (0, Str);
      while Found loop
         Field : constant Base_String :=
           Get_Next_Field (Origin, Cursor, Found);
         if Found then
            Append_Field (Self, Field);
         end if;
      end loop;
   end Load_Fields_From_String;

   ------------
   -- Fields --
   ------------

   function Fields (Self : CSV_String) return Natural
   is (Self.Fields);

   ------------
   -- Values --
   ------------

   function Values (Self : CSV_String) return Base_String
   is (Self.Values);

begin

   Append_Char (Enc_Str, Enclosure);
   Append_Char (Sep_Str, Separator);

end Hilbert.CSV_Strings;
