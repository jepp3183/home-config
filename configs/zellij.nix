{config, ...}:
{
  programs.zellij = {
      enable = true;
  };

  home.file.".config/zellij/config.kdl".text = with config.colorScheme.palette; ''
    pane_frames false
    // default_layout "compact"
    default_mode "locked"
    default_shell "fish"
    copy_on_select false
    mouse_mode true

    keybinds {
      unbind "Ctrl q"
      shared {
        bind "Alt t" {ToggleFloatingPanes;}
        bind "Alt n" { NewPane; }
        bind "Alt i" { GoToPreviousTab; }
        bind "Alt o" { GoToNextTab; }
        bind "Alt h" "Alt Left" { MoveFocus "Left"; }
        bind "Alt l" "Alt Right" { MoveFocus "Right"; }
        bind "Alt j" "Alt Down" { MoveFocus "Down"; }
        bind "Alt k" "Alt Up" { MoveFocus "Up"; }
        bind "Alt =" "Alt +" { Resize "Increase"; }
        bind "Alt -" { Resize "Decrease"; }
        bind "Alt [" { PreviousSwapLayout; }
        bind "Alt ]" { NextSwapLayout; }
        bind "Alt x" { CloseFocus; }
      }
    }

    theme "default"

    themes {
      default {
        fg "#${base05}"
        bg "#${base02}"
        black "#${base00}"
        red "#${base08}"
        green "#${base0B}"
        yellow "#${base0A}"
        blue "#${base0D}"
        magenta "#${base0E}"
        cyan "#${base0C}"
        white "#${base05}"
        orange "#${base09}"
      }
    }
  '';
}
