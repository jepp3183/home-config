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

-- COC
vim.keymap.set('n', 'gd', '<Plug>(coc-definition)')
vim.keymap.set('n', '<Leader>lc', '<cmd>Telescope coc coc<cr>')
vim.keymap.set('n', '<Leader>ls', '<cmd>Telescope coc document_symbols<cr>')
vim.keymap.set('n', '<Leader>lS', '<cmd>Telescope coc workspace_symbols<cr>')
vim.keymap.set('n', '<Leader>lr', '<cmd>Telescope coc references_used<cr>')
vim.keymap.set('n', '<Leader>ld', '<cmd>Telescope coc workspace_diagnostics<cr>')
vim.keymap.set('n', '<leader>lq', '<Plug>(coc-fix-current)')
vim.keymap.set('n', '<leader>lR', '<Plug>(coc-rename)')
vim.keymap.set('x', '<leader>la', '<Plug>(coc-codeaction-selected)')
vim.keymap.set('n', '<leader>la', '<Plug>(coc-codeaction-selected)')


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

