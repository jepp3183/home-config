vim.api.nvim_create_autocmd("BufEnter", { command = "TSBufEnable highlight" })
vim.diagnostic.config({
  signs = true,
})

local lsp_capabilities = require('blink.cmp').get_lsp_capabilities()

local standard_servers = {
  "pyright",
  "nil_ls",
  "ruff",
  "ccls",
  -- "ansiblels", PERFORMANCE ISSUES
  "yamlls",
  "docker_compose_language_service",
  "dockerls",
  "fish_lsp",
  "tinymist",
}

for i = 1, #standard_servers do
  require('lspconfig')[standard_servers[i]].setup({
    capabilities = lsp_capabilities,
  })
end

require 'lspconfig'.harper_ls.setup {
  capabilities = lsp_capabilities,
  filetypes = { "typst", "markdown" },
  settings = {
    ["harper-ls"] = {
      userDictPath = "~/dict.txt",
      linters = {
        SpellCheck = false
      }
    }
  }
}

require 'lspconfig'.elixirls.setup {
  capabilities = lsp_capabilities,
  cmd = { "/home/jeppe/.nix-profile/bin/elixir-ls" },
  root_dir = function()
    return vim.fn.getcwd()
  end,
}

require 'lspconfig'.tinymist.setup {
  capabilities = lsp_capabilities,
  settings = {
    exportPdf = 'onType',
    formatterMode = 'typstfmt',
  }
}

require 'lspconfig'.lua_ls.setup {
  capabilities = lsp_capabilities,
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
        Lua = {
          runtime = {
            version = 'LuaJIT'
          },
          workspace = {
            checkThirdParty = false,
            library = vim.api.nvim_get_runtime_file("", true)
          }
        }
      })
      client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end
    return true
  end
}

require('blink.cmp').setup({
  sources = {
    default = {'lsp', 'path', 'snippets', 'buffer' },
  },
  keymap = {
    preset = 'super-tab',
    ['<C-k>'] = { 'select_prev', 'fallback_to_mappings' },
    ['<C-j>'] = { 'select_next', 'fallback_to_mappings' },
    ['<C-p>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-n>'] = { 'scroll_documentation_down', 'fallback' },
  },
  snippets = { preset = 'luasnip' },
  fuzzy = { implementation = "prefer_rust_with_warning" },
  completion = {
    menu = {
      draw = {
        columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } },
        treesitter = { 'lsp' }
      }
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 0,
      update_delay_ms = 50,
    },
  },
})

vim.diagnostic.config({
  float = { border = 'rounded' },
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = 'rounded' }
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = 'rounded' }
)
