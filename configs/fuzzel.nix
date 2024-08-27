{pkgs, config, ...}:
{
    programs.fuzzel = with config.colorScheme.palette; {
      enable = true;
      settings = {
          main = {
              font =  "FiraCode Nerd Font Mono:size=9";
              width = "40";
              lines = "25";
          };
          key-bindings = {
              next = "none";
              prev = "none";
              prev-with-wrap = "Control+k Up ISO_Left_Tab";
              next-with-wrap = "Control+j Down";
              delete-prev-word = "Control+w";
              delete-line-forward = "none";
          };
          colors = {
            background =       "${base00}ff";
            border =           "${base0D}ff";
            text =             "${base05}ff";
            selection-text =   "${base0D}ff"; 
            selection =        "${base03}ff";
            match =            "${base09}ff";
            selection-match =  "${base09}ff";
          };
      };
    };
}
