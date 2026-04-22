{ inputs, pkgs, secrets, ... }:
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
    inputs.nix-index-database.homeModules.default
    ./configs/common.nix
    ./configs/fish.nix
    ./configs/yazi.nix
    ./configs/neovim
    ./configs/kitty.nix
    ./configs/vscode.nix
    ./configs/zellij.nix
    ./configs/posting.nix
  ];

  programs.nix-index-database.comma.enable = true;

  programs.fish.interactiveShellInit = ''
    source ~/.asdf/asdf.fish
  '';

  programs.git = {
    enable = true;
    signing.format = null;
    settings = {
      init.defaultBranch = "main";
      user = {
        name = "Jeppe Allerslev";
        email = secrets.work_email;
      };
    };
  };

  # https://tinted-theming.github.io/tinted-gallery/
  colorScheme = inputs.nix-colors.colorSchemes.ayu-mirage;

  fonts.fontconfig.enable = true;

  myModules.neovim.elixirLsCmd = "/home/jeppe/elixir-ls/language_server.sh";

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
