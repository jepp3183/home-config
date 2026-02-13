-- Options:
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
-- See :help c-indenting
vim.opt.cindent = true
vim.opt.cinkeys:remove("0#") -- Fix comments outdenting in elixir
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.hidden = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.scrolloff = 8
vim.opt.mouse = "a"
vim.opt.shell = "fish"
-- For which-key:
vim.opt.timeout = true
vim.opt.timeoutlen = 300

-- Causes slow startup time!
vim.g.editorconfig = false

vim.api.nvim_create_autocmd("FileType", {
    pattern ={"typst", "markdown"},
    callback = function ()
        vim.opt.wrap = true
        vim.opt.linebreak = true
        vim.opt.spell = true
        vim.opt.spelllang = "en"
        vim.api.nvim_buf_set_keymap(0, "n", "j", "gj", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "k", "gk", {noremap = true})
    end
})
