-- lua/plugins/lsp/servers/go-cmp.lua
return {
  sources = {
    { 
      name = 'nvim_lsp',
      priority = 1000,
      -- Only include non-snippet LSP completions
      entry_filter = function(entry)
        return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Snippet'
      end
    },
    { name = 'luasnip', priority = 750 },
    { 
      name = 'buffer',
      priority = 500,
      option = {
        get_bufnrs = function()
          -- Complete from visible Go buffers only
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == 'go' then
              bufs[#bufs + 1] = buf
            end
          end
          return bufs
        end,
        keyword_length = 3,  -- Only complete words longer than 3 chars
      }
    },
    { name = 'path', priority = 250 },
  },

  formatting = {
    format = function(entry, vim_item)
      -- Enhanced Go-specific formatting
      if entry.source.name == 'nvim_lsp' then
        local kind = vim_item.kind
        vim_item.menu = ({
          Function = '[Go Func]',
          Method = '[Go Method]',
          Struct = '[Go Struct]',
          Interface = '[Go Interface]',
          Package = '[Go Pkg]',
          Variable = '[Go Var]',
          Constant = '[Go Const]',
          Type = '[Go Type]',
        })[kind] or '[Go LSP]'
        
        -- Add return type info if available
        if entry.completion_item.detail then
          vim_item.menu = vim_item.menu .. ' ' .. entry.completion_item.detail
        end
      end
      return vim_item
    end
  }
}
