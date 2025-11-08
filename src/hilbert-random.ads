with Ada.Numerics.Discrete_Random;

package Hilbert.Random is

   type Random_Range is range 1 .. 1_000_000;
   package Seed is new Ada.Numerics.Discrete_Random (Random_Range);

   procedure Initialize (Initiator : Integer := 123_456_789);

   function Random_Index (High : Positive) return Positive
   with Pre => High > 1, Post => Random_Index'Result in 1 .. High;

private

   Gen : Seed.Generator;

end Hilbert.Random;
