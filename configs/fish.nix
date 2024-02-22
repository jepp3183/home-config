{pkgs, ...}:
{
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [
      "--cmd cd"
    ];
  };
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

      function lfd --wraps="lf" --description="lf - Terminal file manager (changing directory on exit)"
        cd "(command lf -print-last-dir $argv)"
      end
    '';
  };
}
