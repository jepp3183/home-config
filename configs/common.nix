{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
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

    difftastic = {
      enable = true;
      git = {
        enable = true;
        diffToolMode = true;
      };
    };

    lazygit = {
      enable = true;
      # lazygit 0.65 schema: `git.pagers` list (upstream master has since
      # renamed it again to `git.diffRenderers`; update when nixpkgs catches up).
      settings.git.pagers = [
        {
          colorArg = "always";
          # inline display fits lazygit's narrow diff pane; lazygit does its
          # own syntax highlighting, so skip difft's.
          externalDiffCommand = "${lib.getExe pkgs.difftastic} --color=always --display=inline --syntax-highlight=off";
        }
      ];
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
    libqalculate
    atool
    unzip
    zip
    jq
    nix-search-cli
    httpie
    lazydocker
    kubectl
    k9s
    jnv
    ripgrep-all
    tldr
    git-crypt
    codex

    nerd-fonts.fira-code
    nerd-fonts.meslo-lg
    nerd-fonts.caskaydia-cove
    nerd-fonts.jetbrains-mono
    newcomputermodern # LaTeX font
  ];
  fonts.fontconfig.enable = true;
}
