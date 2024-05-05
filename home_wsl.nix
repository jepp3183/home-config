{inputs, config, pkgs, ...}:
let
  nix-colors-lib = inputs.nix-colors.lib.contrib { inherit pkgs; };
in
{
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  home.username = "jeppe_wsl";
  home.homeDirectory = "/home/jeppe_wsl";
  home.packages = with pkgs; [
    # CMD UTILS
    wl-clipboard
    wireguard-tools
    typst
    httpie

    (nerdfonts.override { fonts = [ "FiraCode" "Meslo" "CascadiaCode" ]; })

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
    ./configs/common.nix
    ./configs/fish.nix
    ./configs/lf.nix
    ./configs/neovim
    ./configs/yazi.nix
    (import ./configs/zellij.nix {
      inherit pkgs config inputs;
      configLines = "";
     })
  ];

  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-material-dark-hard;
  # colorScheme = nix-colors-lib.colorSchemeFromPicture {
  #   path = ./walls/lake.jpeg;
  #   kind = "dark";
  # };

  fonts.fontconfig.enable = true;
  programs.git = {
    enable = true;
    userName = "Jeppe Allerslev";
    userEmail = "jeppeallerslev@gmail.com";
  };
  
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
