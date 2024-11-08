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

local yazi = require('yazi')
vim.keymap.set('n', '<C-y>', yazi.yazi, {desc = "Open yazi"})

vim.keymap.set('', '<C-j>', '5j')
vim.keymap.set('', '<C-k>', '5k')
vim.keymap.set('n', '<C-h>', '<cmd>bprev<cr>')
vim.keymap.set('n', '<C-l>', '<cmd>bnext<cr>')
vim.keymap.set('n', '<C-s>', '<cmd>update<cr>')
vim.keymap.set('n', '<M-p>', '<cmd>Copilot panel<CR>')
vim.keymap.set('n', '<C-q>', MiniBufremove.delete, {desc="Close buffer"})

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
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>gc", "<cmd>Neogit commit<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>gl", "<cmd>Neogit pull<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>gp", "<cmd>Neogit push<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns blame<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>gtb", "<cmd>Gitsigns toggle_current_line_blame<cr>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>gB", "<cmd>Telescope git_branches<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>gs", "<cmd>Gitsigns stage_buffer<cr>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>hp", "<cmd>Gitsigns preview_hunk<cr>", {noremap = true, silent = true})
vim.keymap.set("n", "<leader>hb", function() require('gitsigns').blame_line({full = true}) end, {desc = "blame line"})
vim.keymap.set("n", "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>", {noremap = true, silent = true})
vim.keymap.set("n", "]h", "<cmd>Gitsigns next_hunk<cr>", {noremap = true, silent = true})
vim.keymap.set("n", "[h", "<cmd>Gitsigns prev_hunk<cr>", {noremap = true, silent = true})

-- Telescope
vim.keymap.set('n', '<Leader>ff', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n', '<Leader>fg', '<cmd>Telescope live_grep layout_strategy=vertical<cr>')
vim.keymap.set('n', '<Leader>fb', '<cmd>Telescope buffers<cr>')
vim.keymap.set('n', '<Leader>fh', '<cmd>Telescope help_tags<cr>')
vim.keymap.set('n', '<Leader>fk', '<cmd>Telescope keymaps<cr>')
vim.keymap.set('n', '<Leader>fc', '<cmd>Telescope find_files cwd=~/.config/home-manager<cr>')
vim.keymap.set('n', '<Leader>fs', '<cmd>Telescope lsp_document_symbols<cr>')
vim.keymap.set('n', '<Leader>fS', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>')
vim.keymap.set('n', '<Leader>fr', '<cmd>Telescope lsp_references<cr>')
vim.keymap.set('n', '<Leader>fd', '<cmd>Telescope diagnostics<cr>')

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
    vim.keymap.set({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, mkopts("Code action"))
    vim.keymap.set('n', '<leader>ll', _lsp_lines_toggle, mkopts("Toggle lsp_lines"))
    vim.keymap.set('n', '<leader>lf', function()
      vim.lsp.buf.format { async = true }
    end, mkopts("Format buffer"))
  end,
})

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
