generic

   type Base_String is private;
   --  The base string type used for CSV fields. Can be any Unbounded_String
   --  type.

   Null_Base_String : Base_String;
   --  The null value for Base_String.

   Separator : Character := ',';
   --  The character used to separate fields.

   Enclosure : Character := '"';
   --  The character used to enclose fields if a field contains the Separator
   --  or Enclosure character.

   with function Length (Source : Base_String) return Natural is <>;
   --  Returns the length of the Base_String.

   with
     function Index_Of
       (Source : Base_String; Char : Character; From : Natural) return Natural
     is <>;
   --  Returns the index of the first occurrence of Char in Source starting
   --  from position From, or 0 if not found.

   with
     function Substring
       (Source : Base_String; Low : Positive; High : Natural)
        return Base_String is <>;
   --  Returns the substring of Source from position Low to High.

   with procedure Append_Char (Source : in out Base_String; Char : Character);
   --  Appends a character to the Base_String.

   with
     procedure Append_String (Source : in out Base_String; Str : Base_String);
   --  Appends a Base_String to another Base_String.

package Hilbert.CSV_Strings
is
   type CSV_String is private;
   --  A CSV string consisting of multiple fields separated by the Separator
   --  character, with fields optionally enclosed by the Enclosure character
   --  and escaped with double quotes.

   First : constant Natural := 1;
   --  Assume that string indices start at 1.

   Null_CSV_String : constant CSV_String;
   --  An empty CSV_String.

   function Get_Next_Field
     (Self : CSV_String; Cursor : in out Positive; Found : out Boolean)
      return Base_String;
   --  Returns the next field from the CSV_String, updating the cursor and
   --  indicating if a field was found.

   procedure Append_Field (Self : in out CSV_String; Field : Base_String);
   --  Appends a field to the CSV_String, escaping/enclosing as needed.

   procedure Load_Fields_From_String
     (Self : in out CSV_String; Str : Base_String);
   --  Loads fields into the CSV_String from a given Base_String.

   function Fields (Self : CSV_String) return Natural;
   --  Returns the number of fields in the CSV_String.

   function Values (Self : CSV_String) return Base_String;
   --  Returns the concatenated string of all fields in the CSV_String.

private

   type CSV_String is record
      Fields : Natural := 0;
      Values : Base_String := Null_Base_String;
   end record;

   Null_CSV_String : constant CSV_String := (0, Null_Base_String);

end Hilbert.CSV_Strings;
