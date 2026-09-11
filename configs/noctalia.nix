{
  inputs,
  config,
  ...
}:
let
  # Noctalia v5 renamed the 16 color roles to snake_case in TOML, but custom
  # palette JSON files still use the v4 mRole names.
  palette =
    with config.colorScheme.palette;
    {
      mSurface = "#${base00}";
      mSurfaceVariant = "#${base01}";
      mHover = "#${base02}";
      mOutline = "#${base03}";
      mOnSurfaceVariant = "#${base04}";
      mOnSurface = "#${base05}";
      mOnHover = "#${base06}";
      mPrimary = "#${base0D}";
      mOnPrimary = "#${base00}";
      mSecondary = "#${base0C}";
      mOnSecondary = "#${base00}";
      mTertiary = "#${base0E}";
      mOnTertiary = "#${base00}";
      mError = "#${base08}";
      mOnError = "#${base00}";
      mShadow = "#000000";

      # Consumed by terminal theming templates.
      terminal = {
        background = "#${base00}";
        foreground = "#${base05}";
        cursor = "#${base05}";
        cursorText = "#${base00}";
        selectionBg = "#${base02}";
        selectionFg = "#${base05}";
        normal = {
          black = "#${base00}";
          red = "#${base08}";
          green = "#${base0B}";
          yellow = "#${base0A}";
          blue = "#${base0D}";
          magenta = "#${base0E}";
          cyan = "#${base0C}";
          white = "#${base05}";
        };
        bright = {
          black = "#${base03}";
          red = "#${base08}";
          green = "#${base0B}";
          yellow = "#${base0A}";
          blue = "#${base0D}";
          magenta = "#${base0E}";
          cyan = "#${base0C}";
          white = "#${base07}";
        };
      };
    };

  paletteName = config.colorScheme.slug;
in
{
  # import the home manager module
  imports = [
    inputs.noctalia.homeModules.default
  ];

  # configure options
  programs.noctalia = {
    enable = true;

    # Written to ~/.config/noctalia/palettes/<name>.json and selected by
    # theme.custom_palette below. Only `dark` is set, so it is used for both modes.
    customPalettes.${paletteName}.dark = palette;

    # Written to ~/.config/noctalia/config.toml.
    # Inspect the merged config with `noctalia config export`, or the full
    # effective config (including defaults) with `noctalia config export full`.
    # GUI changes land in ~/.local/state/noctalia/settings.toml and win over
    # this file - delete that file to go back to what is declared here.
    settings = {
      shell = {
        font_family = "sans-serif";
        avatar_path = "/home/jeppe/.face";
        telemetry_enabled = false;
        card_borders = false;
        # Noctalia's own clipboard history stays off; cliphist + fuzzel handles it (see niri.nix).
        clipboard_enabled = false;

        animation = {
          enabled = true;
          speed = 1.0;
        };

        shadow = {
          direction = "down_right";
          alpha = 0.55;
        };

        screen_corners.enabled = false;

        panel = {
          # v4 had a numeric panel opacity; v5 exposes solid | soft | glass.
          transparency_mode = "soft";
          borders = true;
          shadow = true;
          control_center_placement = "attached";
          wallpaper_placement = "attached";
          launcher_placement = "floating";
          launcher_position = "center";
          session_placement = "floating";
          open_near_click_control_center = true;
        };

        launcher = {
          categories = true;
          show_icons = true;
          sort_by_usage = true;
          app_grid = false;
          # Terminal apps use $TERMINAL now - v4's terminalCommand is gone.
          providers = {
            session.global = true;
            windows.global = true;
          };
        };

        session = {
          grid = false;
          show_shortcuts = true;
          actions = [
            {
              action = "lock";
              shortcut = "1";
              countdown_seconds = 10;
            }
            {
              action = "suspend";
              shortcut = "2";
              countdown_seconds = 10;
            }
            {
              # No built-in hibernate action in v5.
              action = "command";
              command = "systemctl hibernate";
              label = "Hibernate";
              glyph = "moon";
              shortcut = "3";
              countdown_seconds = 10;
            }
            {
              action = "reboot";
              shortcut = "4";
              countdown_seconds = 10;
            }
            {
              action = "logout";
              shortcut = "5";
              countdown_seconds = 10;
            }
            {
              action = "shutdown";
              shortcut = "6";
              countdown_seconds = 10;
            }
            {
              # No built-in rebootToUefi action in v5.
              action = "command";
              command = "systemctl reboot --firmware-setup";
              label = "Reboot to UEFI";
              glyph = "settings";
              shortcut = "7";
              countdown_seconds = 10;
            }
          ];
        };
      };

      theme = {
        mode = "dark";
        source = "custom";
        custom_palette = paletteName;
      };

      bar.main = {
        position = "top";
        background_opacity = 0.93;
        radius = 12;
        margin_edge = 4;
        margin_ends = 4;
        widget_spacing = 6;
        padding = 8;
        font_scale = 1.0;
        shadow = true;
        auto_hide = false;
        reserve_space = true;
        capsule = true;
        capsule_opacity = 1.0;
        # base00 is overridden to base01's value in colorscheme.nix, so surface
        # and surface_variant (the default capsule fill) are the same color -
        # fill capsules with base02 instead so they are actually visible.
        capsule_fill = "hover";

        start = [
          "launcher"
          "cpu"
          "cpu-temp"
          "ram"
          "taskbar"
        ];
        center = [
          "workspaces"
          "media"
          "clock"
        ];
        end = [
          "tray"
          "notifications"
          "volume"
          "bluetooth"
          "network"
          "battery"
          "control-center"
        ];
      };

      widget = {
        launcher.glyph = "rocket";

        # v4's single SystemMonitor widget is one widget per stat in v5.
        cpu = {
          type = "sysmon";
          stat = "cpu_usage";
          font_family = "monospace";
          actions.middle = "exec kitty btop";
        };
        cpu-temp = {
          type = "sysmon";
          stat = "cpu_temp";
          font_family = "monospace";
          actions.middle = "exec kitty btop";
        };
        ram = {
          type = "sysmon";
          stat = "ram_used";
          font_family = "monospace";
          actions.middle = "exec kitty btop";
        };

        taskbar = {
          icon_scale = 0.8;
          only_active_workspace = true;
          show_all_outputs = false;
          show_window_title = true;
          window_title_max_width = 120;
        };

        workspaces = {
          style = "regular";
          label_source = "id";
          max_label_chars = 2;
          labels_only_when_occupied = true;
          hide_when_empty = false;
          pill_scale = 0.6;
          font_weight = 700;
          focused_color = "primary";
          occupied_color = "secondary";
          empty_color = "secondary";
        };

        media = {
          max_length = 500;
          title_scroll = "on_hover";
          artist_first = false;
          hide_when_no_media = false;
        };

        clock = {
          format = "{:%H:%M %a, %b %d}";
          vertical_format = "{:%H %M - %d %m}";
          tooltip_format = "{:%H:%M %a, %b %d}";
        };

        tray = {
          drawer = true;
          hide_passive = false;
          pinned = [
            "steam"
            "spotify-client"
            "Discord"
          ];
        };

        notifications.hide_when_no_unread = false;

        volume = {
          show_label = false;
          actions.middle = "exec pwvucontrol || pavucontrol";
        };

        bluetooth.show_label = false;
        network.show_label = false;

        battery = {
          display_mode = "graphic";
          show_label = true;
          device = "auto";
        };

        control-center.color = "primary";
      };

      control_center = {
        # v4 disabled the brightness card; v5 organizes the panel into tabs.
        hidden_tabs = [ "monitor" ];
        calendar = {
          show_events_card = true;
          show_week_numbers = true;
        };
        shortcuts = [
          { type = "wifi"; }
          { type = "bluetooth"; }
          { type = "wallpaper"; }
          { type = "notification"; }
          { type = "power_profile"; }
          { type = "caffeine"; }
        ];
      };

      wallpaper = {
        enabled = true;
        directory = "/home/jeppe/.config/home-manager/files/wallpapers";
        fill_mode = "crop";
        # v4's "pixelate" transition no longer exists.
        transition = [
          "fade"
          "disc"
          "stripes"
          "wipe"
          "honeycomb"
        ];
        transition_duration = 1500;
        transition_on_startup = false;
        edge_smoothness = 0.05;
        automation = {
          enabled = false;
          interval_seconds = 300;
          order = "random";
        };
      };

      backdrop = {
        enabled = false;
        blur_intensity = 0.4;
        tint_intensity = 0.6;
      };

      notification = {
        enable_daemon = true;
        position = "top_right";
        layer = "overlay";
        background_opacity = 1.0;
        keep_dismissed_in_history = true;
      };

      osd = {
        position = "top_right";
        background_opacity = 1.0;
        kinds = {
          volume = true;
          brightness = true;
          keyboard_layout = true;
        };
      };

      audio = {
        enable_overdrive = false;
        enable_sounds = false;
      };

      brightness = {
        enable_ddcutil = false;
        minimum_brightness = 0.01;
      };

      location = {
        auto_locate = false;
        address = "Aarhus, DK";
      };

      weather = {
        enabled = true;
        unit = "celsius";
        effects = true;
      };

      lockscreen = {
        enabled = true;
        lock_before_suspend = true;
      };

      nightlight = {
        enabled = false;
        force = false;
        temperature_day = 6500;
        temperature_night = 4000;
      };

      system.monitor = {
        enabled = true;
        cpu_usage_activity_threshold = 80;
        cpu_usage_critical_threshold = 90;
        cpu_temp_activity_threshold = 80;
        cpu_temp_critical_threshold = 90;
        ram_pct_activity_threshold = 80;
        ram_pct_critical_threshold = 90;
        swap_pct_activity_threshold = 80;
        swap_pct_critical_threshold = 90;
        disk_used_pct_activity_threshold = 80;
        disk_used_pct_critical_threshold = 90;
      };

      dock.enabled = false;
      desktop_widgets.enabled = false;

      idle.behavior = {
        lock = {
          enabled = false;
          timeout = 660;
          action = "lock";
        };
        screen-off = {
          enabled = false;
          timeout = 600;
          action = "screen_off";
        };
      };
    };
  };
}
