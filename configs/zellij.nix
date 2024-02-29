
{pkgs, ...}:
{
  programs.zellij = {
      enable = true;
  };

  home.file.".config/zellij/config.kdl".text = ''
    pane_frames false

    keybinds {
      unbind "Ctrl q"
      normal {
        bind "Alt t" {ToggleFloatingPanes;}
      }
    }
  '';
}
