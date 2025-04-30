{inputs, config, pkgs, ...}:
let
  nix-colors-lib = inputs.nix-colors.lib.contrib { inherit pkgs; };
in
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
    firefox
    zotero
    multiviewer-for-f1
    keymapp
    streamdeck-ui

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
  ];

  wayland.windowManager.hyprland = {
    settings = {
        exec = [
          "xrandr --output DP-3 --primary"
        ];
        exec-once = [
          "streamdeck -n"
        ];
        monitor = [
          "DP-3, highrr, 0x0, 1"
          "HDMI-A-1, preferred, 2560x100, 1"
        ];
        bind = [
          "$mainMod, code:51, togglespecialworkspace, discord"
        ];
    };
  };

  # https://tinted-theming.github.io/tinted-gallery/
  # colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;
  colorScheme = inputs.nix-colors.colorSchemes.onedark;
  # colorScheme = nix-colors-lib.colorSchemeFromPicture {
  #   path = ./files/dune.jpg;
  #   kind = "dark";
  # };

  fonts.fontconfig.enable = true;

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "default-web-browser"           = "firefox.desktop" ;
    "text/html"                     = "firefox.desktop" ;
    "x-scheme-handler/http"         = "firefox.desktop" ;
    "x-scheme-handler/https"        = "firefox.desktop" ;
    "x-scheme-handler/about"        = "firefox.desktop" ;
    "x-scheme-handler/unknown"      = "firefox.desktop" ;
    "application/pdf" = "org.pwmt.zathura.desktop";
    "image/jpeg" = "qimgv.desktop";
    "image/png" = "qimgv.desktop";
    "image/gif" = "qimgv.desktop";
  };
  
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
