{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom;
  output-panel = pkgs.vimUtils.buildVimPlugin {
    pname = "output-panel.nvim";
    version = "1.0.1";
    src = pkgs.fetchFromGitHub {
      owner = "mhanberg";
      repo = "output-panel.nvim";
      rev = "4773c0ed7549f7621a5c2cd1e3d3387d836cff9a";
      hash = "sha256-iVWbnTCPKoyTPnY+tF2BkJwOF7MyS4hiVjHCqJpmiO4=";
    };
    meta.homepage = "https://github.com/mhanberg/output-panel.nvim";
    meta.hydraPlatforms = [ ];
  };
  copilot-lua = pkgs.vimPlugins.copilot-lua.overrideAttrs (_: {
    src = pkgs.fetchFromGitHub {
      owner = "zbirenbaum";
      repo = "copilot.lua";
      rev = "9d391a02dc0281713cbb7c3bc87cdd38287b92eb"; # v3.0.4
      hash = "sha256-kDQOm7/N6T7wOw1JlkcxNMnQrDE4oTRyGCZkvT8HZQw=";
    };
  });
  lazygitEdit = pkgs.writeShellScript "lazygit-nvim-edit" ''
    file="$1"
    line="''${2:-}"

    if [ -z "''${NVIM:-}" ]; then
      if [ -n "$line" ]; then
        exec nvim "+$line" -- "$file"
      fi
      exec nvim -- "$file"
    fi

    nvim --server "$NVIM" --remote-send "q"
    nvim --server "$NVIM" --remote "$file"
    if [ -n "$line" ]; then
      nvim --server "$NVIM" --remote-send ":$line<CR>"
    fi
  '';
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
    gopls
    typescript-language-server

    tree-sitter
    gcc
  ];

  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    initLua = ''
      ${builtins.readFile ./basics.lua}
      ${builtins.readFile (pkgs.replaceVars ./lsp_config.lua { elixirLsCmd = cfg.elixirLsCmd; })}
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
      nvim-notify
      blink-cmp
      cellular-automaton-nvim
      nvim-treesitter-textobjects

      {
        plugin = snacks-nvim;
        type = "lua";
        config = /* lua */ ''
          require("snacks").setup({
            gitbrowse = {enabled = true},
            lazygit = {
              enabled = true,
              config = {
                os = {
                  -- like the "nvim-remote" preset, but opens the file in the
                  -- current window instead of a new tab
                  edit = '${lazygitEdit} {{filename}}',
                  editAtLine = '${lazygitEdit} {{filename}} {{line}}',
                  editAtLineAndWait = 'nvim +{{line}} -- {{filename}}',
                },
              },
            },
            input = {enabled = true},
            explorer = {enabled = false},
            picker = {
              enabled = true,
              matcher = {
                frecency = true
              },
              win = {
                input = {
                  keys = {
                    ["<Esc>"] = { "close", mode = { "n", "i" } },
                  },
                },
              },
              layouts = {
                telescope = {
                  layout = {
                    box = "vertical",
                    { win = "input", height = 1, border = "bottom" },
                    {
                      box = "horizontal",
                      { win = "list", width = 0.4, border = "right" },
                      { win = "preview", title = "{preview}", border = "none" },
                    },
                  },
                },
              },
            },
            indent = {
              enabled = true,
              animate = {
                duration = {
                  step = 10,
                  total = 250,
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
                  { icon = " ", key = "h", desc = "Config", action = ":lua Snacks.picker.pick('files', {cwd = '~/.config/home-manager'})" },
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
        '';
      }

      {
        plugin = neo-tree-nvim;
        type = "lua";
        config = /* lua */ ''
          require("neo-tree").setup({
            close_if_last_window = true,
            popup_border_style = "rounded",
            enable_git_status = true,
            enable_diagnostics = true,
            sources = { "filesystem", "buffers", "git_status" },
            source_selector = { winbar = true },
            event_handlers = {
              {
                -- neo-tree runs `git status --ignored=traditional`, which with
                -- --untracked-files=all lists every file inside ignored dirs
                -- (node_modules, _build, ...). "matching" lists only the ignored
                -- dir itself, which is all neo-tree needs to dim/hide it.
                -- git rejects "matching" together with --untracked-files=no
                -- (neo-tree's fast pre-scan), so leave that invocation alone.
                event = "before_git_status",
                handler = function(args)
                  if vim.tbl_contains(args.status_args, "--untracked-files=no") then
                    return
                  end
                  for i, arg in ipairs(args.status_args) do
                    if arg == "--ignored=traditional" then
                      args.status_args[i] = "--ignored=matching"
                    end
                  end
                end,
              },
            },
            commands = {
              system_open = function(state)
                vim.ui.open(state.tree:get_node():get_id())
              end,
            },
            default_component_configs = {
              indent = { with_expanders = true },
              git_status = {
                symbols = {
                  added = "",
                  modified = "",
                  deleted = "✖",
                  renamed = "",
                  untracked = "",
                  ignored = "",
                  unstaged = "",
                  staged = "",
                  conflict = "",
                },
              },
            },
            window = {
              position = "left",
              width = 35,
              mappings = {
                ["l"] = "open",
                ["h"] = "close_node",
                ["P"] = { "toggle_preview", config = { use_float = true } },
                ["Z"] = "close_all_nodes",
                ["o"] = "system_open",
              },
            },
            filesystem = {
              follow_current_file = { enabled = true, leave_dirs_open = true },
              use_libuv_file_watcher = true,
              group_empty_dirs = false,
              hijack_netrw_behavior = "open_default",
              filtered_items = {
                hide_dotfiles = true,
                hide_gitignored = true,
              },
            },
            git_status = {
              window = { position = "left" },
            },
          })
        '';
      }

      {
        plugin = diffview-nvim;
        type = "lua";
        config = /* lua */ ''
          require("diffview").setup({
            enhanced_diff_hl = true,
            view = {
              default = { winbar_info = false },
              merge_tool = { layout = "diff3_mixed", disable_diagnostics = true },
              file_history = { winbar_info = false },
            },
            file_panel = {
              win_config = { position = "left", width = 35 },
            },
          })
        '';
      }
      {
        plugin = output-panel;
        type = "lua";
        config = /* lua */ ''require("output_panel").setup({})'';
      }
      {
        plugin = typst-preview-nvim;
        type = "lua";
        config = /* lua */ "require('typst-preview').setup()";
      }
      {
        plugin = guess-indent-nvim;
        type = "lua";
        config = /* lua */ ''require("guess-indent").setup()'';
      }
      {
        plugin = nvim-colorizer-lua;
        type = "lua";
        config = /* lua */ ''require("colorizer").setup()'';
      }
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = /* lua */ ''
          require("gitsigns").setup({
            signs = {
              add = { text = "▎" },
              change = { text = "▎" },
              delete = { text = "\u{2581}" },
              topdelete = { text = "\u{2594}" },
              changedelete = { text = "▎" },
              untracked = { text = "▎" },
            },
            signs_staged = {
              add = { text = "▎" },
              change = { text = "▎" },
              delete = { text = "\u{2581}" },
              topdelete = { text = "\u{2594}" },
              changedelete = { text = "▎" },
            },
          })
        '';
      }
      {
        plugin = yazi-nvim;
        type = "lua";
        config = /* lua */ ''require("yazi").setup()'';
      }
      {
        plugin = harpoon2;
        type = "lua";
        config = /* lua */ ''require("harpoon").setup()'';
      }

      neotest-elixir
      {
        plugin = neotest;
        type = "lua";
        config = /* lua */ ''
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
        '';
      }

      {
        plugin = which-key-nvim;
        type = "lua";
        config = /* lua */ ''
          require("which-key").setup {
              preset = "modern",
              delay = 100,
          }
        '';
      }

      {
        plugin = auto-session;
        type = "lua";
        config = /* lua */ ''
          require("auto-session").setup {
            suppressed_dirs = { "~/", "~/proj", "~/Downloads", "/"},
          }
        '';
      }

      {
        plugin = nvim-autopairs;
        type = "lua";
        config = /* lua */ ''
          local npairs = require('nvim-autopairs')
          npairs.setup()

          local endwise = require('nvim-autopairs.ts-rule').endwise
          npairs.add_rules(
            {
              endwise('do$', 'end', 'elixir', nil)
            }
          )
        '';
      }

      {
        plugin = nvim-dap-ui;
        type = "lua";
        config = /* lua */ "require('dapui').setup()";
      }
      {
        plugin = nvim-dap-virtual-text;
        type = "lua";
        config = /* lua */ "require('nvim-dap-virtual-text').setup()";
      }
      {
        plugin = nvim-dap;
        type = "lua";
        config = /* lua */ ''
          local dap = require('dap')
          local ui = require('dapui')

          dap.adapters.lldb = {
            type = 'executable',
            command = '${lib.getExe' pkgs.lldb "lldb-dap"}', -- adjust as needed, must be absolute path
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
        '';
      }

      {
        plugin = noice-nvim;
        type = "lua";
        config = /* lua */ ''
          require("noice").setup({
            lsp = {
              -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
              override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
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
        '';
      }

      {
        plugin = rustaceanvim;
        type = "lua";
        config = /* lua */ ''
          vim.g.rustaceanvim = {
            tools = {
              float_win_config = {
                border = 'rounded',
              }
            }
          }
        '';
      }

      {
        plugin = trouble-nvim;
        type = "lua";
        config = /* lua */ ''
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
        '';
      }

      {
        plugin = markview-nvim;
        type = "lua";
        config = /* lua */ ''
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
        '';
      }

      {
        plugin = better-escape-nvim;
        type = "lua";
        config = /* lua */ ''
          require("better_escape").setup {
              timeout = vim.o.timeoutlen,
              default_mappings = true,
              mappings = {
                  t = { j = { k = false, j = false}},
                  v = { j = { k = false, j = false}},
                  x = { j = { k = false, j = false}}
              }
          }
        '';
      }

      {
        plugin = mini-nvim;
        type = "lua";
        config = /* lua */ ''
          require("mini.bufremove").setup()
          require("mini.comment").setup()
          require("mini.move").setup()
          require("mini.splitjoin").setup()
          require('mini.files').setup()
        '';
      }

      {
        plugin = copilot-lua;
        type = "lua";
        config = /* lua */ ''
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
              copilot_node_command = '${lib.getExe' pkgs.nodejs "node"}',
          })
        '';
      }

      {
        plugin = tokyonight-nvim;
        type = "lua";
        config = /* lua */ ''
          require("tokyonight").setup({
            style = "night",
            styles = {
              comments = { italic = true },
              keywords = { italic = true },
              sidebars = "dark",
              floats = "dark",
            },
            sidebars = { "qf", "help", "trouble", "DiffviewFiles", "DiffviewFileHistory", "neotest-summary" },
            lualine_bold = true,
            on_highlights = function(hl, c)
              -- subtle, borderless splits and a quiet line-number gutter
              hl.WinSeparator = { fg = c.bg_highlight }
              hl.LineNr = { fg = c.dark3 }
              hl.CursorLineNr = { fg = c.orange, bold = true }
              -- bufferline: thin indicator, italic active tab like the reference
              hl.BufferLineIndicatorSelected = { fg = c.blue, bg = c.bg }
              hl.BufferLineBufferSelected = { fg = c.fg, bg = c.bg, bold = true, italic = true }
            end,
          })
          vim.cmd.colorscheme("tokyonight")
        '';
      }
      {
        plugin = flash-nvim;
        type = "lua";
        config = /* lua */ ''
          require("flash").setup({
              modes = {
                search = {enabled = false},
              },
          })
        '';
      }

      {
        plugin = bufferline-nvim;
        type = "lua";
        config = /* lua */ ''
          require("bufferline").setup {
              options = {
                  mode = "buffers",
                  themable = true,
                  diagnostics = "nvim_lsp",
                  close_command = function(n) Snacks.bufdelete(n) end,
                  right_mouse_command = function(n) Snacks.bufdelete(n) end,
                  diagnostics_indicator = function(count, level, diagnostics_dict, context)
                    local icon = level:match("error") and "\u{f057} " or "\u{f071} "
                    return " " .. icon .. count
                  end,
                  indicator = { icon = "▎", style = "icon" },
                  separator_style = { "", "" },
                  modified_icon = "\u{25cf}",
                  show_buffer_close_icons = true,
                  show_close_icon = false,
                  show_tab_indicators = true,
                  always_show_bufferline = true,
                  offsets = {
                    { filetype = "DiffviewFiles", text = "Source Control", text_align = "center", separator = true },
                    { filetype = "neo-tree", text = "Explorer", text_align = "center", separator = true },
                    { filetype = "neotest-summary", text = "Tests", text_align = "center", separator = true },
                  },
              }
          }
        '';
      }
      {
        plugin = tiny-inline-diagnostic-nvim;
        type = "lua";
        config = /* lua */ ''
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
        '';
      }

      {
        plugin = lualine-nvim;
        type = "lua";
        config = /* lua */ ''
          require('lualine').setup {
              options = {
                  theme = "tokyonight",
                  component_separators = "",
                  section_separators = "",
                  globalstatus = true,
                  disabled_filetypes = { statusline = { "snacks_dashboard" } },
              },
              sections = {
                  lualine_a = { 'mode' },
                  lualine_b = { 'branch' },
                  lualine_c = {
                      { 'filetype', icon_only = true, padding = { left = 1, right = 0 } },
                      { 'filename', path = 1, symbols = { modified = " \u{25cf}", readonly = " \u{f023}", unnamed = "[No Name]" } },
                  },
                  lualine_x = {
                      {
                          require("noice").api.statusline.mode.get,
                          cond = require("noice").api.statusline.mode.has,
                          color = { fg = "#ff9e64" },
                      },
                      { 'diagnostics', symbols = { error = "\u{f057} ", warn = "\u{f071} ", info = "\u{f05a} ", hint = "\u{f400} " } },
                      { 'diff', symbols = { added = "\u{f0fe} ", modified = "\u{f192} ", removed = "\u{f146} " } },
                  },
                  lualine_y = {
                      { 'encoding', padding = { left = 1, right = 1 } },
                      { 'progress', padding = { left = 1, right = 1 } },
                  },
                  lualine_z = { { 'location', padding = { left = 1, right = 1 } } },
              },
              extensions = { 'trouble', 'quickfix', 'nvim-dap-ui' },
          }
        '';
      }
      {
        plugin = nvim-treesitter-context;
        type = "lua";
        config = /* lua */ ''
          require("treesitter-context").setup{
            line_numbers = false,
            multiwindow = true,
            mode = 'cursor',
            separator = nil,
            multiline_threshold = 1,
          }
        '';
      }

      {
        # plugin = nvim-treesitter;
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = /* lua */ ''
           vim.api.nvim_create_autocmd('FileType', {
            pattern = '*',
            callback = function()
              pcall(vim.treesitter.start)
            end,
          })

          require("nvim-treesitter-textobjects").setup {
            select = {
              lookahead = true,
              selection_modes = {
                ['@parameter.outer'] = 'v',
                ['@function.outer'] = 'V',
              },
            },
            move = {
              set_jumps = true,
            },
          }

          -- textobject select keymaps
          vim.keymap.set({ "x", "o" }, "af", function()
            require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
          end)
          vim.keymap.set({ "x", "o" }, "if", function()
            require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
          end)
          vim.keymap.set({ "x", "o" }, "aa", function()
            require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
          end)
          vim.keymap.set({ "x", "o" }, "ia", function()
            require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
          end)

          -- textobject move keymaps
          vim.keymap.set({ "n", "x", "o" }, "]f", function()
            require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
          end)
          vim.keymap.set({ "n", "x", "o" }, "[f", function()
            require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
          end)
        '';
      }
    ];
  };
}
