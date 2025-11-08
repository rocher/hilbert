with Hilbert.Strings; use Hilbert.Strings;

package Hilbert.Constants is

   Max_Options_Per_Item : constant Positive := 16;
   Max_Items_Per_Exam   : constant Positive := 256;

   Signature_Version     : constant UString := To_UString ("0000");
   Signature_Sentinel    : constant UString := "1" & Signature_Version;
   Signature_Mod_Length  : constant Positive := 8;
   Signature_Padding_Bit : constant Character := '0';

end Hilbert.Constants;
