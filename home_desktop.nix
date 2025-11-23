{inputs, pkgs, ...}:
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
    multiviewer-for-f1
    streamdeck-ui
    freecad

    # CMD UTILS
    wl-clipboard
    ansible

    # PYTHON
    (python3.withPackages(ps: with ps; [ 
      numpy
      matplotlib
      ipython
    ]))
  ];

  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./configs/options.nix
    ./configs/common.nix
    ./configs/git.nix
    ./configs/hypr/hypr.nix
    ./configs/fish.nix
    ./configs/kitty.nix
    ./configs/zathura.nix
    ./configs/waybar.nix
    ./configs/fuzzel.nix
    ./configs/neovim
    ./configs/vscode.nix
    ./configs/yazi.nix
    ./configs/zellij.nix
    ./configs/posting.nix
    ./configs/streamdeck_ui.nix
    ./configs/swaync.nix
    ./configs/bambu_studio.nix
  ];

  wayland.windowManager.hyprland = {
    settings = {
        exec = [
          "xrandr --output DP-3 --primary"
          "hyprctl dispatch workspace 1"
        ];
        exec-once = [
          "streamdeck -n"
        ];
        monitor = [
          "DP-3, highrr, 0x0, 1"
          "HDMI-A-1, preferred, 2560x100, 1"
        ];
        workspace = [
          "name:1, monitor:DP-3"
        ];
        bind = [
          "$mainMod, code:51, togglespecialworkspace, discord"
        ];
    };
  };

  # https://tinted-theming.github.io/tinted-gallery/
  colorScheme = inputs.nix-colors.colorSchemes.onedark;
  
  # Wallpaper path that can be used by other modules
  custom.wallpaper = ./files/dune.jpg;

  fonts.fontconfig.enable = true;

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "application/pdf" = "org.pwmt.zathura.desktop";
    "image/jpeg" = "qimgv.desktop";
    "image/png" = "qimgv.desktop";
    "image/gif" = "qimgv.desktop";
    "inode/directory" = "org.kde.dolphin.desktop";
  };
  
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
