{pkgs, ...}:
{
  programs.fish = {
    enable = true;
    plugins = [
      { name = "hydro-prompt"; src = pkgs.fishPlugins.hydro.src; }
    ];
    shellAliases = {
      gs = "${pkgs.git }/bin/git status";
      gg = "${pkgs.lazygit}/bin/lazygit";
      cat = "${pkgs.bat}/bin/bat";
      man = "${pkgs.bat-extras.batman}/bin/batman";
      ls = "${pkgs.eza}/bin/eza";
      s = "kitten ssh";
      lg = "${pkgs.lazygit}/bin/lazygit";
    };
    interactiveShellInit = ''
      set fish_greeting

      bind \ck up-or-search

      function ns; nix-shell --run fish -p $argv; end
    '';
  };
}
