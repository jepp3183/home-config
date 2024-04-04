{pkgs, ...}:
{
  home.packages = with pkgs; [
    lf
  ];

  xdg.configFile."lf/icons".source = ./lf_icons;
  
  programs.lf = {
    enable = true;
    settings = {
      ignorecase = true;
      icons = true;
      preview = true;
      incsearch = true;
      incfilter = true;
    };

    commands = {
      open = ''
        ''${{
          case $(${pkgs.file}/bin/file -Lb --mime-type "$f") in
            text/*) $EDITOR $fx;;
            application/yaml) $EDITOR $fx;;
            *) for f in $fx; do xdg-open $f > /dev/null 2> /dev/null & done;;
          esac
        }}
      '';
      mkdir = "&mkdir -p $1";
      touch = "&touch $1";
      trash = "&mv --backup=t $fx ~/.trash";
      extract = "%${pkgs.atool}/bin/aunpack $f";
      zip = ''
        ''${{
          clear
          printf "%s\n" $fx | head -n 25
          printf "Archive Filename: "
          read archive
          printf "%s\n" $fx\
           | xargs -d '\n' realpath --relative-to=$PWD\
           | xargs -I '{}' -d '\n' echo "\"{}\""\
           | apack -F zip $archive

          lf -remote "send $id unselect"
        }}
      '';
      z = ''
        %{{
          result="$(zoxide query --exclude $PWD $@ | sed 's/\\/\\\\/g;s/"/\\"/g')"
          lf -remote "send $id cd \"$result\""
        }}
      '';
      zi = ''
      ''${{
        result="$(zoxide query -i | sed 's/\\/\\\\/g;s/"/\\"/g')"
        lf -remote "send $id cd \"$result\""
      }}
      '';
      on-cd =  ''
      &{{
        zoxide add "$PWD"
      }}
      '';

    };
    keybindings = {
      # unmap clear, which removed yank/cut paths in buffer
      # c = "";
      D = "trash";
      gu = "cd ~/GDrive/SkoleShit/UNI";
      gp = "cd ~/proj";
      "g/" = "cd /";
      "<enter>" = "open";
      S = "!fish";
      e = "extract";
      f = "filter";
      zi = "zi";
    };

    extraConfig =
      let 
        previewer = 
          pkgs.writeShellScriptBin "pv.sh" ''
          file=$1
          w=$2
          h=$3
          x=$4
          y=$5
          type="$(xdg-mime query filetype "$file")"
          
          if [[ $type =~ ^image ]]; then
              ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
              exit 1
          fi

          if [[ $type =~ ^text ]]; then
              ${pkgs.bat}/bin/bat -f --style='numbers' "$file"
              exit 1
          fi
          
          ${pkgs.pistol}/bin/pistol "$file"
        '';
        cleaner = pkgs.writeShellScriptBin "clean.sh" ''
          ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
        '';
      in
      ''
        set ifs "\n"
        set cleaner ${cleaner}/bin/clean.sh
        set previewer ${previewer}/bin/pv.sh
      '';
  };
}
