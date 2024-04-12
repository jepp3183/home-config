{inputs, config, pkgs, ...}:
let
  nix-colors-lib = inputs.nix-colors.lib.contrib { inherit pkgs; };
in
{

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };

  home.username = "jeppe";
  home.homeDirectory = "/home/jeppe";
  home.packages = with pkgs; [
    # GUI Packages
    firefox
    spotify
    obsidian
    discord
    vlc
    qimgv
    insync
    fuzzel


    # CMD UTILS
    wl-clipboard
    wireguard-tools
    # sage
    typst
    ansible

    # PYTHON
    (python3.withPackages(ps: with ps; [ 
      numpy 
      matplotlib 
      pandas
      scipy
      ipykernel
      jupyter
      notebook
      pycryptodome
      scikit-learn
      networkx
      torchvision
    ]))
  ];

  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./configs/common.nix
    ./configs/git.nix
    ./configs/hypr.nix
    ./configs/fish.nix
    ./configs/kitty.nix
    ./configs/zathura.nix
    ./configs/lf.nix
    ./configs/waybar.nix
    ./configs/fuzzel.nix
    ./configs/neovim
    ./configs/vscode.nix
    ./configs/wezterm.nix
    ./configs/yazi.nix
    (import ./configs/zellij.nix {
      inherit pkgs config inputs;
      configLines = "";
     })
  ];

  colorScheme = inputs.nix-colors.colorSchemes.ayu-dark;
  # colorScheme = nix-colors-lib.colorSchemeFromPicture {
  #   path = ./walls/dune.jpg;
  #   kind = "dark";
  # };

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
