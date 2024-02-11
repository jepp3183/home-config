vim.api.nvim_create_autocmd("BufEnter", { command = "TSBufEnable highlight" })
vim.diagnostic.config({
  signs = false,
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

  -- Override example:
  -- ["rust_analyzer"] = function()
  --   require('lspconfig').rust_analyzer.setup({
  --     capabilities = lsp_capabilities
  --   })
  -- end,
})

local cmp = require('cmp')
-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)
cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
  },
  completion = {
    completeopt = 'menu,menuone,noinsert'
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
  mapping = {
    ['<TAB>'] = cmp.mapping.confirm({ select = false }),
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
