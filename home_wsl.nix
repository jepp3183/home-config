{ inputs, pkgs, ... }:
{
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  home.username = "jeppe-wsl";
  home.homeDirectory = "/home/jeppe-wsl";
  home.packages = with pkgs; [
    # CMD UTILS
    wl-clipboard
    wireguard-tools
    ansible
    claude-code
  ];

  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./configs/common.nix
    ./configs/fish.nix
    ./configs/neovim
    ./configs/yazi.nix
    ./configs/zellij.nix
  ];

  # https://tinted-theming.github.io/tinted-gallery/
  colorScheme = inputs.nix-colors.colorSchemes.gigavolt;

  fonts.fontconfig.enable = true;
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      user = {
        name = "Jeppe Allerslev";
        email = "jeppeallerslev@gmail.com";
      };
    };
  };

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
