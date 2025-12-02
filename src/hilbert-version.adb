package body Hilbert.Version is

   Version_Prefix : constant BWString := "HV=";
   --  Version_Format "HV=MM.mm"  e.g. HV=25.12

   Version_Length : constant Natural := Version_Prefix'Length + 5;
   --  Total length of the version string.

   -----------------
   -- Has_Version --
   -----------------

   function Has_Version (S : BWString) return Boolean is
   begin
      return
        S'Length >= Version_Length
        and then S (S'First .. S'First + Version_Prefix'Length - 1)
                 = Version_Prefix
        and then S (S'First + Version_Prefix'Length + 2) = "."
        and then S
                   (S'First
                    + Version_Prefix'Length
                    .. S'First + Version_Prefix'Length + 1)
                 >= "00"
        and then S
                   (S'First
                    + Version_Prefix'Length
                    + 3
                    .. S'SFirst + Version_Prefix'Length + 4)
                 >= "00";
   end Has_Version;

   -----------------
   -- Get_Version --
   -----------------

   function Get_Version (S : BWString) return Version_Type is
      V         : Version_Type := (Major => 0, Minor => 0, Patch => 0);
      From      : Positive := Version_Prefix'Length + 1;
      Pos       : Natural;
      Next_From : Positive;
   begin
      --  Major
      Pos := S.Index (".", From);
      if Pos > 0 then
         V.Major := Natural'Value (S (From .. Pos - 1));
         Next_From := Pos + 1;

         --  Minor
         Pos := S.Index (".", Next_From);
         if Pos > 0 then
            V.Minor := Natural'Value (S (Next_From .. Pos - 1));
            From := Pos + 1;

            --  Patch
            V.Patch := Natural'Value (S (From .. S'Last));
         end if;
      end if;

      return V;
   end Get_Version;

end Hilbert.Version;
