with Hilbert.Pool;
with Hilbert.Random;

with Ada.Text_IO;

procedure Hilbert_CLI is

   Pool     : Hilbert.Pool.Object;
   In_File  : Ada.Text_IO.File_Type;
   Out_File : Ada.Text_IO.File_Type;
begin
   Hilbert.Random.Initialize (3221);

   In_File.Open (Name => "pool.txt", Mode => Ada.Text_IO.In_File);
   Pool.Read (In_File);
   --  Ada.Text_IO.Put_Line (Pool'Image);
   In_File.Close;

   Out_File.Create (Name => "exam.txt", Mode => Ada.Text_IO.Out_File);
   --  Out_File.Open (Name => "exam.txt", Mode => Ada.Text_IO.Out_File);
   Pool.Make_Exams (Num_Exams => 1, Num_Items => 2, Out_File => Out_File);
   --  Out_File.Put_Line (Pool'Image);
   Out_File.Close;

end Hilbert_CLI;
