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
          -- Complete from all Haskell buffers
          local bufs = {}
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].filetype == 'haskell' then
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
      -- Special formatting for Haskell symbols
      if entry.source.name == 'nvim_lsp' then
        if vim_item.kind == 'Function' then
          vim_item.menu = '[Haskell Func]'
        elseif vim_item.kind == 'Type' then
          vim_item.menu = '[Haskell Type]'
        elseif vim_item.kind == 'Constructor' then
          vim_item.menu = '[Haskell Ctor]'
        elseif vim_item.kind == 'TypeClass' then
          vim_item.menu = '[Haskell Class]'
        elseif vim_item.kind == 'Module' then
          vim_item.menu = '[Haskell Mod]'
        elseif vim_item.kind == 'Operator' then
          vim_item.menu = '[Haskell Op]'
        end
      end
      return vim_item
    end
  }
}
