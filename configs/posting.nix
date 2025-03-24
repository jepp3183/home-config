{inputs, config, pkgs, ...}:
{
    home.packages = with pkgs; [
        posting
    ];


    home.file."/home/jeppe/.local/share/posting/themes/default.yaml" = {
        text = with config.colorscheme.palette; /* yaml */ ''
            name: default  # use this name in your config file
            primary: '#4e78c4'  # buttons, fixed table columns
            secondary: '#f39c12'  # method selector, some minor labels
            accent: '#e74c3c'  # header text, scrollbars, cursors, focus highlights
            background: '#0e1726' # background colors
            surface: '#17202a'  # panels, etc
            error: '#e74c3c'  # error messages
            success: '#2ecc71'  # success messages
            warning: '#f1c40f'  # warning messages
        '';
    };
}
