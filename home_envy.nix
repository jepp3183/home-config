{inputs, pkgs, ...}:
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
    zotero
    multiviewer-for-f1
    gimp
    freecad

    # CMD UTILS
    wl-clipboard
    ansible
    claude-code

    # PYTHON
    (python3.withPackages(ps: with ps; [ 
      numpy
      matplotlib
      ipython
    ]))
  ];

  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./configs/zen.nix
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
    ./configs/bambu_studio.nix
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
  colorScheme = inputs.nix-colors.colorSchemes.onedark;
  
  # Wallpaper path that can be used by other modules
  custom.wallpaper = ./files/lake.jpeg;

  fonts.fontconfig.enable = true;

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "application/pdf" = "org.pwmt.zathura.desktop";
    "image/jpeg" = "qimgv.desktop";
    "image/png" = "qimgv.desktop";
    "image/gif" = "qimgv.desktop";
  };
  
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
