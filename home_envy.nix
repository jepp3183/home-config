{inputs, config, pkgs, ...}:
let
  nix-colors-lib = inputs.nix-colors.lib.contrib { inherit pkgs; };

  bambu-studio-appimage = pkgs.appimageTools.wrapType2 rec {
    name = "BambuStudio";
    pname = "bambustudio";
    version = "02.00.01.50";
    src = pkgs.fetchurl {
      url = "https://github.com/bambulab/BambuStudio/releases/download/v${version}/Bambu_Studio_ubuntu-24.04_v${version}.AppImage";
      sha256 = "sha256-wB14wr3akLPmi5jVqiVFkGGHVjZeR6BeAYgvdGuhsSw=";
    };
    profile = ''
      export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      export GIO_MODULE_DIR="${pkgs.glib-networking}/lib/gio/modules/"
    '';
    extraPkgs = pkgs: with pkgs; [
      cacert
      curl
      glib
      glib-networking
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      webkitgtk_4_1
    ];
  };
in
{

  nixpkgs.config = {
    permittedInsecurePackages = [
      "electron-25.9.0"
      "libsoup-2.74.3"
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
    gimp
    freecad

    # 3D PRINTING
    bambu-studio-appimage

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
        "desc:Acer Technologies XF270HU T78EE0048521, 2560x1440@144.01Hz, auto-right, 1"
        ", preferred, auto-up, 1"
      ];

      env = [
        "GSK_RENDERER,ngl" 
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
