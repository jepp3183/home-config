{ ... }:
{
  programs.plasma = {
    enable = true;

    input.keyboard = {
      layouts = [
        { layout = "us"; }
        { layout = "dk"; }
      ];
      repeatDelay = 250;
      repeatRate = 40;
    };

    hotkeys.commands = {
      kitty = {
        name = "Launch kitty";
        key = "Meta+Return";
        command = "kitty";
      };
      firefox = {
        name = "Firefox";
        key = "Meta+B";
        command = "firefox";
      };
    };

    shortcuts = {
      kwin = {
        "Window Maximize" = [
          "Meta+F"
          "Meta+PgUp"
        ];
        "Window Close" = [
          "Alt+F4"
          "Meta+Q"
        ];
      };

      # Defaults removed:
      org_kde_powerdevil.powerProfile = ["Battery"];
      plasmashell."manage activities" = [ ];
    };

    configFile = {
      kxkbrc.Layout.Options = "grp:win_space_toggle,caps:ctrl_modifier";
    };
  };
}
