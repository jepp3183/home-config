{config, pkgs, ...}:
let
  toLua = str: "lua << EOF\n${str}\nEOF\n";
  toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
in
{
  home.packages = with pkgs; [
    # LSP
    pyright
    ruff
    lua-language-server
    nil
    typst-lsp
    ansible-language-server
    ansible-lint
    yaml-language-server
    docker-compose-language-service
    dockerfile-language-server-nodejs
    ccls
  ];

  programs.neovim = {
   enable = true;  
   defaultEditor = true;
   viAlias = true;
   vimAlias = true;
   vimdiffAlias = true;
   extraLuaConfig = ''
    ${builtins.readFile ./basics.lua}
    ${builtins.readFile ./lsp_config.lua}
    ${builtins.readFile ./mappings.lua}
   '';
   
   plugins = with pkgs.vimPlugins; [
    vim-surround
    vim-repeat
    vim-unimpaired
    vim-fugitive
    nvim-web-devicons
    vim-signature
    plenary-nvim
    telescope-fzf-native-nvim 
    nvim-lspconfig
    cmp-nvim-lsp
    nvim-cmp
    luasnip
    cmp_luasnip
    cmp-buffer
    cmp-async-path
    # mason-nvim
    # mason-lspconfig-nvim
    null-ls-nvim
    dressing-nvim
    ansible-vim
    typst-vim

    { plugin = lsp_lines-nvim; config = toLua ''require('lsp_lines').setup()'';}
    { plugin = which-key-nvim; config = toLua ''require("which-key").setup()'';}
    { plugin = better-escape-nvim; config = toLua ''require("better_escape").setup()''; }
    { plugin = guess-indent-nvim; config = toLua ''require("guess-indent").setup()''; }
    { plugin = nvim-colorizer-lua; config = toLua ''require("colorizer").setup()''; }
    { plugin = nvim-autopairs; config = toLua ''require("nvim-autopairs").setup()''; }
    { plugin = comment-nvim; config = toLua ''require("Comment").setup()''; }
    { plugin = gitsigns-nvim; config = toLua ''require("gitsigns").setup()''; }
    { plugin = toggleterm-nvim; config = toLua ''require('toggleterm').setup{} ''; }

    {
      plugin = base16-nvim;
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
              lualine_a = {
               {'buffers',
                symbols = {
                 modified = ' ●',      -- Text to show when the buffer is modified
                 alternate_file = "", -- Text to show to identify the alternate file
                 directory =  '',
                }
                }

              },
              lualine_b = {},
              lualine_c = {},
              lualine_x = {},
              lualine_y = {},
              lualine_z = {
               {'filename', path = 1}
              }
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
            },
            window = {
                mappings = {
                    ["l"] = "toggle_node",
                    ["h"] = "close_node",
                },
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
          },
          highlight = {
          enable = true,
          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
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
            }
          }
        }
        require('telescope').load_extension('fzf')
      '';
    }
   ];
  };
}
