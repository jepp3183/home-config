
{pkgs, configLines ? '''',...}:
{
  programs.zellij = {
      enable = true;
  };

  home.file.".config/zellij/config.kdl".text = ''
    pane_frames false

    keybinds {
      unbind "Ctrl q"
      shared {
        bind "Alt t" {ToggleFloatingPanes;}
        bind "Alt n" { NewPane; }
        bind "Alt i" { GoToPreviousTab; }
        bind "Alt o" { GoToNextTab; }
        bind "Alt h" "Alt Left" { MoveFocusOrTab "Left"; }
        bind "Alt l" "Alt Right" { MoveFocusOrTab "Right"; }
        bind "Alt j" "Alt Down" { MoveFocus "Down"; }
        bind "Alt k" "Alt Up" { MoveFocus "Up"; }
        bind "Alt =" "Alt +" { Resize "Increase"; }
        bind "Alt -" { Resize "Decrease"; }
        bind "Alt [" { PreviousSwapLayout; }
        bind "Alt ]" { NextSwapLayout; }
        bind "Alt x" { CloseFocus; }
      }
    }
  '' + configLines;
}
