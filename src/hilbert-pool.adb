package body Hilbert.Pool is

   procedure Read (Self : out Object; File : in out Ada.Text_IO.File_Type) is
      New_Item : Item.Object;
   begin
      loop
         exit when Ada.Text_IO.End_Of_File (File);
         New_Item.Read (File);
         Self.Append (New_Item);
      end loop;
   end Read;

   procedure Put_Image_Pool
     (Output : in out Ada.Strings.Text_Buffers.Root_Buffer_Type'Class;
      Self   : Object) is
   begin
      for Item of Self loop
         Output.Put (Item'Image);
         if Item /= Self.Last_Element then
            Output.New_Line;
            Output.New_Line;
         end if;
      end loop;
   end Put_Image_Pool;

end Hilbert.Pool;
