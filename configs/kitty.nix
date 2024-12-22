{pkgs, config, ...}:
with config.colorScheme.palette; {
  home.file.".config/kitty/kitty.conf" = {
    executable = false;
    text = ''
    font_family CaskaydiaCove Nerd Font Mono
    font_size 13

    shell fish
    shell_integration no-rc

    confirm_os_window_close 0
    hide_window_decorations yes

    touch_scroll_multiplier 2.0
    scrollback_lines 10000
    scrollback_pager_history_size 10
    enable_audio_bell no

    # NOTE: edit command with alt+e! this is a fish function
    map ctrl+c copy_or_interrupt
    map ctrl+shift+h show_scrollback

    background #${base00}
    foreground #${base05}
    selection_background #${base05}
    selection_foreground #${base00}
    url_color #${base04}
    cursor #${base05}
    active_border_color #${base03}
    inactive_border_color #${base01}
    active_tab_background #${base00}
    active_tab_foreground #${base05}
    inactive_tab_background #${base01}
    inactive_tab_foreground #${base04}
    tab_bar_background #${base01}

    color0 #${base00}
    color1 #${base08}
    color2 #${base0B}
    color3 #${base0A}
    color4 #${base0D}
    color5 #${base0E}
    color6 #${base0C}
    color7 #${base05}

    color8 #${base03}
    color9 #${base09}
    color10 #${base01}
    color11 #${base02}
    color12 #${base04}
    color13 #${base06}
    color14 #${base0F}
    color15 #${base07}
      '';
  };
}



