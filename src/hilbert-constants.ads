with Hilbert.Strings; use Hilbert.Strings;

package Hilbert.Constants is

   use all type UString;

   Pool_Suffix        : constant String := "_Pool.txt";
   Exams_Suffix       : constant String := "_Exams.txt";
   Batch_Suffix       : constant String := "_Batch.txt";

   Max_Options_Per_Item : constant Positive := 16;
   Max_Items_Per_Exam   : constant Positive := 256;

   Signature_Version_Str : constant String := "0000";

   Signature_Version     : constant UString :=
     To_UString (Signature_Version_Str);
   Signature_Sentinel    : constant UString := "1" & Signature_Version;
   Signature_Mod_Length  : constant Positive := 8;
   Signature_Padding_Bit : constant Wide_Character := '0';

private

end Hilbert.Constants;
