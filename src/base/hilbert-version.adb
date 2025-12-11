with Hilbert.Types; use Hilbert.Types;

package body Hilbert.Version is

   Version : Version_Type := Null_Version;

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
   -- Set_Version --
   -----------------

   procedure Set_Version (S : String) is
      β : constant Natural := S'First + Version_Prefix'Length;
   begin
      Version := S (β .. β + 4);
   end Set_Version;

   -----------------
   -- Get_Version --
   -----------------

   function Get_Version return Version_Type
   is (Version);

   -----------------------------
   -- Get_Version_From_String --
   -----------------------------

   function Get_Version_From_String (S : String) return Version_Type is
      β : constant Natural := S'First + Version_Prefix'Length;
   begin
      Version : constant Version_Type := S (β .. β + 4);
      return Version;
   end Get_Version_From_String;

end Hilbert.Version;
