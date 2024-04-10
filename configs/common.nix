{inputs, config, pkgs, ...}:
{
  home.packages = with pkgs; [
    # CMD UTILS
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
    jq
    jid

    (nerdfonts.override { fonts = [ "FiraCode" "Meslo" "CascadiaCode" ]; })
  ];
  fonts.fontconfig.enable = true;
}
