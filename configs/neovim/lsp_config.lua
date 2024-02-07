vim.g.coq_settings = { 
    auto_start = true,
    keymap = {
        recommended = false;
        jump_to_mark = nil;
        bigger_preview = nil
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
