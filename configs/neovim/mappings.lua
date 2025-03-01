vim.g.mapleader = ' '
vim.keymap.set('n', 'q:', '<Nop>')
vim.keymap.set('t', '<C-N>', '<C-\\><C-N>')
vim.keymap.set('n', '<C-b>', function()
  require('neo-tree.command').execute({
    action = 'focus',
    source = 'last',
    position = 'current',
  })
end)
vim.keymap.set('n', '-', MiniFiles.open, {desc = "Open mini.files"})

local yazi = require('yazi')
vim.keymap.set('n', '<C-y>', yazi.yazi, {desc = "Open yazi"})

vim.keymap.set('', '<C-j>', '5j')
vim.keymap.set('', '<C-k>', '5k')
vim.keymap.set('n', '<C-h>', vim.cmd.bprev)
vim.keymap.set('n', '<C-l>', vim.cmd.bnext)
vim.keymap.set('n', '<C-s>', vim.cmd.update)
vim.keymap.set('n', '<C-q>', MiniBufremove.delete, {desc="Close buffer"})

-- Harpoon
local harpoon = require('harpoon')
vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end)

-- -- Folding
-- local function cond_fold()
--   if not vim.opt.foldenable then
--     vim.api.nvim_set_option_value('foldenable', true, {scope='local'})
--   end
--
--   vim.api.nvim_feedkeys('za', 'n', false)
-- end
-- vim.opt.foldenable = false
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.opt.foldtext = ""
-- vim.opt.foldlevel = 99
-- vim.keymap.set('n', '<tab>',cond_fold)

-- Sessions
local function write_session()
  local session = vim.fn.input("Session name: ")
  if session == "" then
    return
  end
  MiniSessions.write(session)
end
vim.keymap.set('n', '<Leader>sw', write_session, {desc="Write session"})
vim.keymap.set('n', '<Leader>sl', MiniSessions.select, {desc="Load session"})

-- yank to system clipboard!
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Git
vim.keymap.set("n", "<leader>ng", "<cmd>Neogit<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>gg", function () Snacks.lazygit() end, {noremap = true, silent = true, desc = "Lazygit"})
vim.keymap.set("n", "<leader>go", function () Snacks.gitbrowse() end, {noremap = true, silent = true, desc = "Git Browse"})
vim.keymap.set("n", "<leader>gc", "<cmd>Neogit commit<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>gb", function() require('gitsigns').blame_line({full = true}) end, {desc = "blame line"})
vim.keymap.set("n", "<leader>gB", "<cmd>Gitsigns blame<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>gtb", "<cmd>Gitsigns toggle_current_line_blame<cr>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>gs", "<cmd>Gitsigns stage_buffer<cr>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", {noremap = true, silent = true})
vim.keymap.set("n", "]h", "<cmd>Gitsigns next_hunk<cr>", {noremap = true, silent = true})
vim.keymap.set("n", "[h", "<cmd>Gitsigns prev_hunk<cr>", {noremap = true, silent = true})

-- Ai Shit
vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])

-- Telescope
local fl = require('fzf-lua')
vim.keymap.set('n', '<Leader>ff', fl.files, {desc="Find files"})
vim.keymap.set('n', '<Leader>fg', function()
  fl.live_grep_glob({
    winopts={
      preview={
        layout='vertical',
        vertical='up:50%',
      }
    }
  })
end, {desc="Live grep"})
vim.keymap.set('n', '<Leader>fb', fl.buffers, {desc="Buffers"})
vim.keymap.set('n', '<Leader>fh', fl.help_tags, {desc="Help tags"})
vim.keymap.set('n', '<Leader>fk', fl.keymaps, {desc="Keymaps"})
vim.keymap.set('n', '<Leader>fc', function() fl.files({ cwd = "~/.config/home-manager" }) end, {desc="Config files"})
vim.keymap.set('n', '<Leader>fs', fl.lsp_document_symbols, {desc="Document symbols"})
vim.keymap.set('n', '<Leader>fS', fl.lsp_workspace_symbols, {desc="Workspace symbols"})
vim.keymap.set('n', '<Leader>fr', fl.lsp_references, {desc="References"})
vim.keymap.set('n', '<Leader>fd', fl.diagnostics_document, {desc="Diagnostics"})

-- Diagnostics
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', '<cmd>Trouble diagnostics toggle<cr>', {desc="Set diagnostic loclist"})
vim.keymap.set('n', '<Leader>ld', vim.diagnostic.open_float, {desc="Open diagnostic float"})

-- LSP Shit
local lsp_lines = false
local _lsp_lines_toggle = function()
  lsp_lines = not lsp_lines
  if lsp_lines then
    vim.diagnostic.config({
      virtual_text = false,
      virtual_lines = true,
    })
  else
    vim.diagnostic.config({
      virtual_text = true,
      virtual_lines = false,
    })
  end
end
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)

    local function mkopts(desc)
      return { buffer = ev.buf, desc=desc }
    end

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, mkopts("Go to declaration"))
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, mkopts("Go to definition"))
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, mkopts("Hover info"))
    vim.keymap.set('n', '<leader>lR', vim.lsp.buf.rename, mkopts("Rename in buffer"))
    vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, mkopts("Signature help"))
    vim.keymap.set({ 'n', 'v' }, '<leader>la', fl.lsp_code_actions, mkopts("Code action"))
    vim.keymap.set('n', '<leader>ll', _lsp_lines_toggle, mkopts("Toggle lsp_lines"))
    vim.keymap.set('n', '<leader>lf', function()
      vim.lsp.buf.format { async = true }
    end, mkopts("Format buffer"))
  end,
})

-- DAP
local dap = require('dap')
vim.keymap.set('n', '<Leader>rr', function ()
  fl.dap_configurations({
    winopts={
      preview={
        layout='vertical',
        vertical='up:50%',
      }
    }
  })
end, {desc="DAP configurations"})
vim.keymap.set('n', '<Leader>rf', fl.dap_commands, {desc="DAP commands"})
vim.keymap.set('n', '<Leader>rb', dap.toggle_breakpoint)
vim.keymap.set("n", "<space>rc", dap.run_to_cursor)
vim.keymap.set("n", "<space>?", function()
  require("dapui").eval(nil, { enter = true })
end)

-- Surround remapping to fix interference with leap
vim.g.surround_no_mappings = 1
vim.keymap.set('n', 'ds', '<Plug>Dsurround')
vim.keymap.set('n', 'cs', '<Plug>Csurround')
vim.keymap.set('n', 'cS', '<Plug>CSurround')
vim.keymap.set('n', 'ys', '<Plug>Ysurround')
vim.keymap.set('n', 'yS', '<Plug>YSurround')
vim.keymap.set('n', 'yss', '<Plug>Yssurround')
vim.keymap.set('n', 'ySs', '<Plug>YSsurround')
vim.keymap.set('n', 'ySS', '<Plug>YSsurround')
vim.keymap.set('x', 'gs', '<Plug>VSurround')
vim.keymap.set('x', 'gS', '<Plug>VgSurround')

-- Flash.nvim
vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
-- vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
-- vim.keymap.set("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })
