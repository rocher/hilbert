with GNAT.OS_Lib;

with CLIC.Subcommand; use CLIC.Subcommand;
with Simple_Logging;

with Hilbert.Constants; use Hilbert.Constants;
with Hilbert.Item;
with Hilbert.Pool;      use Hilbert.Pool;
with Hilbert.Types;     use Hilbert.Types;

package body Hilbert.CLI.Info is

   package Log renames Simple_Logging;

   --------------------
   -- Setup_Switches --
   --------------------

   overriding
   procedure Setup_Switches
     (Cmd    : in out Cmd_Type;
      Config : in out CLIC.Subcommand.Switches_Configuration) is
   begin
      null;
   end Setup_Switches;

   ---------------
   -- Pool_Info --
   ---------------

   procedure Pool_Info (FileName : String) is
      use all type Hilbert.Item.Item_Map_Package.Cursor;
      Pool     : Pool_Type;
      Group    : Hilbert.Item.Item_Map_Package.Cursor;
      N_Groups : Natural := 0;
      Σ_Groups : Natural := 0;
   begin
      Log.Info ("Reading pool " & FileName);
      Read (Pool, FileName);
      Log.Info
        ("Pool '"
         & To_String (Pool.Name)
         & "' contains "
         & Natural'Image (Pool.Num_Items)
         & " items");
      Group := Pool.Groups.First;
      loop
         exit when Group = Hilbert.Item.Item_Map_Package.No_Element;
         Log.Info
           ("  group '"
            & To_String (Hilbert.Item.Item_Map_Package.Key (Group))
            & "' contains "
            & Natural'Image (Natural (Pool.Groups.Reference (Group).Length))
            & " items");
         N_Groups := N_Groups + 1;
         Σ_Groups := @ + Natural (Pool.Groups.Reference (Group).Length);
         Group := Group.Next;
      end loop;
      Log.Info
        ("  Total items in"
         & N_Groups'Image
         & " groups: "
         & Natural'Image (Σ_Groups));
   end Pool_Info;

   -------------
   -- Execute --
   -------------

   overriding
   procedure Execute (Cmd : in out Cmd_Type; Args : AAA.Strings.Vector) is
      Arg_Num : constant Natural := Natural (Args.Length);
   begin
      Log.Debug ("Cmd.Settings = " & Cmd'Image);
      Log.Debug ("Args = " & Args'Image);
      for I in Args.First_Index .. Args.Last_Index loop
         Log.Debug ("Args(" & I'Image & ") = " & Args.Element (I));
      end loop;
      Log.Debug ("Arg_Num =" & Arg_Num'Image);

      if Arg_Num < 1 then
         Log.Error ("Filename is missing.");
         GNAT.OS_Lib.OS_Exit (1);
      elsif Arg_Num > 1 then
         Log.Error ("Too many arguments.");
         GNAT.OS_Lib.OS_Exit (1);
      end if;

      Name : constant String := Args.Element (Args.First_Index);
      if not (Is_Pool_Name (Name) or else Is_Pool_Filename (Name)) then
         Log.Error ("Invalid pool " & Name);
         GNAT.OS_Lib.OS_Exit (1);
      end if;

      Filename : constant String :=
        (if Is_Pool_Filename (Name) then Name else Name & Pool_Suffix);
      Pool_Info (Filename);

   end Execute;

end Hilbert.CLI.Info;
