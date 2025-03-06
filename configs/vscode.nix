{pkgs,config, inputs,...}:
{
  programs.vscode = {
    enable = true;
    profiles.default.userSettings = {
      "window.titleBarStyle" = "custom";
      "editor.fontFamily" = "CaskaydiaCove Nerd Font Mono";
      "terminal.integrated.fontFamily" = "CaskaydiaCove Nerd Font Mono";
      "editor.inlayHints.enabled" = "offUnlessPressed";
      "rust-analyzer.checkOnSave.command" = "clippy";
      "workbench.colorTheme" = "Ayu Mirage";
    };
    profiles.default.extensions = with pkgs.vscode-extensions; [
      ms-vsliveshare.vsliveshare
      github.copilot
      github.copilot-chat
      rust-lang.rust-analyzer
      teabyii.ayu
    ];
  };
}
