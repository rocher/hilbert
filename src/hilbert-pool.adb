with Ada.Numerics.Discrete_Random;

package body Hilbert.Pool is

   ----------
   -- Read --
   ----------

   procedure Read (Self : out Object; File : in out Ada.Text_IO.File_Type) is
      New_Item : Item.Object;
   begin
      loop
         exit when Ada.Text_IO.End_Of_File (File);
         New_Item.Read (File);
         Self.Append (New_Item);
      end loop;
   end Read;

   ----------------
   -- Make_Exams --
   ----------------

   procedure Make_Exams
     (Self           : Object;
      Num_Exams      : Positive;
      Items_Per_Exam : Positive;
      Output_File    : Ada.Text_IO.File_Type)
   is
      type Random_Range is range 1 .. 1_000_000;
      package Seed is new Ada.Numerics.Discrete_Random (Random_Range);
   begin
      if Items_Per_Exam > Positive (Self.Length) then
         raise Constraint_Error with "Not enough items in pool";
      end if;

      for Exam in 1 .. Num_Exams loop
         declare
            Origin  : Object := Self;
            Shuffle : Object;
            Index   : Positive;
            Gen     : Seed.Generator;
            Item    : Hilbert.Item.Object;
         begin
            Gen.Reset (123_456);
            for I in 1 .. Items_Per_Exam - 1 loop
               Index :=
                 Positive (Seed.Random (Gen)) mod Positive (Origin.Length) + 1;
               Item := Origin.Element (Index);
               Origin.Delete (Index);

               Item.Shuffle_Options;
               Shuffle.Append (Item, 1);
            end loop;
            Shuffle.Append (Origin.Element (1));
            Origin.Delete (1);

            if Exam < Num_Exams then
               Ada.Text_IO.New_Line (Output_File);
               Ada.Text_IO.New_Line (Output_File);
            end if;
         end;
      end loop;
   end Make_Exams;

   --------------------
   -- Put_Image_Pool --
   --------------------

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
