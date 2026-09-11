{
  inputs,
  pkgs,
  secrets,
  ...
}:
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
  ];

  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./configs/colorscheme.nix
    ./configs/common.nix
    ./configs/fish.nix
    ./configs/neovim
    ./configs/yazi.nix
    ./configs/zellij.nix
  ];

  fonts.fontconfig.enable = true;

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
