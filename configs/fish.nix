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
    options = [
      "--cmd cd"
    ];
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
      stp = "kdeconnect-cli -n 'Galaxy Z Fold5' --share ";
    };
    interactiveShellInit = /*fish*/''
      set fish_greeting

      set -x ANSIBLE_STDOUT_CALLBACK yaml
      set -x NIXPKGS_ALLOW_UNFREE 1

      set -x AIDER_MODEL claude-3-7-sonnet-latest
      if [ -e ~/.anthropic_api_key ] 
        set -x ANTHROPIC_API_KEY (cat ~/.anthropic_api_key)
      end


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
        if set -q ZELLIJ
            set current_dir $PWD
            if test $current_dir = $HOME
                set current_dir "~"
            else
                set current_dir (basename $current_dir)
            end
            nohup zellij action rename-tab $current_dir >/dev/null 2>&1
        end
    end

    # auto update tab name on directory change
    function __auto_zellij_update_tabname --on-variable PWD --description "Update zellij tab name on directory change"
        zellij_update_tabname
    end
    
    # Update on start as well
    zellij_update_tabname
    '';
  };
}
