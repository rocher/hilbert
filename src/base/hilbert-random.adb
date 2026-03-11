package body Hilbert.Random is

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Initiator : Integer) is
   begin
      Gen.Reset (Initiator);
   end Initialize;

   ------------------
   -- Random_Index --
   ------------------

   function Random_Index (High : Positive) return Positive is
   begin
      return 1 + Positive (Seed.Random (Gen)) mod High;
   end Random_Index;

end Hilbert.Random;
