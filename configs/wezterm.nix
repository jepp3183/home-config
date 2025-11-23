{ config, pkgs, ... }:
let
  colorFile =
    with config.colorScheme.palette;
    pkgs.writeText "colors.yml" ''
      scheme: "Custom"
      author: "N/A"
      base00: ${base00}
      base01: ${base01}
      base02: ${base02}
      base03: ${base03}
      base04: ${base04}
      base05: ${base05}
      base06: ${base06}
      base07: ${base07}
      base08: ${base08}
      base09: ${base09}
      base0A: ${base0A}
      base0B: ${base0B}
      base0C: ${base0C}
      base0D: ${base0D}
      base0E: ${base0E}
      base0F: ${base0F}
    '';
in
{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
          enable_wayland = false,
          colors = wezterm.color.load_base16_scheme '${colorFile}',
          font = wezterm.font 'CaskaydiaCove Nerd Font Mono',
          font_size = 13.0,
          enable_tab_bar = false,
          window_close_confirmation = 'NeverPrompt',
          front_end = "WebGpu",
          enable_wayland = false,

          keys = {
              {
                  key = "t",
                  mods = "CTRL",
                  action = wezterm.action.DisableDefaultAssignment,
              },
          }
      }
    '';
  };
}
