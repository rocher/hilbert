with Hilbert.Strings; use Hilbert.Strings;

package Hilbert.Version is

   type Version_Type is record
      Major : Natural;
      Minor : Natural;
   end record;

   function Has_Version (S : BWString) return Boolean;
   function Has_Version (S : UWString) return Boolean
   is (Has_Version (To_BWString (S)));

   function Get_Version (S : BWString) return Version_Type;

end Hilbert.Version;
