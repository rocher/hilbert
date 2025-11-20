with Ada.Containers.Hashed_Maps;
with Ada.Strings.Hash;
with Ada.Strings.Text_Buffers;

with Hilbert.Bit_Stream;
with Hilbert.Strings; use Hilbert.Strings;
with Hilbert.Types;   use Hilbert.Types;

package Hilbert.Batch is

   function "=" (Left, Right : UString) return Boolean
   is (To_String (Left) = To_String (Right));

   type Batch_Item_Type is record
      Num_Items : Positive;
      --  The number of items in the Bit_Stream.

      Bit_Stream : Hilbert.Bit_Stream.Bit_Stream_Type;
      --  The Bit_Stream of the exam.
   end record;
   --  Represents a single exam in a batch.

   package Batch_Map_Package is new
     Ada.Containers.Hashed_Maps
       (Key_Type        => Exam_ID_Type,
        Element_Type    => Batch_Item_Type,
        Hash            => Ada.Strings.Hash,
        Equivalent_Keys => "=");
   --  A map from Exam_IDs to their corresponding Batch_Items.

   subtype Batch_Map_Type is Batch_Map_Package.Map;

   type Batch_Type is record
      Exams_Name : Exams_Name_Type := Exams_Name_Type'(others => ' ');
      --  The name of the exams file associated with this batch.

      Map : Batch_Map_Type;
      --  The map of Exam_IDs to their corresponding Batch_Items.
   end record
   with Put_Image => Put_Image_Batch;
   pragma Style_Checks (Off);
   --  Represents a batch of exams. A batch contains multiple exams identified
   --  by their Exam_IDs, each associated with a Bit_Stream and the number of
   --  items in that Bit_Stream.

   --  For example, "SMX1_DIG_RA2_202511_Batch.txt" contains the batch for the
   --  exams "SMX1_DIG_RA2_202511".
   --
   --  First line: <Cycle> <Module> <RA Number> <Module Name>
   --  SMX1 DIG RA2 Digitalització Aplicada als Sectors Productius
   --
   --  Subsequent lines: one per exam,
   --  EXAM <Exam_ID> <Num_Items> <Total Options>/<Num Correct Options>/<Difficulty> <Bit_Stream>

   --  Example lines:
   --  EXAM SMX1_DIG_RA2_202511/012 38 164/085/189 1000 01101 1010 110 0001 1011 01011 111 10 1100 1100 100 1111 1000 10110 0010 010 0010 11001 1010 010111 01101 00111 1000 10011 10101 0001 011110 00101 1110 101111 01101 1000 1000 11001 10011 1000 0100
   --  EXAM SMX1_DIG_RA2_202511/013 38 164/079/184 101101 0101 01110 10110 0010 1101 0010 10 0011 0010 010 11100 0010 0101 11001 0001 0010 1000 11000 0001 1010 01110 10101 0001 0100 10011 1100 01101 0100 11100 1111 010 01101 1001 0100 00111 01110 11001

   -- <Difficulty> is a number between 000 and 300 and is computed as the
   -- average of the difficulties of the items in the exam multiplied by 100.
   pragma Style_Checks (On);

   procedure Read (Self : out Batch_Type; Exams_Name : Exams_Name_Type)
   with Pre => Is_Exams_Name (Exams_Name);
   --  Reads the batch of exams with the specified name. The filename is
   --  constructed by appending the batch suffix to the exams name.

   procedure Put_Image_Batch
     (Output : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
      Self   : Batch_Type);
   --  Outputs a textual representation of the batch to the specified output
   --  buffer.

end Hilbert.Batch;
