vim.g.coq_settings = { 
    auto_start = "shut-up",
    keymap = {
        pre_select = false;
        recommended = false;
        jump_to_mark = "";
        bigger_preview = ""
    }
}

vim.api.nvim_create_autocmd("BufEnter", {command = "TSBufEnable highlight"})

vim.diagnostic.config({
    signs=false;
})

local lsp = require "lspconfig"
local coq = require "coq"


lsp.pyright.setup(coq.lsp_ensure_capabilities())
lsp.rust_analyzer.setup(coq.lsp_ensure_capabilities({
    settings = {
        ['rust-analyzer'] = {
            ['check.command'] = 'cargo-clippy';
        }
    }
}))
