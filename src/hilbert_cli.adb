with Hilbert.Pool;
with Hilbert.Random;

procedure Hilbert_CLI is

   Pool : Hilbert.Pool.Object;

begin

   Hilbert.Random.Initialize (3221);

   Pool.Read_From_File ("pool.txt");
   Pool.Make_Exams
     (Name => "DIG_RA2_202511", Num_Exams => 52, Num_Items => 32);

end Hilbert_CLI;
