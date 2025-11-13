with Ada.Strings.UTF_Encoding;
with Ada.Text_IO;
with GNAT.OS_Lib;

with CLIC.Subcommand.Instance;
with CLIC.TTY;
with Simple_Logging;

with Hilbert_Config;

package body Hilbert.CLI is

   package Conf renames Hilbert_Config;
   package Log renames Simple_Logging;

   use all type Conf.Build_Profile_Kind;

   type Global_Switches_Type is record
      Help     : aliased Boolean := False;
      No_Color : aliased Boolean := False;
      No_TTY   : aliased Boolean := False;
      Verbose  : aliased Boolean := False; --  show command activity
      Version  : aliased Boolean := False; --  show version information
      Debug    : aliased Boolean := False; --  show program details
   end record;

   Global_Switch : Global_Switches_Type;

   procedure Set_Global_Switches
     (Config : in out CLIC.Subcommand.Switches_Configuration);

   -----------------
   -- TTY_Chapter --
   -----------------

   function TTY_Chapter
     (Text : Ada.Strings.UTF_Encoding.UTF_8_String := "")
      return Ada.Strings.UTF_Encoding.UTF_8_String
   is (CLIC.TTY.Bold (Text));
   --  Do no prepend Emph ("🛈") character to Text

   package CLI_Command is new
     CLIC.Subcommand.Instance
       (Main_Command_Name   => Conf.Crate_Name,
        Version             => Conf.Crate_Version,
        Set_Global_Switches => Set_Global_Switches,
        Put                 => Ada.Text_IO.Put,
        Put_Line            => Ada.Text_IO.Put_Line,
        Put_Error           => Ada.Text_IO.Put_Line,
        Error_Exit          => GNAT.OS_Lib.OS_Exit,
        TTY_Chapter         => TTY_Chapter,
        TTY_Description     => CLIC.TTY.Description,
        TTY_Version         => CLIC.TTY.Version,
        TTY_Underline       => CLIC.TTY.Underline,
        TTY_Emph            => CLIC.TTY.Emph);

   -------------------------
   -- Set_Global_Switches --
   -------------------------

   procedure Set_Global_Switches
     (Config : in out CLIC.Subcommand.Switches_Configuration) is
   begin
      --!pp off
      CLIC.Subcommand.Define_Switch (
         Config,
         Global_Switch.Help'Access,
         "-h", "--help",
         "Display command help");

      CLIC.Subcommand.Define_Switch (
         Config,
         Global_Switch.No_Color'Access,
         Long_Switch => "--no-color",
         Help        => "Disable color");

      CLIC.Subcommand.Define_Switch (
         Config,
         Global_Switch.No_TTY'Access,
         Long_Switch => "--no-tty",
         Help        => "Disable control characters");

      CLIC.Subcommand.Define_Switch (
         Config,
         Global_Switch.Verbose'Access,
         Switch      => "-v",
         Long_Switch => "--verbose",
         Help        => "Show command activity");

      CLIC.Subcommand.Define_Switch (
         Config,
         Global_Switch.Version'Access,
         Switch      => "-V",
         Long_Switch => "--version",
         Help        => "Display version information");

      pragma Warnings (Off);
      if Conf.Build_Profile = Conf.development then
         CLIC.Subcommand.Define_Switch (
            Config,
            Global_Switch.Debug'Access,
            Switch      => "-D",
            Long_Switch => "--debug",
            Help        => "Show debug information");
      end if;
      pragma Warnings (On);
      --!pp on
   end Set_Global_Switches;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      null;
   end Initialize;

   -------------
   -- Execute --
   -------------

   procedure Execute is
   begin
      CLI_Command.Parse_Global_Switches;

      Log.Level := Log.Info;
      if Global_Switch.Verbose then
         Log.Level := Log.Detail;
      end if;
      if Global_Switch.Debug then
         Log.Level := Log.Debug;
      end if;
      Log.Debug ("Global_Switch" & Global_Switch'Image);

      if not Global_Switch.No_TTY then
         CLIC.TTY.Force_Disable_TTY;
         Log.Debug ("disable TTY");
      end if;

      if Global_Switch.No_Color and then Global_Switch.No_TTY then
         CLIC.TTY.Enable_Color (Force => True);
         Log.Debug ("disable Color");
      end if;

      CLI_Command.Execute;
   end Execute;

end Hilbert.CLI;
