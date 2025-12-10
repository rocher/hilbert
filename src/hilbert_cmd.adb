with Hilbert.CLI;

--  with Hilbert.Unit_Test;

-----------------
-- Hilbert_CMD --
-----------------

procedure Hilbert_CMD is
begin

   Hilbert.CLI.Initialize;
   Hilbert.CLI.Execute;

   --  Hilbert.Unit_Test.All_Unit_Tests;

end Hilbert_CMD;
