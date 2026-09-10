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
          # jump to a worktree of the current repo; falls back to qarmainspect when not in one
          set -l repo (git rev-parse --show-toplevel 2>/dev/null)
          if test -z "$repo"
            if git rev-parse --git-common-dir >/dev/null 2>&1
              set repo $PWD # bare repo root: no toplevel, but worktree list still works
            else
              set repo ~/proj/qarmainspect
            end
          end
          set -l trees (git -C "$repo" worktree list --porcelain | string replace -rf '^worktree ' ''' | string match -rv '/\.bare$')
          if test (count $trees) -eq 0
            echo "wt: no worktrees found in $repo" >&2
            return 1
          end
          set -l choice (printf "%s\n" $trees | fzf --with-nth -1 -d /)
          if test -n "$choice"
            cd $choice
          end
        end

        function cdl
          set -l root (git rev-parse --show-toplevel 2>/dev/null)
          if test -z "$root"
            # not in a worktree (e.g. the bare repo root): pick one first
            if not git rev-parse --git-common-dir >/dev/null 2>&1
              echo "cdl: not inside a git repo or worktree" >&2
              return 1
            end
            set -l trees (git worktree list --porcelain | string replace -rf '^worktree ' ''')
            test (count $trees) -gt 0; and set trees (path dirname (path filter -d $trees/backend-libs))
            if test (count $trees) -eq 0
              echo "cdl: no worktree contains backend-libs" >&2
              return 1
            end
            set root (printf "%s\n" $trees | fzf --with-nth -1 -d /)
            test -z "$root"; and return 0
          end
          set -l dirs (path filter -d (path normalize $root/backend-libs/*/ $root/backend))
          if test (count $dirs) -eq 0
            echo "cdl: no backend or backend-libs in $root" >&2
            return 1
          end
          set -l choice (printf "%s\n" $dirs | fzf --with-nth -1 -d /)
          if test -n "$choice"
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

      # covers cd, git switch, and lazygit inside nvim
      function __auto_zellij_update_tabname --on-event fish_prompt --description "Update zellij tab name"
          zellij_update_tabname
      end
    '';
  };
}
