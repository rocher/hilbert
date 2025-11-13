with Hilbert.Exam;
with Hilbert.Strings; use Hilbert.Strings;

package Hilbert.Signature is

   --  Signature format:
   --    - 5 bits: 1 per Sentinel '1' + 4 per version, e.g. '0000'
   --    - 8 bits: Number of items in exam
   --    - For each item:
   --      - 4 bits: Number of options
   --      - N bits: Correctness bit per option (1 = correct, 0 = incorrect)
   --    - Padding bits (0) to align to byte boundary
   --    - Hexadecimal representation of the binary string

   function Compute_Signature (Exam : Hilbert.Exam.Object) return UWString;

   function Get_Options_Stream (Signature : UWString) return UWString;

end Hilbert.Signature;
