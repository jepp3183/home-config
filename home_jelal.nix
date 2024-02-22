{inputs, config, pkgs, ...}:
let
  nix-colors-lib = inputs.nix-colors.lib.contrib { inherit pkgs; };
in
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
    atool
    unzip
    zip

    (nerdfonts.override { fonts = [ "FiraCode" "Meslo" ]; })
  ];

  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./configs/fish.nix
    ./configs/lf.nix
    ./configs/neovim
  ];

  colorScheme = inputs.nix-colors.colorSchemes.tokyodark;

  fonts.fontconfig.enable = true;

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
