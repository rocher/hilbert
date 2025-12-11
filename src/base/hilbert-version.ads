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

   procedure Set_Version (S : String)
   with Pre => Has_Version (S);
   --  Sets the current version to V. It is called when reading a file
   --  header that contains a version string. Establishes the version for
   --  the rest of the file processing.

   function Get_Version return Version_Type
   with Inline_Always;
   --  Returns the current version.

   function Get_Version_From_String (S : String) return Version_Type
   with Pre => Has_Version (S);
   --  Extracts and returns the version from the given string S.

end Hilbert.Version;
