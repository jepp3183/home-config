vim.g.mapleader = ' '
vim.keymap.set('i', 'jj', '<Esc>')
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('t', '<C-N>', '<C-\\><C-N>')
-- vim.keymap.set('n', '<Leader>e', ':Neotree source=last focus<CR>')
vim.keymap.set('n', '<C-b>', ':Neotree source=last position=current toggle<CR>')
vim.keymap.set('', '<C-j>', '5j')
vim.keymap.set('', '<C-k>', '5k')
vim.keymap.set('n', '<C-h>', '<cmd>bprev<cr>')
vim.keymap.set('n', '<C-l>', '<cmd>bnext<cr>')
vim.keymap.set('n', '<C-s>', ':w<CR>')
vim.keymap.set('n', '<C-q>', ':bp<bar>sp<bar>bn<bar>bd<CR>')
vim.keymap.set('n', '<M-p>', ':Copilot panel<CR>')

-- Move selection up/down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- yank to system clipboard!
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])


local Terminal  = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = 'float' })
function _lazygit_toggle()
  lazygit:toggle()
end
vim.api.nvim_set_keymap("n", "<leader>gg", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>gdo", ":DiffviewOpen<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>gdc", ":DiffviewClose<CR>", {noremap = true, silent = true})

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
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<Leader>ld', vim.diagnostic.open_float)

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
vim.keymap.set('n', '<Leader>lm', '<cmd>Mason<cr>')
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>lR', vim.lsp.buf.rename, opts)
    vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>ll', _lsp_lines_toggle, opts)
    vim.keymap.set('n', '<leader>lf', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- copilot
-- vim.keymap.set('i', '<C-L>', 'copilot#Accept("<CR>")', {expr=true, silent=true, replace_keycodes=false})
-- vim.g.copilot_no_tab_map = true

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

