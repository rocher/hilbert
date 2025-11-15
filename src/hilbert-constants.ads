with Hilbert.Strings; use Hilbert.Strings;

package Hilbert.Constants is

   use all type UWString;

   Pool_Suffix        : constant String := "_Pool.txt";
   Exams_Suffix       : constant String := "_Exams.txt";
   Batch_Suffix       : constant String := "_Batch.txt";

   Max_Options_Per_Item : constant Positive := 16;
   Max_Items_Per_Exam   : constant Positive := 256;

   Random_Seed : constant Integer := 3221;

   Signature_Version_Str : constant String := "0000";

   Signature_Version     : constant UWString :=
     To_UWString (Signature_Version_Str);
   Signature_Sentinel    : constant UWString := "1" & Signature_Version;
   Signature_Mod_Length  : constant Positive := 8;
   Signature_Padding_Bit : constant Wide_Character := '0';

private

end Hilbert.Constants;
