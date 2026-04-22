{ lib, ... }:

{
  options.custom = {
    wallpaper = lib.mkOption {
      type = lib.types.path;
      description = "Path to the wallpaper image";
      default = ../files/wallpapers/astronaut.png;
    };

    elixirLsCmd = lib.mkOption {
      type = lib.types.str;
      default = "/home/jeppe/.nix-profile/bin/elixir-ls";
    };
  };
}
