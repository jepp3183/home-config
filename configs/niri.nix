{ pkgs, lib, config, ... }:
let
  file_opener = pkgs.writeShellScriptBin "open.sh" ''
    cd ~
    # fd flags: -tl=symlinks, -tf=files, -a=absolute paths
    # sed replaces /home/$USER with ~ for display, then back after selection
    file=$(${lib.getExe pkgs.fd} -tl -tf -a . ~ | sed -e "s#/home/$USER#~#" | ${lib.getExe pkgs.fuzzel} --dmenu --match-mode=fzf --font="FiraCode Nerd Font Mono:size=10" -D yes --width 100 | sed -e "s#~#/home/$USER#")
    # file flags: -L=follow symlinks, -b=brief (no filename prefix), --mime-type=output mime type
    type=$(${lib.getExe pkgs.file} -Lb --mime-type "$file")

    if [[ $type =~ ^text ]]; then
        nohup kitty -e nvim "$file" >/dev/null 2>&1  &
    else
        nohup xdg-open "$file" >/dev/null 2>&1 &
    fi
    # Brief sleep lets the background process initialize before script exits
    sleep 0.01
  '';

  launcher = pkgs.writeShellScriptBin "launcher.sh" ''
    ${lib.getExe pkgs.fuzzel} --font="FiraCode Nerd Font Mono:size=10" -D yes --match-mode=fzf
  '';
in
with config.colorScheme.palette;
{
  home.packages = [
    pkgs.cliphist
  ];

  xdg.configFile."niri/config.kdl".text = /* kdl */ ''
    input {
        keyboard {
            xkb {
                layout "us,dk"
                options "ctrl:nocaps,grp:alt_shift_toggle"
            }
            repeat-delay 250
            repeat-rate 40
        }

        touchpad {
            tap
            natural-scroll
            accel-speed 0.4
        }

        mouse {
            accel-speed -0.6
        }

        focus-follows-mouse
    }

    output "eDP-1" {
        mode "1920x1080@60.033"
        scale 1
    }

    output "Microstep MPG341CX OLED Unknown" {
        mode "3440x1440@239.999"
        scale 1
        position x=0 y=0
    }

    output "Acer Technologies XF270HU T78EE0048521" {
        mode "2560x1440@143.856"
        scale 1
        position x=440 y=-1440
    }

    layout {
        gaps 8

        center-focused-column "never"

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        default-column-width { proportion 0.5; }

        // Disable focus ring (we use border instead)
        focus-ring {
            off
        }

        border {
            width 2
            active-gradient from="#${base09}" to="#${base08}" angle=45
            inactive-color "#${base01}"
        }

        shadow {
            on
            // Blur radius for shadow
            softness 30
            spread 5
            offset x=0 y=5
            // ee = 93% opacity
            color "#0007"
        }
    }

    // spawn-at-startup: exec directly (no shell interpretation)
    spawn-at-startup "noctalia-shell"
    spawn-at-startup "nm-applet" "--indicator"
    spawn-at-startup "blueman-applet"
    spawn-at-startup "kdeconnectd"
    spawn-at-startup "kdeconnect-indicator"
    spawn-at-startup "streamdeck" "-n"
    // spawn-sh-at-startup: runs through shell (needed for pipes, env vars, etc.)
    spawn-sh-at-startup "wl-paste --type text --watch cliphist store"
    spawn-sh-at-startup "wl-paste --type image --watch cliphist store"
    spawn-sh-at-startup "systemctl --user start hyprpolkitagent"

    hotkey-overlay {
        // Don't show the keybinding cheatsheet on niri startup
        skip-at-startup
    }

    // Prefer server-side window decorations (compositor draws titlebars)
    // over client-side decorations (app draws its own)
    prefer-no-csd

    screenshot-path "~/Pictures/Screenshots/%Y-%m-%dT%H:%M:%S.png"

    // Empty block = use default animations
    animations {
    }

    window-rule {
    }

    window-rule {
        match app-id=r#"firefox$"# title="^Picture-in-Picture$"
        open-floating true
    }

    // window-rule {
    //     match app-id=r#"\.blueman-manager"#
    //     open-floating true
    // }

    window-rule {
        match app-id=r#"^xdg-desktop-portal-gtk$"#
        open-floating true
    }

    // // This rule has no match, so it applies to all windows
    // window-rule {
    //     geometry-corner-radius 5
    //     // Clip window content to the rounded corners (otherwise content bleeds through)
    //     clip-to-geometry true
    // }

    binds {
        Mod+Shift+Slash { show-hotkey-overlay; }

        Mod+Return { spawn "kitty"; }
        Mod+B { spawn "firefox"; }
        Mod+Space { spawn "${launcher}/bin/launcher.sh"; }
        Alt+Space { spawn "${file_opener}/bin/open.sh"; }

        Mod+S { spawn-sh "noctalia-shell ipc call controlCenter toggle"; }
        Mod+Comma { spawn-sh "noctalia-shell ipc call settings toggle"; }
        Mod+N { spawn-sh "noctalia-shell ipc call notifications toggleHistory"; }
        Mod+Shift+P { spawn-sh "noctalia-shell ipc call sessionMenu toggle"; }

        // spawn-sh runs through shell, needed for pipes
        Mod+V { spawn-sh "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"; }
        // -t = toggle notification center visibility

        // screenshot = interactive region selection
        Mod+Shift+S { screenshot; }
        // screenshot-screen = entire screen
        Ctrl+Print { screenshot-screen; }
        // screenshot-window = focused window only
        Alt+Print { screenshot-window; }


        // allow-when-locked=true: keybind works even when screen is locked
        // -l 1.5: limit volume to 150% max
        XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.5"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1.5"; }
        XF86AudioMute        allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
        XF86AudioMicMute     allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }

        XF86AudioPlay allow-when-locked=true { spawn "playerctl" "play-pause"; }
        XF86AudioPrev allow-when-locked=true { spawn "playerctl" "previous"; }
        XF86AudioNext allow-when-locked=true { spawn "playerctl" "next"; }

        XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "s" "+10%"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "s" "10%-"; }

        Mod+Q { close-window; }
        // maximize-column: column expands to fill workspace width (other columns scroll off)
        Mod+F { maximize-column; }
        // fullscreen-window: window covers entire screen including gaps/bar
        Mod+Shift+F { fullscreen-window; }

        // Niri uses columns (vertical stacks) that scroll horizontally
        // H/L move between columns, J/K move between windows within a column
        Mod+H { focus-column-left; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }
        Mod+L { focus-column-right; }

        Mod+Home { focus-column-first; }
        Mod+End  { focus-column-last; }

        Mod+Shift+H { move-column-left; }
        Mod+Shift+J { move-window-down; }
        Mod+Shift+K { move-window-up; }
        Mod+Shift+L { move-column-right; }

        // Resize by fixed pixel amounts
        Mod+Left  { set-column-width "-50"; }
        Mod+Right { set-column-width "+50"; }
        Mod+Up    { set-window-height "+50"; }
        Mod+Down  { set-window-height "-50"; }

        // Resize by percentage
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }
        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }

        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }

        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }

        // Navigate between workspaces (up/down in workspace list)
        Mod+Ctrl+K { focus-workspace-up; }
        Mod+Ctrl+J { focus-workspace-down; }

        // Show overview of all windows/workspaces
        Mod+O { toggle-overview; }

        // The following binds move the focused window in and out of a column.
        // If the window is alone, they will consume it into the nearby column to the side.
        // If the window is already in a column, they will expel it out.
        Mod+BracketLeft  { consume-or-expel-window-left; }
        Mod+BracketRight { consume-or-expel-window-right; }

        // Cycle through preset-column-widths defined above (33% -> 50% -> 67% -> ...)
        Mod+R { switch-preset-column-width; }
        Mod+Ctrl+R { reset-window-height; }

        // Scroll view to center the focused column
        Mod+C { center-column; }


        // Stack windows in a column as tabs (like browser tabs)
        Mod+T { toggle-column-tabbed-display; }

        // Move entire column to adjacent monitor
        Mod+Shift+Ctrl+H { move-column-to-monitor-left; }
        Mod+Shift+Ctrl+L { move-column-to-monitor-right; }
        Mod+Shift+Ctrl+J { move-column-to-monitor-down; }
        Mod+Shift+Ctrl+K { move-column-to-monitor-up; }

        // Alternatively, there are commands to move just a single window:
        // Mod+Shift+Ctrl+Left  { move-window-to-monitor-left; }
        // ...

        // And you can also move a whole workspace to another monitor:
        // Mod+Shift+Ctrl+Left  { move-workspace-to-monitor-left; }
        // ...

        // cooldown-ms prevents rapid-fire workspace switching from scroll wheel
        Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
        Mod+WheelScrollUp   cooldown-ms=150 { focus-workspace-up; }

        // allow-inhibiting=false: works even when an app has grabbed keyboard shortcuts
        // (e.g., a game or VM). This is the escape hatch to toggle that inhibit off.
        Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

        // Mod+Shift+E { quit; }
        // Ctrl+Alt+Delete { quit; }
    }
  '';
}
