{ ... }:
{
  programs.plasma = {
    enable = true;

    input.keyboard = {
      layouts = [
        { layout = "us"; }
        { layout = "dk"; }
      ];
      repeatDelay = 250;
      repeatRate = 40;
    };

    configFile = {
      kxkbrc.Layout.Options = "grp:win_space_toggle,caps:ctrl_modifier";
    };
  };
}
