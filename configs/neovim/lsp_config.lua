-- vim.api.nvim_create_autocmd("BufEnter", { command = "TSBufEnable highlight" })
vim.diagnostic.config({
  signs = true,
  float = { border = 'rounded' },
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
}

for i = 1, #standard_servers do
  vim.lsp.config(standard_servers[i], {
    capabilities = lsp_capabilities,
  })
  vim.lsp.enable(standard_servers[i])
end

vim.lsp.config('harper_ls', {
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
})
vim.lsp.enable('harper_ls')

vim.lsp.config('elixirls', {
  capabilities = lsp_capabilities,
  cmd = { "/home/jeppe/.nix-profile/bin/elixir-ls" },
  root_dir = function(bufnr, cb)
    cb(vim.fn.getcwd())
  end,
})
vim.lsp.enable('elixirls')

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.ex", "*.exs" },
  callback = function()
    vim.lsp.buf.format({ name = "elixirls", async = false })
  end,
})

vim.lsp.config('tinymist', {
  capabilities = lsp_capabilities,
  settings = {
    exportPdf = 'onType',
    formatterMode = 'typstfmt',
  }
})
vim.lsp.enable('tinymist')

vim.lsp.config('lua_ls', {
  capabilities = lsp_capabilities,
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if not vim.uv.fs_stat(path .. '/.luarc.json') and not vim.uv.fs_stat(path .. '/.luarc.jsonc') then
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
})
vim.lsp.enable('lua_ls')

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


