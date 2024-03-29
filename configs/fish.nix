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
      { name = "plugin-git"; src = pkgs.fishPlugins.plugin-git.src; }
    ];
    shellAliases = {
      gs = "${pkgs.git }/bin/git status";
      gg = "${pkgs.lazygit}/bin/lazygit";
      cat = "${pkgs.bat}/bin/bat";
      man = "${pkgs.bat-extras.batman}/bin/batman";
      ls = "${pkgs.eza}/bin/eza";
      wgu = "wg-quick up";
      wgd = "wg-quick down";
      dps = "docker ps --format=\"table {{.Names}}\t{{.Image}}\t{{.Status}}\"";
      dpsa = "docker ps -a --format=\"table {{.Names}}\t{{.Image}}\t{{.Status}}\"";
    };
    interactiveShellInit = ''
      set fish_greeting

      set -x ANSIBLE_STDOUT_CALLBACK yaml

      bind \ck up-or-search

      function ns; nix-shell --run fish -p $argv; end

      function lfd --wraps="lf" --description="lf - Terminal file manager (changing directory on exit)"
        cd "(command lf -print-last-dir $argv)"
      end
    '';
  };
}
