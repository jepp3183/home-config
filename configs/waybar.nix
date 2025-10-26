{pkgs,config, inputs,...}:

let
    icon = i: "<span size='x-large' rise='-1800'>${i}</span>";
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

        "custom/notification" = {
            tooltip = false;
            format = "{}{icon}";
            "format-icons" = {
                notification = icon "󱅫";
                none = icon "";
                "dnd-notification" = icon "";
                "dnd-none" = icon "󰂛";
                "inhibited-notification" = icon "";
                "inhibited-none" = icon "";
                "dnd-inhibited-notification" = icon "";
                "dnd-inhibited-none" = icon "";
            };
            "return-type" = "json";
            "exec-if" = "which swaync-client";
            exec = "swaync-client -swb";
            "on-click" = "sleep 0.1 && swaync-client -t -sw";
            "on-click-right" = "sleep 0.1 && swaync-client -d -sw";
            escape = true;
        };


        modules-left = ["hyprland/workspaces"];
        modules-center = ["clock"  "custom/notification"];
        modules-right = ["pulseaudio" "network" "cpu" "memory" "battery" "tray"];

        tray = {
            icon-size = 21;
            spacing = 10;
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
            format = "{1} {0:2}%";
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
            format-wifi = "{essid}-{signalStrength}%";
            format-icons = [(icon "⇅")];
            format-ethernet = "{ifname}";
            tooltip-format = ''
            {ifname} = {ipaddr}/{cidr}
            gateway: {gwaddr}
            {bandwidthUpBytes} {icon} {bandwidthDownBytes}'';
            format-linked = "{ifname} (No IP)";
            format-disconnected = "⚠";
            format-alt = "{bandwidthUpBytes} {icon} {bandwidthDownBytes}";
            interval = 5;
            max-length = 20;
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

    style = with config.colorScheme.palette; /*css*/''
      @define-color bg ${hexToRGBA 0 base00};
      @define-color module-bg ${hexToRGBA 0.6 base00};
      /* @define-color text-color #${base01}; */
      @define-color text-color #${base06};
      @define-color hover-color #${base05};
      @define-color urgent-color #eb4d4b;

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

      .modules-right, .modules-left, .modules-center  {
        margin: 5px 5px;
      }

      .modules-right > * > *, .modules-center > * > * {
        color: @text-color;
        background-color: @module-bg;
        border-radius: 8px;
        padding: 0px 10px;
      }

      #workspaces {
        background-color: transparent;
      }

      #workspaces button {
          margin: 0px 2px;
          color: @text-color;
          background-color: @module-bg;
          border-radius: 8px;
      }

      #workspaces button.active, #workspaces button.active.persistent {
          background-color: #${base0B};
          color: #${base01};
          transition-property: background-color;
          transition-duration: .3s;
      }

      #workspaces button:hover {
        background: @hover-color;
      }

      /* SPECIAL PROPERTIES */
      #workspaces button.urgent {
          background-color: @urgent-color;
      }

      #network.disconnected {
          color: @urgent-color;
      }

      @keyframes blink {
          to {
              color: @text-color;
          }
      }

      #battery.critical:not(.charging) {
          color: @urgent-color;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: @urgent-color;
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
