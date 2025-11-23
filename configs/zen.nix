{ inputs, ... }:
{
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];
  programs.zen-browser.enable = true;

  xdg.mimeApps.defaultApplications = {
    "default-web-browser" = "zen-twilight.desktop";
    "text/html" = "zen-twilight.desktop";
    "x-scheme-handler/http" = "zen-twilight.desktop";
    "x-scheme-handler/https" = "zen-twilight.desktop";
    "x-scheme-handler/about" = "zen-twilight.desktop";
    "x-scheme-handler/unknown" = "zen-twilight.desktop";
  };

}
