{ pkgs, config, ... }:
{
  programs.git = {
    enable = true;
    userName = "Jeppe Allerslev";
    userEmail = "jeppeallerslev@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
