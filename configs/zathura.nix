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
      highlight-color = "yellow";
      highlight-transparency = "0.75";
    };
  };
}
