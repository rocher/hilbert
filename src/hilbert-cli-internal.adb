with Ada.Characters.Handling;
with GNAT.OS_Lib;

with Simple_Logging;

package body Hilbert.CLI.Internal is

   package Log renames Simple_Logging;

   ----------------
   -- Check_Date --
   ----------------

   procedure Check_Date (Date : String) is
      function Is_All_Digits (S : String) return Boolean
      is (for all C of S => Ada.Characters.Handling.Is_Digit (C));
   begin
      if Date'Length /= 6 then
         Log.Error
           ("Date must be in format YYYYMM; '"
            & Date
            & "', length"
            & Integer'Image (Date'Length)
            & ".");
         GNAT.OS_Lib.OS_Exit (1);
      end if;

      if not Is_All_Digits (Date) then
         Log.Error ("Date must be in format YYYYMM.");
         GNAT.OS_Lib.OS_Exit (1);
      end if;

      if Integer'Value (Date (Date'First .. Date'First + 3)) < 2000 then
         Log.Error ("Year in date must be 2000 or later.");
         GNAT.OS_Lib.OS_Exit (1);
      end if;

      if Integer'Value (Date (Date'First + 4 .. Date'First + 5)) < 1
        or else Integer'Value (Date (Date'First + 4 .. Date'First + 5)) > 12
      then
         Log.Error ("Month in date must be between 01 and 12.");
         GNAT.OS_Lib.OS_Exit (1);
      end if;
   end Check_Date;

end Hilbert.CLI.Internal;
