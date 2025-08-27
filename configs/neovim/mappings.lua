vim.g.mapleader = ' '
vim.keymap.set('n', 'q:', '<Nop>')
vim.keymap.set('t', '<C-N>', '<C-\\><C-N>')
vim.keymap.set('n', '<C-b>', function()
  require('neo-tree.command').execute({
    toggle = true,
    source = 'last',
    position = 'left',
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


-- yank to system clipboard!
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Intuitive directional resizing with Ctrl+Arrow
local opts = { noremap = true, silent = true }

local function smart_resize(dir)
  local amount = vim.v.count1 * 3  -- default step = 2 cols/rows; use a count to change it
  local cur = vim.api.nvim_get_current_win()
  local neighbor = vim.fn.winnr(dir)
  local has_neighbor = neighbor ~= 0

  if has_neighbor then
    -- Shrink the neighbor on that side so the current window grows toward it
    vim.cmd('wincmd ' .. dir)
    if dir == 'h' or dir == 'l' then
      vim.cmd('vertical resize -' .. amount)
    else
      vim.cmd('resize -' .. amount)
    end
    vim.api.nvim_set_current_win(cur)
  else
    -- No neighbor on that side: just shrink this window
    if dir == 'h' or dir == 'l' then
      vim.cmd('vertical resize -' .. amount)
    else
      vim.cmd('resize -' .. amount)
    end
  end
end

vim.keymap.set('n', '<C-Left>',  function() smart_resize('h') end, opts)
vim.keymap.set('n', '<C-Right>', function() smart_resize('l') end, opts)
vim.keymap.set('n', '<C-Up>',    function() smart_resize('k') end, opts)
vim.keymap.set('n', '<C-Down>',  function() smart_resize('j') end, opts)

-- Git
vim.keymap.set("n", "<leader>ng", "<cmd>Neogit<CR>", {noremap = true, silent = true, desc = "Open Neogit"})
vim.keymap.set("n", "<leader>gg", function () require('snacks').lazygit() end, {noremap = true, silent = true, desc = "Lazygit"})
vim.keymap.set("n", "<leader>go", function () require('snacks').gitbrowse() end, {noremap = true, silent = true, desc = "Git Browse"})
vim.keymap.set("n", "<leader>gc", "<cmd>Neogit commit<CR>", {noremap = true, silent = true, desc = "Neogit commit"})
vim.keymap.set("n", "<leader>gb", function() require('gitsigns').blame_line({full = true}) end, {desc = "Blame line"})
vim.keymap.set("n", "<leader>gB", "<cmd>Gitsigns blame<CR>", {noremap = true, silent = true, desc = "Gitsigns blame"})
vim.keymap.set("n", "<leader>gtb", "<cmd>Gitsigns toggle_current_line_blame<cr>", {noremap = true, silent = true, desc = "Toggle current line blame"})
vim.keymap.set("n", "<leader>gs", "<cmd>Gitsigns stage_buffer<cr>", {noremap = true, silent = true, desc = "Stage buffer"})
vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", {noremap = true, silent = true, desc = "Preview hunk"})
vim.keymap.set("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", {noremap = true, silent = true, desc = "Reset hunk"})
vim.keymap.set("n", "]h", "<cmd>Gitsigns next_hunk<cr>", {noremap = true, silent = true, desc = "Next hunk"})
vim.keymap.set("n", "[h", "<cmd>Gitsigns prev_hunk<cr>", {noremap = true, silent = true, desc = "Previous hunk"})

-- AI Tools
--- Avante
vim.keymap.set({ "n", "v" }, '<leader>aa', function() require("avante.api").ask() end, {desc = "avante: ask"})
vim.keymap.set("v", '<leader>ar', function() require("avante.api").refresh() end, {desc = "avante: refresh"})
vim.keymap.set("v", '<leader>ae', function() require("avante.api").edit() end, {desc = "avante: edit"})

-- Telescope
local fl = require('fzf-lua')
local function lg(search)
  fl.live_grep({
    search = search,
    winopts={
      preview={
        layout='vertical',
        vertical='up:50%',
      }
    }
  })
end
vim.keymap.set('n', '<Leader>ff', function() fl.files({
    winopts={
      preview={
        layout='vertical',
        vertical='down:60%',
      }
    }
  }) end, {desc="Find files"})
vim.keymap.set('n', '<Leader>fg', function() lg("") end, {desc="Live grep"})
vim.keymap.set('n', '<Leader>fb', fl.buffers, {desc="Buffers"})
vim.keymap.set('n', '<Leader>fh', fl.help_tags, {desc="Help tags"})
vim.keymap.set('n', '<leader>fm', function() fl.marks({marks="%a"}) end, {desc="Marks"})
vim.keymap.set('n', '<Leader>fk', fl.keymaps, {desc="Keymaps"})
vim.keymap.set('n', '<Leader>fc', fl.commands, {desc="Commands"})
vim.keymap.set('n', '<Leader>fC', fl.command_history, {desc="Command history"})
vim.keymap.set('n', '<Leader>fs', fl.lsp_document_symbols, {desc="Document symbols"})
vim.keymap.set('n', '<Leader>fS', fl.lsp_workspace_symbols, {desc="Workspace symbols"})
vim.keymap.set('n', '<Leader>fr', fl.lsp_references, {desc="References"})
vim.keymap.set('n', '<Leader>fd', fl.diagnostics_document, {desc="Diagnostics"})
vim.keymap.set('n', 'z=', fl.spell_suggest, {desc="Spell suggest"})

vim.api.nvim_create_user_command('ConfigFind', function()
  fl.files({ cwd = "~/.config/home-manager" })
end, { desc = "Find files in config directory" })

-- Grep for selection / operator-pending
local function grep_visual_selection()
  local old_reg = vim.fn.getreg('"')
  local old_regtype = vim.fn.getregtype('"')
  vim.cmd('normal! y')
  local selected_text = vim.fn.getreg('"')
  selected_text = selected_text:gsub("\n", "")
  vim.fn.setreg('"', old_reg, old_regtype)
  lg(selected_text)
end
vim.keymap.set('x', '<leader>fw', grep_visual_selection, {desc="Grep visual selection", noremap=true})

_G.grep_operator = function(motion_type)
  local old_reg = vim.fn.getreg('"')
  local old_regtype = vim.fn.getregtype('"')
  if motion_type == 'line' then
    vim.cmd([[normal! '[V']y]])
  elseif motion_type == 'block' then
    vim.cmd([[normal! `[<C-V>`]y]])
  else
    vim.cmd([[normal! `[v`]y]])
  end
  local selected_text = vim.fn.getreg('"')
  selected_text = vim.trim(selected_text:gsub("\n", ""))
  vim.fn.setreg('"', old_reg, old_regtype)
  lg(selected_text)
end

vim.keymap.set('n', '<leader>fw', function ()
  vim.o.operatorfunc = 'v:lua.grep_operator'
  return 'g@'
end, {desc="Grep selection", expr = true, noremap = true})

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

-- Testing
local neotest = require("neotest")
vim.keymap.set("n", "<leader>tr", function() neotest.run.run() end, {desc = "Run nearest test"})
vim.keymap.set("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end, {desc = "Run current file"})
vim.keymap.set("n", "<leader>ts", function() neotest.summary.toggle() end, {desc = "Toggle test summary"})
vim.keymap.set("n", "<leader>to", function() neotest.output.open() end, {desc = "Open test output"})
vim.keymap.set("n", "<leader>tp", function() neotest.output_panel.toggle() end, {desc = "Toggle output panel"})
vim.keymap.set("n", "<leader>tl", function() neotest.run.run_last() end, {desc = "Run last test"})
vim.keymap.set("n", "<leader>td", function() neotest.run.run({strategy = "dap"}) end, {desc = "Debug nearest test"})
vim.keymap.set("n", "<leader>ta", function() neotest.run.attach() end, {desc = "Attach to nearest test"})
vim.keymap.set("n", "<leader>tw", function() neotest.watch.toggle() end, {desc = "Toggle test watching"})
vim.keymap.set("n", "]t", function() neotest.jump.next() end, {desc = "Jump to next test"})
vim.keymap.set("n", "[t", function() neotest.jump.prev() end, {desc = "Jump to previous test"})

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
