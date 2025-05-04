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
    ./configs/swaync.nix
  ];
  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        "eDP-1,1920x1080@60.033001,auto,1"
        "desc:Acer Technologies XF270HU T78EE0048521, highrr, auto-up, 1"
        "desc:Seiko Epson Corporation EPSON PJ 0x0101010, 1920x1200@59.95Hz, auto-up, 1"
        ", preferred, auto-up, 1"
      ];

      device = {
        name = "syna32a0:00-06cb:ce14-touchpad";
        sensitivity = 0.4;
      };
    };
  };

  # https://tinted-theming.github.io/tinted-gallery/
  # colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;
  colorScheme = inputs.nix-colors.colorSchemes.onedark;
  # colorScheme = nix-colors-lib.colorSchemeFromPicture {
  #   path = ./files/dune.jpg;
  #   kind = "dark";
  # };
  
  # Wallpaper path that can be used by other modules
  custom.wallpaper = ./files/lake.jpeg;

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
