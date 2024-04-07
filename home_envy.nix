{inputs, config, pkgs, ...}:
let
  nix-colors-lib = inputs.nix-colors.lib.contrib { inherit pkgs; };
in
{

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
    permittedInsecurePackages = with pkgs; [
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

    # CMD UTILS
    wl-clipboard
    fd
    ripgrep
    eza
    bat
    bat-extras.batman
    btop
    fzf
    gdu
    lazygit
    libqalculate
    nushell
    rclone
    wireguard-tools
    rofi
    # sage
    atool
    unzip
    zip
    jq
    jid

    (nerdfonts.override { fonts = [ "FiraCode" "Meslo" "CascadiaCode" ]; })


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
    ]))
  ];

  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./configs/hypr.nix
    ./configs/fish.nix
    ./configs/kitty.nix
    ./configs/zathura.nix
    ./configs/lf.nix
    ./configs/waybar.nix
    # ./configs/sioyek.nix
    ./configs/rofi.nix
    ./configs/neovim
    ./configs/vscode.nix
    # ./configs/zellij.nix
    (import ./configs/zellij.nix {
      inherit pkgs config inputs;
      configLines = "";
     })
  ];

  colorScheme = inputs.nix-colors.colorSchemes.ayu-dark;
  # colorScheme = nix-colors-lib.colorSchemeFromPicture {
  #   path = ./walls/lake.jpeg;
  #   kind = "dark";
  # };

  fonts.fontconfig.enable = true;

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    # "application/pdf" = "sioyek.desktop";
    "application/pdf" = "org.pwmt.zathura.desktop";
    "image/jpeg" = "qimgv.desktop";
    "image/png" = "qimgv.desktop";
    "image/gif" = "qimgv.desktop";
  };

  programs.git = {
    enable = true;
    userName = "Jeppe Allerslev";
    userEmail = "jeppeallerslev@gmail.com";
  };
  
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
