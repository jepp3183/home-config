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
    # freecad  # disabled: pdal 2.9.3 and vtk 9.5.2 fail to build with GCC 15 + gdal 3.13 in nixpkgs unstable

    # CMD UTILS
    wl-clipboard
    ansible
    claude-code

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
    ./configs/plasma.nix
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
    ./configs/niri.nix
    ./configs/noctalia.nix
  ];

  programs.nix-index-database.comma.enable = true;


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
