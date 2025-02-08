local cmp = require('cmp')
local icons = require('lua.plugins.cmp.icons')
local mappings = require('lua.plugins.cmp.mappings')
local languages = require('lua.plugins.cmp.languages')

-- Base configuration
local base_config = {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = mappings.get_mappings(cmp),
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = string.format('%s %s', icons.kind_icons[vim_item.kind], vim_item.kind)
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  experimental = {
    ghost_text = true,
  },
}

-- Setup language-specific configurations
for ft, config in pairs(languages) do
  cmp.setup.filetype(ft, vim.tbl_deep_extend("force", base_config, config))
end

-- Default configuration for other filetypes
cmp.setup(vim.tbl_deep_extend("force", base_config, {
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  }),
}))

-- Command line completion
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {{ name = 'buffer' }}
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'cmdline' }
  })
})
