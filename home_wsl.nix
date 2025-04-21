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
    ansible
  ];

  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./configs/common.nix
    ./configs/fish.nix
    ./configs/neovim
    ./configs/yazi.nix
    ./configs/zellij.nix
  ];

  colorScheme = inputs.nix-colors.colorSchemes.gigavolt;
  # colorScheme = nix-colors-lib.colorSchemeFromPicture {
  #   path = ./files/lake.jpeg;
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
