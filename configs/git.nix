{ pkgs, secrets, ... }:
{
  programs.git = {
    enable = true;
    signing.format = null;
    settings = {
      init.defaultBranch = "main";
      user = {
        name = "Jeppe Allerslev";
        email = secrets.main_email;
      };
    };
  };
}
