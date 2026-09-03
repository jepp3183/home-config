{ pkgs, lib, ... }:
let
  dev_shell = pkgs.writeShellScriptBin "devshell" ''
    if [ -z "$1" ]
    then
      choice=$(ls ${../files/devshells} | ${lib.getExe pkgs.fzf})
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
      echo "use flake" >> .envrc
      direnv allow
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
  };
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    flags = [
      "--disable-up-arrow"
    ];
  };
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
      {
        name = "plugin-git";
        src = pkgs.fishPlugins.plugin-git.src;
      }
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf.src;
      }
    ];
    shellAliases = {
      gg = lib.getExe pkgs.lazygit;
      cat = lib.getExe pkgs.bat;
      man = lib.getExe pkgs.bat-extras.batman;
      ls = lib.getExe pkgs.eza;
      dps = "docker ps --format=\"table {{.Names}}\t{{.Image}}\t{{.Status}}\"";
      dpsa = "docker ps -a --format=\"table {{.Names}}\t{{.Image}}\t{{.Status}}\"";
      y = "yazi";
    };
    shellAbbrs = {
      nse = "nix-search -d -r";
      ns = "nix-shell --run fish -p";
      wgu = "wg-quick up";
      wgd = "wg-quick down";
      nv = "nvim";
      gs = "git status";
      l = "eza --icons --git --long --group-directories-first";
      ll = "eza --icons --git --long --group-directories-first";
      la = "eza -a --icons --git --long --group-directories-first";
      lt = "eza --icons --git --long --tree --group-directories-first --level=2";
      ap = "ansible-playbook";
      k = "kubectl";
      lzd = "lazydocker";
      mt = "mix test";
      mc = "mix compile";
      mdg = "mix deps.get";
      stp = "kdeconnect-cli -n 'Galaxy Z Fold5' --share ";
    };
    interactiveShellInit = /* fish */ ''
        set fish_greeting

        set -x ANSIBLE_STDOUT_CALLBACK yaml
        set -x NIXPKGS_ALLOW_UNFREE 1

        bind \ck up-or-search

        function yy
          set tmp (mktemp -t "yazi-cwd.XXXXXX")
          yazi $argv --cwd-file="$tmp"
          if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            cd "$cwd"
          end
          rm -f -- "$tmp"
        end

        function wt
          set -l choice (git worktree list | awk '{print $1}' | fzf --with-nth -1 -d /)
          if [ -n "$choice" ]
            cd $choice
          end
        end

       function cdl
          set -l dirs (fd --type directory . ~/proj/qarmainspect/backend-libs/ --exact-depth 1)
          set -a dirs ~/proj/qarmainspect/backend/
          set choice (printf "%s\n" $dirs | fzf --with-nth -2 -d /)
          if [ -n "$choice" ]
            cd $choice
          end
        end

      function zellij_update_tabname
          set -q ZELLIJ; or return
          set -l name (path basename $PWD)
          test $PWD = $HOME; and set name "~"

          # append git branch of the current dir, or short sha when detached
          set -l branch (git branch --show-current 2>/dev/null)
          if test -z "$branch"
              set branch (git rev-parse --short HEAD 2>/dev/null)
          end
          test -n "$branch"; and set name "$name  $branch"

          # renaming costs ~14ms, so only do it when the name actually changed
          test "$name" = "$__zellij_tabname"; and return
          if zellij action rename-tab $name >/dev/null 2>&1
              set -g __zellij_tabname $name
          end
      end

      # covers cd, git switch, and lazygit/neogit inside nvim
      function __auto_zellij_update_tabname --on-event fish_prompt --description "Update zellij tab name"
          zellij_update_tabname
      end
    '';
  };
}
