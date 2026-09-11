{ inputs, pkgs, ... }:
{

  nixpkgs.config = {
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };

  home.username = "jeppe";
  home.homeDirectory = "/home/jeppe";
  home.packages = with pkgs; [
    # GUI Packages
    brave
    spotify
    obsidian
    discord
    vlc
    qimgv
    insync
    fuzzel
    vscode
    parsec-bin
    qpdfview
    zed-editor
    zotero
    freecad # disabled: pdal 2.9.3 and vtk 9.5.2 fail to build with GCC 15 + gdal 3.13 in nixpkgs unstable

    # CMD UTILS
    wl-clipboard
    ansible
    claude-code
    cliphist

    # PYTHON
    (python3.withPackages (
      ps: with ps; [
        numpy
        matplotlib
        ipython
      ]
    ))
  ];

  imports = [
    inputs.nix-colors.homeManagerModules.default
    inputs.plasma-manager.homeModules.plasma-manager
    inputs.nix-index-database.homeModules.default
    ./configs/firefox.nix
    ./configs/options.nix
    ./configs/colorscheme.nix
    ./configs/common.nix
    ./configs/git.nix
    ./configs/fish.nix
    ./configs/kitty.nix
    ./configs/zathura.nix
    ./configs/fuzzel.nix
    ./configs/neovim
    ./configs/vscode.nix
    ./configs/yazi.nix
    ./configs/zellij.nix
    ./configs/posting.nix
    ./configs/streamdeck_ui.nix
    ./configs/bambu_studio.nix
    ./configs/thunderbird.nix
  ];

  programs.nix-index-database.comma.enable = true;


  fonts.fontconfig.enable = true;

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "application/pdf" = "org.pwmt.zathura.desktop";
    "image/jpeg" = "qimgv.desktop";
    "image/png" = "qimgv.desktop";
    "image/gif" = "qimgv.desktop";
    "video/mp4" = "vlc.desktop";
    "video/x-matroska" = "vlc.desktop";
    "video/webm" = "vlc.desktop";
    "video/vnd.avi" = "vlc.desktop";
    "video/quicktime" = "vlc.desktop";
    "video/x-msvideo" = "vlc.desktop";
    "video/mpeg" = "vlc.desktop";
  };

  services.kdeconnect.enable = true;

  systemd.user.services.cliphist-text = {
    Unit = {
      Description = "cliphist text clipboard watcher";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      StartLimitIntervalSec = 0;
    };
    Service = {
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  systemd.user.services.cliphist-image = {
    Unit = {
      Description = "cliphist image clipboard watcher";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      StartLimitIntervalSec = 0;
    };
    Service = {
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = [ "graphical-session.target" ];
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

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
