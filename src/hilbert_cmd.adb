with Hilbert.Pool;
--  with Hilbert.Random;
with Hilbert.CLI;

-----------------
-- Hilbert_CMD --
-----------------

procedure Hilbert_CMD is

   Pool : Hilbert.Pool.Object;

begin

   --  Hilbert.Random.Initialize (3221);

   Pool.Read ("SMX1_MUN_RA8");
   Pool.Make_Exams (Name => "202511", Num_Exams => 67, Num_Items => 34);

   Hilbert.CLI.Initialize;
   Hilbert.CLI.Execute;

end Hilbert_CMD;
