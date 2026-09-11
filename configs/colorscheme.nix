# Single place for the nix-colors scheme used by kitty, zellij, waybar, etc.
# Neovim uses tokyonight.nvim directly; this palette is its terminal-side twin.
{ inputs, lib, ... }:
{
  colorScheme = lib.recursiveUpdate inputs.nix-colors.colorSchemes.tokyo-night-terminal-dark {
    slug = "tokyo-night";
    name = "Tokyo Night";
    palette = {
      base00 = "1A1B26"; # editor background of tokyonight "night" (upstream uses the darker sidebar bg)
      base05 = "C0CAF5"; # tokyonight fg (upstream reuses the dim base04 here)
    };
  };
}
