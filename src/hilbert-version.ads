package Hilbert.Version is

   subtype Version_Type is String (1 .. 5);
   --  Format "MM.mm"  e.g. "25.12"

   Null_Version : constant Version_Type := "00.00";
   --  Represents a null version.

   Version_Prefix : constant String := "HV=";
   --  Version_Format "HV=MM.mm", e.g. HV=25.12

   Version_Length : constant Natural := Version_Prefix'Length + 5;
   --  Total length of the version string in a file, e.g. HV=25.12

   function Has_Version (S : String) return Boolean;
   --  Returns True if S contains a valid version string.

   function Get_Version (S : String) return Version_Type
   with Pre => Has_Version (S);
   --  Extracts and returns the version from S.

end Hilbert.Version;
