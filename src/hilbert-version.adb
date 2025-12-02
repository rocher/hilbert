with Hilbert.Types; use Hilbert.Types;

package body Hilbert.Version is

   -----------------
   -- Has_Version --
   -----------------

   function Has_Version (S : String) return Boolean is
      β : constant Natural := S'First + Version_Prefix'Length;
   begin
      return
        S'Length >= Version_Length
        and then S (S'First .. β - 1) = Version_Prefix
        and then Is_All_Digits (S (β .. β + 1))
        and then S (β + 2) = '.'
        and then Is_All_Digits (S (β + 3 .. β + 4));
   end Has_Version;

   -----------------
   -- Get_Version --
   -----------------

   function Get_Version (S : String) return Version_Type is
      β : constant Natural := S'First + Version_Prefix'Length;
   begin
      Version : constant Version_Type := S (β .. β + 4);
      return Version;
   end Get_Version;

end Hilbert.Version;
