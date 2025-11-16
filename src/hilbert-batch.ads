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
      Num_Items  : Positive;
      Bit_Stream : Hilbert.Bit_Stream.Object;
   end record;

   package Batch_Map is new
     Ada.Containers.Hashed_Maps
       (Key_Type        => Exam_ID_Type,
        Element_Type    => Batch_Item_Type,
        Hash            => Ada.Strings.Hash,
        Equivalent_Keys => "=");

   type Object is record
      Exams_Name : Exams_Name_Type := Exams_Name_Type'(others => ' ');
      Batch      : Batch_Map.Map;
   end record
   with Put_Image => Put_Image_Batch;

   procedure Read (Self : out Object; Exams_Name : Exams_Name_Type)
   with Pre => Is_Exams_Name (Exams_Name);

   procedure Put_Image_Batch
     (Output : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
      Self   : Object);

end Hilbert.Batch;
