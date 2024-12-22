{inputs, config, pkgs, ...}:
{

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
  };

  home.packages = with pkgs; [
    # CMD UTILS
    fd
    ripgrep
    eza
    bat
    bat-extras.batman
    btop
    htop
    fzf
    gdu
    lazygit
    libqalculate
    atool
    unzip
    zip
    jq
    nix-search-cli
    httpie

    nerd-fonts.fira-code
    nerd-fonts.meslo-lg
    nerd-fonts.caskaydia-cove
  ];
  fonts.fontconfig.enable = true;
}
