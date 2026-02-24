with Ada.Strings.UTF_Encoding;
with Ada.Text_IO;
with GNAT.OS_Lib;

with CLIC.Subcommand.Instance;
with CLIC.TTY;
with Simple_Logging;

with Hilbert_Config;
with Hilbert.CLI.Generate; use Hilbert.CLI.Generate;
with Hilbert.CLI.Grade;    use Hilbert.CLI.Grade;
with Hilbert.CLI.Info;     use Hilbert.CLI.Info;

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
     (Config : in out CLIC.Subcommand.Switches_Configuration)
   is
      use CLIC.Subcommand;
   begin
      --!pp off
      Define_Switch (
         Config,
         Global_Switch.Help'Access,
         "-h", "--help",
         "Display command help");

      Define_Switch (
         Config,
         Global_Switch.No_Color'Access,
         Long_Switch => "--no-color",
         Help        => "Disable color",
         Value       => False);

      Define_Switch (
         Config,
         Global_Switch.No_TTY'Access,
         Long_Switch => "--no-tty",
         Help        => "Disable control characters",
         Value       => False);

      Define_Switch (
         Config,
         Global_Switch.Verbose'Access,
         Switch      => "-v",
         Long_Switch => "--verbose",
         Help        => "Show command activity",
         Value       => True);

      Define_Switch (
         Config,
         Global_Switch.Version'Access,
         Long_Switch => "--version",
         Help        => "Display version information",
         Value       => True);

      pragma Warnings (Off);
      if Conf.Build_Profile = Conf.development then
         Define_Switch (
            Config,
            Global_Switch.Debug'Access,
            Switch      => "-d",
            Long_Switch => "--debug",
            Help        => "Show debug information",
            Value       => True);
      end if;
      pragma Warnings (On);
      --!pp on
   end Set_Global_Switches;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      CLI_Command.Register ("Generation", new Generate.Cmd_Type);
      CLI_Command.Register ("Generation", new Info.Cmd_Type);
      CLI_Command.Register ("Grading", new Grade.Cmd_Type);
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
         CLIC.TTY.Enable_Color (Force => False);
         Log.Debug ("disable Color");
      end if;

      CLI_Command.Execute;
   end Execute;

end Hilbert.CLI;
