{pkgs, config, inputs,...}:
let 
  file_opener = pkgs.writeShellScriptBin "open.sh" ''
    cd ~
    file=$(${pkgs.fd}/bin/fd -tl -tf -a . ~ | sed -e "s#/home/$USER#~#" | ${pkgs.fuzzel}/bin/fuzzel --dmenu --no-fuzzy --font="FiraCode Nerd Font Mono:size=8" --width 100 | sed -e "s#~#/home/$USER#")
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
    choice=$(printf ' Shutdown\n󰤄 Suspend\n Reboot\n Lock'\
              | fuzzel --dmenu --width=14 --lines=5\
              | awk '{print $2}'
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
    esac
  '';

  wallpaper = "${../../files/mountain.jpg}";
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

  home.file.".config/hypr/hyprland.conf" = {
    executable = false;
    text = ''
      general {
          gaps_in=5
          gaps_out=3
          border_size=2
          col.active_border=rgba(${base09}99) rgba(${base08}99) 45deg
          col.inactive_border=rgba(${base01}99)
          layout=dwindle
          resize_on_border=true
          gaps_workspaces=10
      }
      decoration {
        blur {
          enabled=true
          ignore_opacity=true
          passes=2
          size=8
        }
        col.shadow=rgba(1a1a1aee)
        drop_shadow=true
        rounding=5
        shadow_range=4
        shadow_render_power=3
      }
      input {
        touchpad {
          natural_scroll=true
        }
        follow_mouse=1
        kb_layout=us,dk
        kb_options=ctrl:nocaps,grp:alt_shift_toggle
        repeat_delay=500
        repeat_rate=30
        sensitivity=0.2
      }
      # animations {
      #   bezier=myBezier, 0.05, 0.9, 0.1, 1.05
      #   animation=windows, 1, 7, myBezier
      #   animation=windowsOut, 1, 7, default, popin 80%
      #   animation=border, 1, 10, default
      #   animation=borderangle, 1, 8, default
      #   animation=fade, 1, 7, default
      #   animation=workspaces, 1, 6, default
      #   enabled=true
      # }
      animations {
        enabled=1
        # bezier=overshot,0.05,0.9,0.1,1.1
        bezier=overshot,0.13,0.99,0.29,1.1
        animation=windows,1,4,overshot,slide
        animation=border,1,10,default
        animation=fade,1,10,default
        animation=workspaces,1,6,overshot,slidefade 20%
      }

      gestures {
        workspace_swipe=true
      }
      dwindle {
        no_gaps_when_only=1
        preserve_split=true
        pseudotile=true
        smart_split=false
        special_scale_factor=0.950000
      }
      exec=blueman-applet
      exec-once=waybar
      exec-once=${pkgs.hyprpaper}/bin/hyprpaper
      exec-once=nm-applet --indicator
      exec-once=dunst
      exec-once=insync start --qt-qpa-platform=xcb
      exec-once=[workspace special:terminal silent] kitty
      exec-once=[workspace special:qalc silent] kitty -e qalc
      monitor=eDP-1,1920x1080@60.033001,auto,1
      windowrule=opacity 0.85,(wezterm|kitty)
      env = HYPRCURSOR_THEME,rose-pine-hyprcursor
      env = HYPRCURSOR_SIZE,28

      # ===========================================
      # BINDS
      # ===========================================
      $mainMod = SUPER

      bind = $mainMod, M, exit, 
      bind = $mainMod+SHIFT, S, exec, ${pkgs.fish}/bin/fish -c "XDG_SCREENSHOTS_DIR=/home/jeppe/Pictures/Screenshots ${pkgs.imagemagick}/bin/convert - -shave 1x1 PNG:- < (${pkgs.sway-contrib.grimshot}/bin/grimshot save area) | ${pkgs.wl-clipboard}/bin/wl-copy"
      bind = ALT, SPACE, exec, ${file_opener}/bin/open.sh

      # Testing...
      bind = $mainMod, O, movetoworkspace, special
      bind = $mainMod, P, togglespecialworkspace, 
      bind = $mainMod, U, togglespecialworkspace, terminal
      bind = $mainMod, Y, togglespecialworkspace, qalc

      # RUN
      bind = $mainMod, Return, exec, kitty
      bind = $mainMod, B, exec, brave
      bind = $mainMod+SHIFT, P, exec, ${power_menu}/bin/power_menu.sh
      bind = $mainMod, SPACE, exec, ${launcher}/bin/launcher.sh

      # LID CLOSE
      bindl = ,switch:Lid Switch, exec, swaylock -i ${wallpaper}
      
      # Brightness + Volume
      bind = , XF86MonBrightnessDown, exec, brightnessctl s 10%-
      bind = , XF86MonBrightnessUp, exec, brightnessctl s +10%
      bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bind = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1.5
      bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.5
      bind = , XF86AudioPlay, exec, playerctl play-pause
      bind = , XF86AudioPrev, exec, playerctl previous
      bind = , XF86AudioNext, exec, playerctl next

      # OTHER WINDOW CONTROLS
      bind = $mainMod, F, fullscreen, 0
      bind = $mainMod, Q, killactive, 
      bind = $mainMod+SHIFT, F, togglefloating, 
      bind = $mainMod, T, togglesplit, # dwindle

      # RESIZE WINDOW
      bind = $mainMod, left, resizeactive, -50 0
      bind = $mainMod, right, resizeactive, 50 0
      bind = $mainMod, up, resizeactive, 0 -50
      bind = $mainMod, down, resizeactive, 0 50

      # MOVE FOCUS
      bind = $mainMod, H, movefocus, l
      bind = $mainMod, L, movefocus, r
      bind = $mainMod, K, movefocus, u
      bind = $mainMod, J, movefocus, d

      # MOVE WINDOWS
      bind = $mainMod+SHIFT, H, movewindow, l
      bind = $mainMod+SHIFT, L, movewindow, r
      bind = $mainMod+SHIFT, K, movewindow, u
      bind = $mainMod+SHIFT, J, movewindow, d

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspacesilent, 1
      bind = $mainMod SHIFT, 2, movetoworkspacesilent, 2
      bind = $mainMod SHIFT, 3, movetoworkspacesilent, 3
      bind = $mainMod SHIFT, 4, movetoworkspacesilent, 4
      bind = $mainMod SHIFT, 5, movetoworkspacesilent, 5
      bind = $mainMod SHIFT, 6, movetoworkspacesilent, 6
      bind = $mainMod SHIFT, 7, movetoworkspacesilent, 7
      bind = $mainMod SHIFT, 8, movetoworkspacesilent, 8
      bind = $mainMod SHIFT, 9, movetoworkspacesilent, 9
      bind = $mainMod SHIFT, 0, movetoworkspacesilent, 10
    '';
  };
}
