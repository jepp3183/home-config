{ inputs, pkgs, ... }:
{
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };

  home.username = "jeppe";
  home.homeDirectory = "/home/jeppe";
  home.packages = with pkgs; [
    # CMD UTILS
    wl-clipboard
    awscli2
  ];

  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./configs/common.nix
    ./configs/fish.nix
    ./configs/yazi.nix
    ./configs/neovim
    ./configs/kitty.nix
    ./configs/vscode.nix
    ./configs/zellij.nix
    ./configs/posting.nix
  ];

  programs.fish.interactiveShellInit = ''
    source ~/.asdf/asdf.fish
  '';

  programs.git = {
    enable = true;
    userName = "Jeppe Allerslev";
    userEmail = "jeppe.allerslev@qarmainspect.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  # https://tinted-theming.github.io/tinted-gallery/
  colorScheme = inputs.nix-colors.colorSchemes.ayu-mirage;

  fonts.fontconfig.enable = true;

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
