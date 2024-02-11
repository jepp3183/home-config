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

    # Required for hypr and waybar to work well
    networkmanagerapplet
    dunst
    libnotify
    pavucontrol
    brightnessctl
    playerctl
    
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
    sage
    rofi
    atool
    unzip
    zip

    (nerdfonts.override { fonts = [ "FiraCode" "Meslo" ]; })


    # PYTHON
    (python3.withPackages(ps: with ps; [ 
      numpy 
      matplotlib 
      pandas
      scipy
      jupyter
      notebook
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
    ./configs/sioyek.nix
    ./configs/rofi.nix
    ./configs/neovim
    ./configs/vscode.nix
  ];

  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-material-dark-hard;
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
