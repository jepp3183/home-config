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

  xdg.configFile = {
    "autostart/insync.desktop".text = ''
      [Desktop Entry]
      Version=1.0
      Type=Application
      Name=Insync
      GenericName=Insync
      Comment=Launch Insync
      Icon=insync
      Categories=Network;
      Exec=insync start --no-daemon
      TryExec=insync
      Terminal=false
      X-GNOME-Autostart-Delay=3
    '';

    "autostart/org.kde.kdeconnect.app.desktop".text = ''
      [Desktop Entry]
      Categories=Qt;KDE;Network
      Comment=Make all your devices one
      Exec=kdeconnectd
      GenericName=Device Synchronization
      Icon=kdeconnect
      Name=KDE Connect
      Terminal=false
      Type=Application
    '';

    "autostart/streamdeck-ui.desktop".text = ''
      [Desktop Entry]
      Categories=Utility
      Comment=UI for the Elgato Stream Deck
      Exec=streamdeck -n
      Icon=streamdeck-ui
      Name=Stream Deck UI
      Type=Application
      Version=1.5
    '';
  };
}
