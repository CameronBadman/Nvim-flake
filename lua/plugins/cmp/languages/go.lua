return {
  sources = {
    { name = 'nvim_lsp', priority = 1000 },  -- LSP completion highest priority
    { name = 'luasnip', priority = 750 },     -- Snippets
    { name = 'buffer', priority = 500 },      -- Buffer words
    { name = 'path', priority = 250 },        -- Path completion
    {
      name = 'buffer',
      priority = 300,
      option = {
        get_bufnrs = function()
          -- Complete from all Go buffers
          local bufs = {}
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].filetype == 'go' then
              bufs[#bufs + 1] = buf
            end
          end
          return bufs
        end
      }
    },
  },
  formatting = {
    format = function(entry, vim_item)
      -- Special formatting for Go symbols
      if entry.source.name == 'nvim_lsp' then
        if vim_item.kind == 'Function' then
          vim_item.menu = '[Go Func]'
        elseif vim_item.kind == 'Method' then
          vim_item.menu = '[Go Method]'
        elseif vim_item.kind == 'Struct' then
          vim_item.menu = '[Go Struct]'
        elseif vim_item.kind == 'Interface' then
          vim_item.menu = '[Go Interface]'
        end
      end
      return vim_item
    end
  }
}
