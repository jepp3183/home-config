{ config, pkgs, ... }:
{
    # Dependencies (nice to haves)
    home.packages = with pkgs; [
        unar
        poppler
        ffmpegthumbnailer
        fd
        ripgrep
        fzf
        wl-clipboard
        exiftool
    ];


    programs.yazi = {
        enable = true;
        enableFishIntegration = true;
        settings = {
            # See https://yazi-rs.github.io/docs/configuration/yazi/
            manager = {
                sort_sensitive = false;
                sort_dir_first = true;
                linemode = "mtime";
            };
            opener = {
                edit = [ { run = ''nvim "$@"''; block = true;} ];
                open = [ { run = ''xdg-open "$@"''; } ];
            };
        };
        keymap = {
            # See https://yazi-rs.github.io/docs/configuration/keymap/
            manager = {
                prepend_keymap = [
                    { on = ["<C-s>"]; run = ''shell "$SHELL" --block --confirm''; desc = "Drop to shell";}
                    { on = ["g" "u"]; run = ''cd ~/GDrive/SkoleShit/UNI''; desc = "Go to UNI";}
                    { on = ["g" "p"]; run = ''cd ~/proj''; desc = "Go to proj";}
                    { on = ["g" "/"]; run = ''cd ~/''; desc = "Go to home";}
                    { on = ["g" "d"]; run = ''cd ~/Downloads''; desc = "Go to Downloads";}
                ];
            };
        };
    };
}
