{ pkgs, config, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      user = {
        name = "Jeppe Allerslev";
        email = "jeppeallerslev@gmail.com";
      };
    };
  };
}
