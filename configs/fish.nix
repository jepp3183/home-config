{pkgs, ...}:
let
  dev_shell = pkgs.writeShellScriptBin "devshell" ''
    if [ -z "$1" ]
    then
      choice=$(ls ${../files/devshells} | ${pkgs.fzf}/bin/fzf)
      if [ -z "$choice" ]
      then
        echo "No shell chosen"
        exit 0
      fi
    else
      choice=$1.nix
    fi
    path=${../files/devshells}/$choice 

    if [ -f  $path ]
    then
      cp --no-clobber $path ./flake.nix
      chmod 644 flake.nix
    else
      echo "No such devshell: $choice"
      exit 1
    fi
  '';
in
{
  home.packages = [
    dev_shell
  ];
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
      { name = "tide"; src = pkgs.fishPlugins.tide.src; }
      { name = "plugin-git"; src = pkgs.fishPlugins.plugin-git.src; }
      { name = "fzf"; src = pkgs.fishPlugins.fzf.src; }
    ];
    shellAliases = {
      gg = "${pkgs.lazygit}/bin/lazygit";
      cat = "${pkgs.bat}/bin/bat";
      man = "${pkgs.bat-extras.batman}/bin/batman";
      ls = "${pkgs.eza}/bin/eza";
      dps = "docker ps --format=\"table {{.Names}}\t{{.Image}}\t{{.Status}}\"";
      dpsa = "docker ps -a --format=\"table {{.Names}}\t{{.Image}}\t{{.Status}}\"";
      lfd = "cd (lf -print-last-dir)";
      y = "yazi";
      ll = "eza -a --icons --git --long --group-directories-first";
      lt = "eza --icons --git --long --tree --level=2 --group-directories-first";
    };
    shellAbbrs = {
      nse = "nix-search -d";
      wgu = "wg-quick up";
      wgd = "wg-quick down";
      nv = "nvim";
      gs = "git status";
    };
    interactiveShellInit = ''
      set fish_greeting

      set -x ANSIBLE_STDOUT_CALLBACK yaml

      bind \ck up-or-search

      function ns; nix-shell --run fish -p $argv; end

      function yy
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
          cd "$cwd"
        end
        rm -f -- "$tmp"
      end
    '';
  };
}
