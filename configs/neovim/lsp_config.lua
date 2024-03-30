vim.api.nvim_create_autocmd("BufEnter", { command = "TSBufEnable highlight" })
vim.diagnostic.config({
  signs = false,
  virtual_text = true,
  virtual_lines = false
})

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {},
})
require('mason-lspconfig').setup_handlers({
  -- Default for all LSP
  function(server)
    require('lspconfig')[server].setup({
      capabilities = lsp_capabilities,
    })
  end,

  ["lua_ls"] = function()
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
  end
})

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local cmp = require('cmp')
local luasnip = require('luasnip')
-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)
cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' }
  },
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  mapping = {
    -- ['<C-y>'] = cmp.mapping.confirm({ select = false }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.confirm({select = false})
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),

    ['<ESC>'] = cmp.mapping.abort(),
    ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
    ['<C-j>'] = cmp.mapping.select_next_item({ behavior = 'select' }),
    ['<C-p>'] = cmp.mapping.scroll_docs(-4),
    ['<C-n>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping(function()
      if not cmp.visible() then
        cmp.complete()
      end
    end),
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  formatting = {
    format = function(entry, item)
      -- Define menu shorthand for different completion sources.
      local menu_icon = {
        nvim_lsp = "NLSP",
        nvim_lua = "NLUA",
        luasnip  = "LSNP",
        buffer   = "BUFF",
        path     = "PATH",
      }
      -- Set the menu "icon" to the shorthand for each completion source.
      item.menu = menu_icon[entry.source.name]

      -- Set the fixed width of the completion menu to 60 characters.
      -- fixed_width = 20

      -- Set 'fixed_width' to false if not provided.
      fixed_width = fixed_width or false

      -- Get the completion entry text shown in the completion window.
      local content = item.abbr

      -- Set the fixed completion window width.
      if fixed_width then
        vim.o.pumwidth = fixed_width
      end

      -- Get the width of the current window.
      local win_width = vim.api.nvim_win_get_width(0)

      -- Set the max content width based on either: 'fixed_width'
      -- or a percentage of the window width, in this case 20%.
      -- We subtract 10 from 'fixed_width' to leave room for 'kind' fields.
      local max_content_width = fixed_width and fixed_width - 10 or math.floor(win_width * 0.2)

      -- Truncate the completion entry text if it's longer than the
      -- max content width. We subtract 3 from the max content width
      -- to account for the "..." that will be appended to it.
      if #content > max_content_width then
        item.abbr = vim.fn.strcharpart(content, 0, max_content_width - 3) .. "..."
      else
        item.abbr = content .. (" "):rep(max_content_width - #content)
      end
      return item
    end,
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
