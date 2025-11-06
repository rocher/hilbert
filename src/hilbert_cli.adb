with Hilbert.Pool;

with Ada.Text_IO;

procedure Hilbert_CLI is
   Pool       : Hilbert.Pool.Object;
   Input_File : Ada.Text_IO.File_Type;
begin
   Input_File.Open (Name => "pool.txt", Mode => Ada.Text_IO.In_File);
   Pool.Read (Input_File);
   Ada.Text_IO.Put_Line (Pool'Image);
   Input_File.Close;
end Hilbert_CLI;
