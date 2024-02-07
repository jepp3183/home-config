vim.g.mapleader = ' '

vim.keymap.set('i', 'jj', '<Esc>')
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('t', '<C-N>', '<C-\\><C-N>')
vim.keymap.set('n', '<Leader>e', ':Neotree toggle<CR>')
vim.keymap.set('', '<C-j>', '5j')
vim.keymap.set('', '<C-k>', '5k')
vim.keymap.set('n', '<C-h>', '<cmd>bprev<cr>')
vim.keymap.set('n', '<C-l>', '<cmd>bnext<cr>')
vim.keymap.set('n', '<C-s>', ':w<CR>')
vim.keymap.set('n', '<C-q>', ':bd<CR>')

local Terminal  = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = 'float' })
function _lazygit_toggle()
  lazygit:toggle()
end
vim.api.nvim_set_keymap("n", "<leader>gg", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})

-- Telescope
vim.keymap.set('n', '<Leader>ff', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n', '<Leader>fg', '<cmd>Telescope live_grep<cr>')
vim.keymap.set('n', '<Leader>fb', '<cmd>Telescope buffers<cr>')
vim.keymap.set('n', '<Leader>fh', '<cmd>Telescope help_tags<cr>')
vim.keymap.set('n', '<Leader>fk', '<cmd>Telescope keymaps<cr>')
vim.keymap.set('n', '<Leader>fc', '<cmd>Telescope find_files cwd=/etc/nixos<cr>')

-- COQ
vim.cmd([[
  ino <silent><expr> <Esc>   pumvisible() ? "\<C-e><Esc>" : "\<Esc>"
  ino <silent><expr> <C-c>   pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
  ino <silent><expr> <BS>    pumvisible() ? "\<C-e><BS>"  : "\<BS>"
  ino <silent><expr> <TAB>    pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"
  ino <silent><expr> <C-j>   pumvisible() ? "\<C-n>" : "\<Tab>"
  ino <silent><expr> <C-k> pumvisible() ? "\<C-p>" : "\<BS>"
]])

-- LSP SHIT
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Only when LSP is attached
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>lR', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>lf', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
vim.keymap.set('n', '<Leader>ls', '<cmd>Telescope lsp_document_symbols<cr>')
vim.keymap.set('n', '<Leader>lS', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>')
vim.keymap.set('n', '<Leader>lr', '<cmd>Telescope lsp_references<cr>')
vim.keymap.set('n', '<Leader>ld', '<cmd>Telescope diagnostics<cr>')


-- copilot
vim.keymap.set('i', '<C-L>', 'copilot#Accept("<CR>")', {expr=true, silent=true, replace_keycodes=false})
vim.g.copilot_no_tab_map = true


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

