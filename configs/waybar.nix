{pkgs,config, inputs,...}:

let
    icon = i: "<span size='x-large' rise='-1800'>${i}</span>";
    sep = sep: list: 
      pkgs.lib.strings.splitString "." (builtins.concatStringsSep ".${sep}." list);

    hexToRGBString = inputs.nix-colors.lib.conversions.hexToRGBString;
    hexToRGBA = alpha: hex: "rgba(${hexToRGBString "," hex}, ${builtins.toString alpha})";
in
{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 5;

        modules-left = ["hyprland/workspaces" "custom/media"];
        # modules-center = ["hyprland/window"];
        modules-center = ["clock"];
        modules-right = ["pulseaudio" "network" "cpu" "memory" "battery" "tray"];

        tray = {
            icon-size = 21;
            spacing = 10;
        };
        "custom/sep" = {
          format = " ";
        };
        "custom/media" = {
            exec = ''playerctl metadata 2> /dev/null \
            | grep ':artist\|:title' \
            | awk '{$1="";$2="";print $0}' \
            | tr '\n' '-' \
            | sed -e 's/  //g' -e 's/-$//g'  -e 's/-/ - /'
            '';
            format = "{}";
            interval = 1;
            max-length = 35;
        };
        "hyprland/workspaces" = {
            format-icons = {
                "1" = "1";
                "2" = "2";
                "3" = "3";
                "4" = "4";
                "5" = "5";
                "6" = "6";
                "7" = "7";
                "8" = "8";
                "9" = "9";
                "10" = "10";
            };
            format = "{icon}";
            persistent_workspaces = {
              "*" = 5;
            };
        };
        clock = {
        format = "${icon ""} {:%A,%e.%B ${icon "󰥔"} %R}";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ffffff'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
        };
        };
        cpu = {
            format = "{icon} {usage:2}%";
            format-icons =[(icon "")];
            tooltip = true;
            on-click = "kitty -e btop";
            interval = 5;
        };
        memory = {
            format = "{icon} {:2}%";
            format-icons = [(icon "")];
            on-click = "kitty -e btop";
            interval = 5;
        };
        battery = {
            states = {
                good = 80;
                warning = 30;
                critical = 15;
            };
            interval = 30;
            format = "{capacity}% {icon}";
            format-charging = "{capacity}% 󰂄";
            format-plugged = "{capacity}% ";
            format-alt = "{time} {icon}";
            format-icons = map (x: (icon x)) ["" "" "" "" ""];
        };
        network = {
            format-wifi = "{bandwidthUpBytes} {icon} {bandwidthDownBytes}";
            format-icons = [(icon "⇅")];
            format-ethernet = "{ipaddr}/{cidr}";
            tooltip-format = "{ifname} via {gwaddr}";
            format-linked = "{ifname} (No IP)";
            format-disconnected = "Disconnected ⚠";
            format-alt = "{ifname} = {ipaddr}/{cidr}";
            interval = 5;
            max-length = 20;
            min-length = 20;
        };
        pulseaudio = {
            format = "{volume}% {icon} {format_source}";
            format-muted = "{volume}% ${icon "󰝟"} {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = "󰗿 {icon} {format_source}";
            format-source = icon "";
            format-source-muted = icon "";
            format-icons = {
                headphone = icon "";
                hands-free = icon "";
                headset = icon "";
                phone = icon "";
                portable = icon "";
                car = icon "";
                default = map (x: (icon x)) ["" "" ""];
            };
            on-click = "pavucontrol";
        };
      }; 
    };

    style = with config.colorScheme.palette; ''
      @define-color bg ${hexToRGBA 0.5 base00};
      @define-color module-bg #${base0D};
      @define-color text-color #${base01};
      @define-color hover-color #${base05};

      * {
          font-family: FiraCode Nerd Font Mono;
          font-weight: 500;
          font-size: 16px;
      }

      window#waybar {
          background-color: @bg;
          transition-property: background-color;
          transition-duration: .2s;
      }

      window#waybar.empty {
          background-color: transparent;
      }

     .modules-right > *, .modules-center > *, #custom-media  {
        color: @text-color;
        background-color: @module-bg;
        border-radius: 20px;
     }

     .modules-right, .modules-left, .modules-center  {
        margin: 5px 5px;
      }

      button {
          /* Use box-shadow instead of border so the text isn't offset */
          box-shadow: inset 0 -3px transparent;
          /* Avoid rounded borders under each button name */
          border: none;
          border-radius: 0;
      }

      #workspaces {
        background-color: transparent;
        margin-right: 5px
      }

      #workspaces button {
          margin: 0px 2px;
          color: @text-color;
          background-color: @module-bg;
          border-radius: 50%;
          font-size: 18px;
          font-weight: 700;
      }

      #workspaces button.active, #workspaces button.active.persistent {
          background-color: #${base0B};
          transition-property: background-color;
          transition-duration: .3s;
      }

      #workspaces button:hover {
        background: @hover-color;
      }

      #workspaces button > * {
          font-size: 18px;
          font-weight: 700;
      }

      #workspaces button.empty {
          background-color: transparent;
      }

      #clock, #battery, #cpu, #memory, #disk, #temperature, #backlight,
      #network, #pulseaudio, #wireplumber, #custom-media, #tray,
      #mode, #idle_inhibitor, #scratchpad, #mpd {
        padding: 0px 10px;
      }



      #custom-sep {
        background-color: rgba(16, 22, 26, 1.0);
        margin: 0px -2px;
      }  

      #custom-media {
        font-size: 14px;
      }

      #workspaces button.urgent {
          background-color: #eb4d4b;
      }

      #network.disconnected {
          color: #f53c3c;
      }

      @keyframes blink {
          to {
              color: @text-color;
          }
      }

      #battery.critical:not(.charging) {
          color: #f53c3c;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: #eb4d4b;
      }

      /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
      button:hover {
          background: inherit;
          box-shadow: inherit;
          text-shadow: inherit;
      }

    '';
  };
}
