{config, pkgs, ...}:
let
  toLua = str: "lua << EOF\n${str}\nEOF\n";
  # toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
in
{
  home.packages = with pkgs; [
    # LSP
    pyright
    ruff
    lua-language-server
    nil
    # ansible-language-server
    ansible-lint
    yaml-language-server
    docker-compose-language-service
    dockerfile-language-server
    ccls
    elixir-ls
    lldb
    fish-lsp
    tinymist
    harper
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
    ${builtins.readFile ./snippets.lua}
   '';
   
   plugins = with pkgs.vimPlugins; [
    vim-surround
    vim-repeat
    vim-unimpaired
    nvim-web-devicons
    vim-signature
    plenary-nvim
    nui-nvim
    nvim-lspconfig
    luasnip
    dressing-nvim
    ansible-vim
    diffview-nvim
    nvim-notify
    blink-cmp
    cellular-automaton-nvim

    { plugin = typst-preview-nvim; config = toLua /* lua */ ''require('typst-preview').setup()''; }
    { plugin = guess-indent-nvim; config = toLua /* lua */ ''require("guess-indent").setup()''; }
    { plugin = nvim-colorizer-lua; config = toLua /* lua */ ''require("colorizer").setup()''; }
    { plugin = gitsigns-nvim; config = toLua /* lua */ ''require("gitsigns").setup()''; }
    { plugin = neogit; config = toLua /* lua */ ''require("neogit").setup()''; }
    { plugin = yazi-nvim; config = toLua /* lua */ ''require("yazi").setup()''; }
    { plugin = harpoon2; config = toLua /* lua */ ''require("harpoon").setup()'';}

    neotest-elixir
    { plugin = neotest; config = toLua /* lua */ ''
      vim.api.nvim_create_autocmd("FileType", {
          pattern = "neotest-*",
          callback = function()
              vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close!<CR>", { noremap = true, silent = true })
          end
      })
      require("neotest").setup({
          adapters = {
              require("neotest-elixir")({})
          },
      })
    '';}

    { plugin = which-key-nvim; config = toLua /* lua */ ''
      require("which-key").setup {
          preset = "modern",
          delay = 100,
      }
    '';}

    { plugin = auto-session; config = toLua /* lua */ ''
        require("auto-session").setup {
          suppressed_dirs = { "~/", "~/proj", "~/Downloads", "/"},
        }
    '';}

    { plugin = fzf-lua; config = toLua /* lua */ ''
      local actions = require("fzf-lua").actions
      require("fzf-lua").setup({
          winopts = {
              preview = {
                  delay = 0,
              }
          },
          actions = {
            files = {
              ["enter"] = actions.file_edit,
              ["alt-q"] = actions.file_sel_to_qf,
              ["ctrl-s"] = actions.file_split,
              ["ctrl-v"] = actions.file_vsplit,
            }
          }
      })
    ''; }

    { plugin = snacks-nvim; config = toLua /* lua */ ''
      require("snacks").setup({
        gitbrowse = {enabled = true},
        lazygit = {enabled = true},
        input = {enabled = true},
        explorer = {enabled = true},
        indent = {
          enabled = true,
          animate = {
            duration = {
              step = 10,
              total = 250,
            }
          }
        },
        scroll = {
          enabled = true,
          animate = {
            duration = {
              step = 7,
              total = 150,
            }
          }
        },
        dashboard = {
            enabled = true,
            keys = {
              { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
              { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
              { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
              { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
              { icon = " ", key = "h", desc = "Config", action = ":lua require('fzf-lua').files({cwd = '~/.config/home-manager})" },
              { icon = " ", key = "q", desc = "Quit", action = ":qa" },
            },
            sections = {
                { section = "keys", gap = 1, padding = 1 },
                { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
                { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
                {
                  pane = 2,
                  icon = " ",
                  title = "Git Status",
                  section = "terminal",
                  enabled = function()
                    return Snacks.git.get_root() ~= nil
                  end,
                  cmd = "git status --short --branch --renames",
                  height = 5,
                  padding = 1,
                  ttl = 5 * 60,
                  indent = 3,
                },
              },
        },
      })
    ''; }
      

    { plugin = nvim-autopairs; config = toLua /* lua */ ''
      local npairs = require('nvim-autopairs')
      npairs.setup()

      local endwise = require('nvim-autopairs.ts-rule').endwise
      npairs.add_rules(
        {
          endwise('do$', 'end', 'elixir', nil) 
        }
      )
    '';}

    { plugin = nvim-dap-ui; config = toLua /* lua */ ''require('dapui').setup()''; }
    { plugin = nvim-dap-virtual-text; config = toLua /* lua */ ''require('nvim-dap-virtual-text').setup()''; }
    { plugin = nvim-dap; config = toLua /* lua */ ''
        local dap = require('dap')
        local ui = require('dapui')

        dap.adapters.lldb = {
          type = 'executable',
          command = '${pkgs.lldb}/bin/lldb-dap', -- adjust as needed, must be absolute path
          name = 'lldb'
        }

        dap.configurations.rust = {
          {
            name = 'Launch',
            type = 'lldb',
            request = 'launch',
            program = function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = "''${workspaceFolder}",
            stopOnEntry = false,
            args = {},
          },
        }

        dap.adapters.mix_task = {
          type = 'executable',
          command = "${pkgs.elixir-ls}/lib/debug_adapter.sh",
          args = {}
        }

        dap.configurations.elixir = {
          {
            type = "mix_task",
            name = "mix test",
            task = 'test',
            taskArgs = {"--trace"},
            request = "launch",
            startApps = true, -- for Phoenix projects
            projectDir = "''${workspaceFolder}",
            requireFiles = {
              "test/**/test_helper.exs",
              "test/**/*_test.exs"
            }
          },
          {
            type = "mix_task",
            name = "mix run --no-halt",
            task = 'run',
            taskArgs = {"--no-halt"},
            request = "launch",
            startApps = false, -- for Phoenix projects
            projectDir = "''${workspaceFolder}",
          },
        }

        dap.listeners.before.attach.dapui_config = function()
          ui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
          ui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
          ui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
          ui.close()
        end
    ''; }

    { plugin = noice-nvim; config = toLua /* lua */ ''
        require("noice").setup({
          lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
              ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
              ["vim.lsp.util.stylize_markdown"] = true,
              ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
            },
          },
          view = "mini",
          -- you can enable a preset for easier configuration
          presets = {
            bottom_search = true, -- use a classic bottom cmdline for search
            command_palette = true, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = true, -- add a border to hover docs and signature help
          },
          routes = {
              {
                filter = {
                  event = "msg_show",
                  kind = "",
                  find = "written",
                },
                opts = { skip = true },
              },
            },
        })
    ''; }

    { plugin = rustaceanvim; config = toLua /* lua */ ''
        vim.g.rustaceanvim = {
          tools = {
            float_win_config = {
              border = 'rounded',
            }
          }
        }
    ''; }

    { plugin = trouble-nvim; config = toLua /* lua */ ''
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

    { plugin = nvim-treesitter-context; config = toLua /* lua */ ''
      require("treesitter-context").setup{
        line_numbers = false,
        multiwindow = true,
        mode = 'cursor',
        separator = nil,
        multiline_threshold = 1,
      }
    '';}

    { plugin = nvim-treesitter-textobjects; config = toLua /* lua */ ''
        require'nvim-treesitter.configs'.setup {
          incremental_selection = {  
            enable = true,  
            keymaps = {  
              node_incremental = "v",  
              node_decremental = "V",  
            },  
          },
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

    { plugin = markview-nvim; config = toLua /* lua */ ''
        require("markview").setup({
            preview = {
              modes = { "n", "i", "no", "c" },
              hybrid_modes = { "i" },
              filetypes = { "markdown" },
              ignore_buftypes = {},
              -- This is nice to have
              callbacks = {
                  on_enable = function (_, win)
                      vim.wo[win].conceallevel = 2;
                      vim.wo[win].concealcursor = "nc";
                  end
              }
            },
        })
    '';}

    { plugin = better-escape-nvim; config = toLua /* lua */ ''
        require("better_escape").setup {
            timeout = vim.o.timeoutlen,
            default_mappings = true,
            mappings = { 
                t = { j = { k = false, j = false}},
                v = { j = { k = false, j = false}},
                x = { j = { k = false, j = false}}
            }
        }
    ''; }

    { plugin = mini-nvim; config = toLua /* lua */ ''
      require("mini.bufremove").setup()
      require("mini.comment").setup()
      require("mini.move").setup()
      require("mini.splitjoin").setup()
      require('mini.files').setup()
    ''; }

    { plugin = copilot-lua; config = toLua /* lua */ ''
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
      config = with config.colorScheme.palette; toLua /* lua */ ''
        require('base16-colorscheme').setup({
            base00 = '#${base00}', base01 = '#${base01}', base02 = '#${base02}', base03 = '#${base03}',
            base04 = '#${base04}', base05 = '#${base05}', base06 = '#${base06}', base07 = '#${base07}',
            base08 = '#${base08}', base09 = '#${base09}', base0A = '#${base0A}', base0B = '#${base0B}',
            base0C = '#${base0C}', base0D = '#${base0D}', base0E = '#${base0E}', base0F = '#${base0F}',
        })
      '';
    }
    {
      plugin = flash-nvim;
      config = toLua /* lua */ ''
        vim.cmd[[ highlight FlashLabel guibg=#ff0000 guifg=#ffffff ]]
        require("flash").setup({
            modes = {
              search = {enabled = false},
            },
        })
      '';
    }

    { plugin = bufferline-nvim; config = toLua /* lua */ ''
        require("bufferline").setup {
            options = {
                diagnostics = "nvim_lsp",
                close_command = function(n) Snacks.bufdelete(n) end,
                diagnostics_indicator = function(count, level, diagnostics_dict, context)
                  local icon = level:match("error") and " " or " "
                  return " " .. icon .. count
                end
            }
        }
        '';
    }

    { plugin = tiny-inline-diagnostic-nvim; config = toLua /* lua */ ''
      require("tiny-inline-diagnostic").setup({
          preset = "amongus",
          transparent_bg = false,
          options = {
            multilines = {
              enabled = true
            } 
          }
      })
      vim.diagnostic.config({
        virtual_text = false,
      })
    '';}

    {
      plugin = lualine-nvim;
      config = toLua /* lua */ ''
        require('lualine').setup {
            extensions = {'fzf'},
            options = {
                component_separators = { left = "|", right = "|" },
                section_separators = { left = "", right = "" },
                globalstatus = true,
            },
            sections = {
                lualine_a = {'mode'},
                lualine_b = {'branch', 'diff', 'diagnostics'},
                lualine_c = {{'filename', path=1}},
                lualine_x = {
                    { 
                        require("noice").api.statusline.mode.get,
                        cond = require("noice").api.statusline.mode.has,
                        color = { fg = "#cc0000" }, 
                    },
                    'encoding',
                    'fileformat',
                    'filetype'
                },
                lualine_y = {'progress'},
                lualine_z = {'location'}
            }
        }
        '';
    }
    
    {
      plugin = nvim-treesitter.withAllGrammars;
      config = toLua /* lua */ ''
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
   ];
  };
}
