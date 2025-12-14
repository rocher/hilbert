with Ada.Text_IO;
with GNAT.OS_Lib;

with Simple_Logging;

with Hilbert.CLI;

--  with Hilbert.Unit_Test;

-----------------
-- Hilbert_CMD --
-----------------

procedure Hilbert_CMD is

   package Log renames Simple_Logging;

begin

   Hilbert.CLI.Initialize;
   Hilbert.CLI.Execute;

--  Hilbert.Unit_Test.All_Unit_Tests;

exception
   when E : others =>
      Ada.Text_IO.New_Line;
      Log.Error (E.Exception_Message);
      Ada.Text_IO.New_Line;
      GNAT.OS_Lib.OS_Exit (Status => 1);

end Hilbert_CMD;
