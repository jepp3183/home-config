{inputs, config, pkgs, ...}:
{
    home.packages = with pkgs; [
        posting
    ];

    
    home.file."/home/jeppe/.config/posting/config.yaml" = {
        text = /* yaml */ ''
            theme: default
            layout: horizontal
        '';
    };


    home.file."/home/jeppe/.local/share/posting/themes/default.yaml" = {
        text = with config.colorscheme.palette; /* yaml */ ''
            name: default  # use this name in your config file
            primary: '#${base0D}'  # buttons, fixed table columns (functions/methods color)
            secondary: '#${base09}'  # method selector, some minor labels (integers/constants color)
            accent: '#${base08}'  # header text, scrollbars, cursors, focus highlights (variables/tags color)
            background: '#${base00}' # background colors
            surface: '#${base01}'  # panels, etc (lighter background color)
            error: '#${base08}'  # error messages (using same as accent - variables/red color)
            success: '#${base0B}'  # success messages (strings/diff inserted - typically green)
            warning: '#${base0A}'  # warning messages (classes/search highlight - typically yellow)
        '';
    };
}
