{pkgs, config, ...}:
let 
  file_opener = pkgs.writeShellScriptBin "open.sh" ''
    cd ~
    file=$(${pkgs.fd}/bin/fd -tl -tf -a . ~ | sed -e "s#/home/$USER#~#" | ${pkgs.fuzzel}/bin/fuzzel --dmenu --match-mode=fzf --font="FiraCode Nerd Font Mono:size=8" --width 100 | sed -e "s#~#/home/$USER#")
    type=$(${pkgs.file}/bin/file -Lb --mime-type "$file")

    if [[ $type =~ ^text ]]; then
        nohup kitty -e nvim "$file" >/dev/null 2>&1  &
    else
        nohup xdg-open "$file" >/dev/null 2>&1 &
    fi
    sleep 0.01
  '';

  launcher = pkgs.writeShellScriptBin "launcher.sh" ''
    ${pkgs.fuzzel}/bin/fuzzel
  '';

  power_menu = pkgs.writeShellScriptBin "power_menu.sh" ''
      choice=$(printf ' Shutdown\n󰤄 Suspend\n Reboot\n Lock\n Log out'\
              | fuzzel --dmenu --width=14 --lines=5\
              | awk '{print $2$3}'
            )

    case $choice in
        Shutdown)
            systemctl poweroff
            ;;
        Suspend)
            systemctl suspend
            ;;
        Reboot)
            systemctl reboot
            ;;
        Lock)
            swaylock -i ${wallpaper}
            ;;
        Logout)
            hyprctl dispatch exit
            ;;
    esac
  '';

  wallpaper = "${config.custom.wallpaper}";
in
with config.colorScheme.palette; {

  services.hyprpaper = {
      enable = true;
      settings = {
        preload = [
          wallpaper
        ];
        wallpaper = ", ${wallpaper}";
      };
  };

  services.kdeconnect.enable = true;

  home.packages = [
    pkgs.cliphist
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    settings = {
      general = {
        gaps_in = 4;
        gaps_out = 3;
        border_size = 2;
        "col.active_border" = "rgba(${base09}99) rgba(${base08}99) 45deg";
        "col.inactive_border" = "rgba(${base01}99)";
        layout = "dwindle";
        resize_on_border = true;
        gaps_workspaces = 10;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        smart_split = false;
        force_split = 2;
        special_scale_factor = 0.95;
      };

      group = {
        groupbar = {
          font_size = 15;
          height = 18;
          gradients = true;
          text_color = "rgba(${base00}ff)";
          "col.active" = "rgba(${base0D}ff)";
          "col.inactive" = "rgba(${base0C}ff)";
          # text_offset = ???
          indicator_height = 0;
          gradient_rounding = 5;
          gradient_round_only_edges = false;
        };
      };

      misc = {
        disable_hyprland_logo = true;
        force_default_wallpaper = 0;
        font_family = "FiraCode Nerd Font Mono";
        vfr = true;
      };
      
      decoration = {
        blur = {
          enabled = true;
          ignore_opacity = true;
          passes = 2;
          size = 1;
        };
        shadow = {
          enabled = true;
          color = "rgba(1a1a1aee)";
          render_power = 3;
          range = 4;
        };
        rounding = 5;
      };

      layerrule = [
        "blur, waybar"
        "ignorezero, waybar"
      ];
      
      input = {
        touchpad = {
          natural_scroll = true;
        };
        follow_mouse = 1;
        kb_layout = "us,dk";
        kb_options = "ctrl:nocaps,grp:alt_shift_toggle";
        repeat_delay = 250;
        repeat_rate = 40;
        sensitivity = -0.6;
      };
      
      animations = {
        enabled = 0;
        bezier = "overshot,0.13,0.99,0.29,1.1";
        animation = [
          "windows,1,3,overshot,popin"
          "border,1,5,default"
          "fade,1,5,default"
          "workspaces,1,6,overshot,slidefade 20%"
        ];
      };
      
      gesture = [
        "3, horizontal, workspace"
      ]; 
      
      # Workspace configurations
      workspace = [
        "w[tv1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"
      ];
      
      # Window rules
      windowrulev2 = [
        "bordersize 0, floating:0, onworkspace:w[tv1]"
        "rounding 0, floating:0, onworkspace:w[tv1]"
        "bordersize 0, floating:0, onworkspace:f[1]"
        "rounding 0, floating:0, onworkspace:f[1]"
        "workspace special:discord silent, class:^(discord)$"
        "float, class:^(xdg-desktop-portal-gtk)$"
        "float, class:(.blueman-manager-wrapped)"
        "opacity 0.0 override, class:^(xwaylandvideobridge)$"
        "noanim, class:^(xwaylandvideobridge)$"
        "noinitialfocus, class:^(xwaylandvideobridge)$"
        "maxsize 1 1, class:^(xwaylandvideobridge)$"
        "noblur, class:^(xwaylandvideobridge)$"
        "nofocus, class:^(xwaylandvideobridge)$"
      ];
      
      # Environment variables
      env = [
        "HYPRCURSOR_THEME,rose-pine-hyprcursor"
        "HYPRCURSOR_SIZE,28"
        "NVD_BACKEND,direct"
      ];
      
      # Key bindings
      "$mainMod" = "SUPER";
      
      bind = [
        "$mainMod+SHIFT, S, exec, ${pkgs.fish}/bin/fish -c \"XDG_SCREENSHOTS_DIR=/home/jeppe/Pictures/Screenshots ${pkgs.grimblast}/bin/grimblast copysave area\""
        "ALT, SPACE, exec, ${file_opener}/bin/open.sh"
        "$mainMod, V, exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"
        "$mainMod, N, exec, swaync-client -t"
        
        # Workspaces
        "$mainMod+SHIFT, 0, movetoworkspace, special"
        "$mainMod, 0, togglespecialworkspace, "
        "$mainMod, U, togglespecialworkspace, terminal"
        "$mainMod, Y, togglespecialworkspace, qalc"
        "$mainMod, F12, togglespecialworkspace, discord"
        
        # Run applications
        "$mainMod, Return, exec, kitty"
        "$mainMod, B, exec, zen"
        "$mainMod+SHIFT, P, exec, ${power_menu}/bin/power_menu.sh"
        "$mainMod, SPACE, exec, ${launcher}/bin/launcher.sh"
        
        # Brightness and volume controls
        ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        ", XF86MonBrightnessUp, exec, brightnessctl s +10%"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1.5"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.5"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
        
        # Window controls
        "$mainMod, F, fullscreen, 0"
        "$mainMod, Q, killactive, "
        "$mainMod+SHIFT, F, togglefloating, "
        "$mainMod, T, togglesplit, # dwindle"

        ## Grouping
        "$mainMod, G, togglegroup"
        "$mainMod, O, changegroupactive, f"
        "$mainMod, I, changegroupactive, b"
        
        # Resize window
        "$mainMod, left, resizeactive, -50 0"
        "$mainMod, right, resizeactive, 50 0"
        "$mainMod, up, resizeactive, 0 -50"
        "$mainMod, down, resizeactive, 0 50"
        
        # Move focus
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"
        
        # Move windows
        "$mainMod+SHIFT, H, movewindoworgroup, l"
        "$mainMod+SHIFT, L, movewindoworgroup, r"
        "$mainMod+SHIFT, K, movewindoworgroup, u"
        "$mainMod+SHIFT, J, movewindoworgroup, d"
        
        # Switch workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod+CTRL, h, workspace, r-1"
        "$mainMod+CTRL, l, workspace, r+1"
        
        # Move active window to workspace
        "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
        "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
        "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
        "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
        "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
        "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
        "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
      ];
      
      bindl = [
        ",switch:Lid Switch, exec, swaylock -i ${wallpaper}"
      ];
      
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      
      # Startup applications
      exec = [
        "blueman-applet"
        ''hyprctl hyprpaper reload ,"${wallpaper}"''
      ];
      
      "exec-once" = [
        "waybar"
        "${pkgs.hyprpaper}/bin/hyprpaper"
        "nm-applet --indicator"
        "swaync"
        "systemctl --user start hyprpolkitagent"
        "[workspace special:terminal silent] kitty"
        "[workspace special:qalc silent] kitty -e qalc"
        "discord"
        "kdeconnectd"
        "kdeconnect-indicator"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];
    };
  };
}
