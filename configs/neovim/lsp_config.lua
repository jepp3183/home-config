vim.g.coq_settings = { 
    auto_start = true,
    keymap = {
        recommended = false;
        jump_to_mark = 'null';
        bigger_preview = 'null'
    }
}

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
