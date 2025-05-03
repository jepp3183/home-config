{ lib, ... }:

{
  options.custom = {
    wallpaper = lib.mkOption {
      type = lib.types.path;
      description = "Path to the wallpaper image";
      default = ../files/astronaut.png;
    };
  };
}

