{pkgs,config, inputs,...}:
{
  programs.vscode = {
    enable = true;
    userSettings = {
      "window.titleBarStyle" = "custom";
    };
    extensions = with pkgs.vscode-extensions; [
      ms-vsliveshare.vsliveshare
      github.copilot
      github.copilot-chat
    ];
  };
}
