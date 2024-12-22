{inputs, config, pkgs, ...}:
# let
#   nix-colors-lib = inputs.nix-colors.lib.contrib { inherit pkgs; };
# in
{
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  home.username = "jelal";
  home.homeDirectory = "/home/jelal";
  home.packages = with pkgs; [
    # CMD UTILS
    wl-clipboard
  ];

  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./configs/common.nix
    ./configs/fish.nix
    ./configs/yazi.nix
    ./configs/neovim
    ./configs/zellij.nix
  ];

  programs.fish.shellAliases = {
    jump = ''ssh ssejejal@jump01.curasaas.netic.dk'';
  };

  colorScheme = inputs.nix-colors.colorSchemes.ayu-dark;

  fonts.fontconfig.enable = true;

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
