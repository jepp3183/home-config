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
    elixir-ls
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
    nvim-web-devicons
    vim-signature
    plenary-nvim
    nui-nvim
    telescope-fzf-native-nvim 
    nvim-lspconfig
    cmp-nvim-lsp
    nvim-cmp
    luasnip
    cmp_luasnip
    cmp-buffer
    cmp-async-path
    dressing-nvim
    ansible-vim
    typst-vim
    diffview-nvim


    { plugin = lsp_lines-nvim; config = toLua ''require('lsp_lines').setup()'';}
    { plugin = which-key-nvim; config = toLua ''require("which-key").setup()'';}
    { plugin = guess-indent-nvim; config = toLua ''require("guess-indent").setup()''; }
    { plugin = nvim-colorizer-lua; config = toLua ''require("colorizer").setup()''; }
    { plugin = gitsigns-nvim; config = toLua ''require("gitsigns").setup()''; }
    { plugin = neogit; config = toLua ''require("neogit").setup()''; }
    { plugin = yazi-nvim; config = toLua ''require("yazi").setup()''; }

    { plugin = noice-nvim; config = toLua ''
        require("noice").setup({
          lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
              ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
              ["vim.lsp.util.stylize_markdown"] = true,
              ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
            },
          },
          -- you can enable a preset for easier configuration
          presets = {
            bottom_search = true, -- use a classic bottom cmdline for search
            command_palette = true, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = false, -- add a border to hover docs and signature help
          },
        })
    ''; }

    { plugin = rustaceanvim; config = toLua ''
        vim.g.rustaceanvim = {
          tools = {
            float_win_config = {
              border = 'rounded',
            }
          }
        }
    ''; }

    { plugin = trouble-nvim; config = toLua ''
        require("trouble").setup {
                modes = {
                    diagnostics = { -- Configure symbols mode
                        win = {
                            type = "split",     -- split window
                            relative = "win",   -- relative to current window
                            size = 0.4,         -- 30% of the window
                        },
                    },
                },
            }
    '';}

    { plugin = nvim-treesitter-textobjects; config = toLua ''
        require'nvim-treesitter.configs'.setup {
            textobjects = {
                select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                        },
                        selection_modes = {
                            ['@parameter.outer'] = 'v', -- charwise
                            ['@function.outer'] = 'V', -- linewise
                        },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                    },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                    },
                },
                lsp_interop = {
                  enable = true,
                  border = 'rounded',
                  floating_preview_opts = {},
                  peek_definition_code = {
                    ["<leader>df"] = "@function.outer",
                  },
                },
            }
        } 
    '';}

    { plugin = markview-nvim; config = toLua ''
        require("markview").setup({
            modes = { "n", "i", "no", "c" },
            hybrid_modes = { "i" },

            -- This is nice to have
            callbacks = {
                on_enable = function (_, win)
                    vim.wo[win].conceallevel = 2;
                    vim.wo[win].concealcursor = "nc";
                end
            }
        })
    '';}

    { plugin = better-escape-nvim; config = toLua ''
        require("better_escape").setup {
            timeout = vim.o.timeoutlen,
            default_mappings = true,
            mappings = { t = { j = { k = false, j = false, }}}
        }
    ''; }

    { plugin = mini-nvim; config = toLua ''
      require("mini.bufremove").setup()
      require("mini.comment").setup()
      require("mini.pairs").setup()
      require("mini.move").setup()
      require("mini.splitjoin").setup()
      require("mini.starter").setup({
        evaluate_single = true
      })

      require("mini.sessions").setup({
        autoread = true,
      })

      require("mini.indentscope").setup({
        draw = {
          delay = 0,
          animation = require("mini.indentscope").gen_animation.none(),
        }
      })
    ''; }

    { plugin = toggleterm-nvim; config = toLua ''
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
    ''; }

    { plugin = copilot-lua; config = toLua ''
        require('copilot').setup({
            suggestion = {
                auto_trigger = true,
                keymap = {
                    accept = '<C-l>',
                },
            },
            panel = {
                auto_refresh = true,
                layout = {
                    position = 'right',
                },
            },
            copilot_node_command = '${pkgs.nodejs}/bin/node',
        })
    '';
    }

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
            sections = {
                lualine_a = {'mode'},
                lualine_b = {'branch', 'diff', 'diagnostics'},
                lualine_c = {'filename'},
                lualine_x = {'encoding', 'fileformat', 'filetype'},
                lualine_y = {'progress'},
                lualine_z = {'location'}
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
