{ pkgs, ... }:
let
  bambu-studio-appimage = pkgs.appimageTools.wrapType2 rec {
    name = "BambuStudio";
    pname = "bambustudio";
    version = "02.00.01.50";
    src = pkgs.fetchurl {
      url = "https://github.com/bambulab/BambuStudio/releases/download/v${version}/Bambu_Studio_ubuntu-24.04_v${version}.AppImage";
      sha256 = "sha256-wB14wr3akLPmi5jVqiVFkGGHVjZeR6BeAYgvdGuhsSw=";
    };
    profile = ''
      export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      export GIO_MODULE_DIR="${pkgs.glib-networking}/lib/gio/modules/"
    '';
    extraPkgs = pkgs: with pkgs; [
      cacert
      curl
      glib
      glib-networking
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      webkitgtk_4_1
    ];
  };
in
{
  home.packages = [
    bambu-studio-appimage
  ];

  xdg.desktopEntries.bambustudio = {
    name = "Bambu Studio";
    exec = "${bambu-studio-appimage}/bin/bambustudio -- %u";
    terminal = false;
    type = "Application";
    categories = ["Science"];
    mimeType = [
      "x-scheme-handler/bambustudio" 
      "application/x-bambustudio"
      "application/bambustudio"
    ];
  };
}
