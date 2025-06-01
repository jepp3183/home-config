{pkgs, ...}:
{
  home.packages = with pkgs; [
    zathura
  ];
  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
      highlight-fg = "red";
      highlight-transparency = "0.75";
    };
  };
}
