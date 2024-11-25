{inputs, config, pkgs, ...}:
let
  nix-colors-lib = inputs.nix-colors.lib.contrib { inherit pkgs; };
in
{
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
    permittedInsecurePackages = [
      "electron-25.9.0"
    ];
  };

  home.username = "jeppe_qarma";
  home.homeDirectory = "/home/jeppe_qarma";
  home.packages = with pkgs; [
    # GUI Packages
    brave
    inputs.zen-browser.packages."${system}".specific
    spotify
    vscode
    zed-editor
    ark

    # CMD UTILS
    wl-clipboard

    # PYTHON
    (python3.withPackages(ps: with ps; [ 
      numpy
      matplotlib
      ipython
    ]))
  ];

  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./configs/common.nix
    ./configs/fish.nix
    ./configs/yazi.nix
    ./configs/neovim
    ./configs/kitty.nix
    ./configs/vscode.nix
  ];

  programs.git = {
    enable = true;
    userName = "Jeppe Allerslev";
    userEmail = "jeppe.allerslev@qarmainspect.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  colorScheme = inputs.nix-colors.colorSchemes.ayu-mirage;

  fonts.fontconfig.enable = true;

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
