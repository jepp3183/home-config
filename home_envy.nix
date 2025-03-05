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
    ark
    parsec-bin
    qpdfview
    zed-editor
    inputs.zen-browser.packages."${system}".default
    inputs.ghostty.packages."${system}".default
    zotero

    # CMD UTILS
    wl-clipboard
    wireguard-tools
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
  ];

  # https://tinted-theming.github.io/tinted-gallery/
  # colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;
  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;
  # colorScheme = nix-colors-lib.colorSchemeFromPicture {
  #   path = ./files/dune.jpg;
  #   kind = "dark";
  # };

  fonts.fontconfig.enable = true;

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "default-web-browser"           = "zen.desktop" ;
    "text/html"                     = "zen.desktop" ;
    "x-scheme-handler/http"         = "zen.desktop" ;
    "x-scheme-handler/https"        = "zen.desktop" ;
    "x-scheme-handler/about"        = "zen.desktop" ;
    "x-scheme-handler/unknown"      = "zen.desktop" ;
    "application/pdf" = "org.pwmt.zathura.desktop";
    "image/jpeg" = "qimgv.desktop";
    "image/png" = "qimgv.desktop";
    "image/gif" = "qimgv.desktop";
  };
  
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
