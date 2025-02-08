return {
  sources = {
    { name = 'nvim_lsp', priority = 1000 },     -- LSP 
    { name = 'nvim_lua', priority = 900 },      -- Lua Neovim API
    { name = 'luasnip', priority = 750 },       -- Snippets
    { name = 'buffer', priority = 500 },        -- Buffer words
    { name = 'path', priority = 250 },          -- Path completion
    {
      name = 'buffer',
      priority = 300,
      option = {
        get_bufnrs = function()
          -- Complete from all lua buffers
          local bufs = {}
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].filetype == 'lua' then
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
      -- Special formatting for Lua
      if entry.source.name == 'nvim_lua' then
        vim_item.menu = '[Nvim]'
      elseif entry.source.name == 'nvim_lsp' then
        if vim_item.kind == 'Function' then
          vim_item.menu = '[Lua Func]'
        elseif vim_item.kind == 'Method' then
          vim_item.menu = '[Lua Method]'
        end
      end
      return vim_item
    end
  }
}
