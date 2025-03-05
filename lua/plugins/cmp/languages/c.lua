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
          -- Complete from visible C buffers only
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype
            if ft == 'c' or ft == 'h' then
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
      -- Use the icons from the base configuration
      local icons = require('lua.plugins.cmp.icons')
      vim_item.kind = string.format('%s %s', icons.kind_icons[vim_item.kind], vim_item.kind)
      
      -- Enhanced C-specific formatting
      if entry.source.name == 'nvim_lsp' then
        local kind = vim_item.kind:match("%s(.+)$") -- Extract kind from formatted string
        local kind_labels = {
          Function = '[C Func]',
          Method = '[C Method]',
          Struct = '[C Struct]',
          Enum = '[C Enum]',
          EnumMember = '[C EnumVal]',
          Macro = '[C Macro]',
          Variable = '[C Var]',
          Constant = '[C Const]',
          TypeParameter = '[C TypeDef]',
          Typedef = '[C Typedef]',
        }
        
        vim_item.menu = kind_labels[kind] or '[C LSP]'
        
        -- Add type info if available
        if entry.completion_item.detail then
          vim_item.menu = vim_item.menu .. ' ' .. entry.completion_item.detail
        end
      else
        -- Use default menu text for non-LSP sources
        vim_item.menu = ({
          luasnip = "[C Snippet]",
          buffer = "[C Buffer]",
          path = "[Path]",
        })[entry.source.name] or vim_item.menu
      end
      
      return vim_item
    end
  }
}
