{config, pkgs, ...}:
let
  toLua = str: "lua << EOF\n${str}\nEOF\n";
  toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
in
{
  programs.neovim = {
   enable = true;  
   defaultEditor = true;
   viAlias = true;
   vimAlias = true;
   vimdiffAlias = true;
   # withNodeJs = true;
   coc = {
    enable = true;
    settings = builtins.readFile ./coc-settings.json; 
    pluginConfig = builtins.readFile ./coc.vim;
   };
   extraLuaConfig = ''
    vim.opt.number = true
    vim.opt.cursorline = true
    vim.opt.relativenumber = true
    vim.opt.tabstop = 4
    vim.opt.shiftwidth = 4
    vim.opt.expandtab = true
    vim.opt.autoindent = true
    vim.opt.termguicolors = true
    vim.opt.hidden = true
    vim.opt.splitright = true
    vim.opt.splitbelow = true
    vim.opt.wrap = false
    vim.opt.ignorecase = true
    vim.opt.smartcase = true
    vim.opt.scrolloff = 8
    vim.opt.mouse = "a"

    vim.g.typst_pdf_viewer = "zathura"

    -- For which-key:
    vim.o.timeout = true
    vim.o.timeoutlen = 300

    ${builtins.readFile ./mappings.lua}
   '';
   
   plugins = with pkgs.vimPlugins; [

    copilot-vim
    vim-nix
    vim-surround
    vim-repeat
    vim-unimpaired
    nvim-web-devicons
    vim-signature
    plenary-nvim
    telescope-fzf-native-nvim 
    telescope-coc-nvim
    typst-vim

    { plugin = which-key-nvim; config = toLua ''require("which-key").setup()'';}
    { plugin = better-escape-nvim; config = toLua ''require("better_escape").setup()''; }
    { plugin = guess-indent-nvim; config = toLua ''require("guess-indent").setup()''; }
    { plugin = nvim-colorizer-lua; config = toLua ''require("colorizer").setup()''; }
    { plugin = nvim-autopairs; config = toLua ''require("nvim-autopairs").setup()''; }
    { plugin = comment-nvim; config = toLua ''require("Comment").setup()''; }

    {
      plugin = nvim-base16;
      config = with config.colorScheme.palette; toLua ''
        require('base16-colorscheme').setup({
            base00 = '#${base00}', base01 = '#${base01}', base02 = '#${base02}', base03 = '#${base03}',
            base04 = '#${base04}', base05 = '#${base05}', base06 = '#${base06}', base07 = '#${base07}',
            base08 = '#${base08}', base09 = '#${base09}', base0A = '#${base0A}', base0B = '#${base0B}',
            base0C = '#${base0C}', base0D = '#${base0D}', base0E = '#${base0E}', base0F = '#${base0F}',
        })
      '';
    }
    {
      plugin = toggleterm-nvim;
      config = toLua ''
        require('toggleterm').setup{
        open_mapping = [[<c-t>]],
        size =  function(term)
          if term.direction == "horizontal" then
            return 20
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        direction = 'float'
      }
      '';
    }
    {
      plugin = leap-nvim;
      config = toLua ''
        require("leap").add_default_mappings()
        require("leap").setup {
          highlight_unlabeled = true;
        }
      '';
    }
    {
      plugin = lualine-nvim;
      config = toLua ''
        require('lualine').setup {
            options = {
                theme = 'base16',
            },
            tabline = {
              lualine_a = {'buffers'},
              lualine_b = {},
              lualine_c = {},
              lualine_x = {},
              lualine_y = {},
              lualine_z = {'tabs'}
            }
        }
        '';
    }
    {
      plugin = neo-tree-nvim;
      config = toLua ''
        require("neo-tree").setup({
            source_selector = {
                winbar = true
            }
        })
      '';
    }
    {
      plugin = nvim-treesitter.withAllGrammars;
      config = toLua ''
        require'nvim-treesitter.configs'.setup {
          autotag = {
            enable = true,
          }
        }
      '';
    }
    {
      plugin = telescope-nvim;
      config = toLua ''
        local telescope = require('telescope')
        require('telescope').setup{
          defaults = {
            mappings = {
              i = {
                  ["<Esc>"] = require('telescope.actions').close,
                  ["<C-j>"] = require('telescope.actions').move_selection_next,
                  ["<C-k>"] = require('telescope.actions').move_selection_previous,
                  },
            }
          },
          pickers = {
            find_files = {
                hidden = true,
                file_ignore_patterns = { "node_modules", ".git/" }
            }
          },
          extensions = {
            fzf = {
              fuzzy = true,                    -- false will only do exact matching
              override_generic_sorter = true,  -- override the generic sorter
              override_file_sorter = true,     -- override the file sorter
              case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                               -- the default case_mode is "smart_case"
            }
          }
        }
        require('telescope').load_extension('fzf')
        require('telescope').load_extension('coc')
      '';
    }
   ];
  };
}
