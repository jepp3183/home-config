{ pkgs, config, ... }:
{
  programs.git = {
    enable = true;
    signing.format = null;
    settings = {
      init.defaultBranch = "main";
      user = {
        name = "Jeppe Allerslev";
        email = "jeppeallerslev@gmail.com";
      };
    };
  };
}
