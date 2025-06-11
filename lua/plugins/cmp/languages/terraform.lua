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
          -- Complete from visible Terraform buffers only
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == 'terraform' or vim.bo[buf].filetype == 'hcl' then
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
      -- Enhanced Terraform-specific formatting
      if entry.source.name == 'nvim_lsp' then
        local kind = vim_item.kind
        vim_item.menu = ({
          Function = '[Tf Func]',
          Method = '[Tf Method]',
          Struct = '[Tf Block]',
          Interface = '[Tf Interface]',
          Variable = '[Tf Var]',
          Constant = '[Tf Const]',
          Type = '[Tf Type]',
          Property = '[Tf Prop]',
          Field = '[Tf Field]',
          Class = '[Tf Resource]',
          Module = '[Tf Module]',
          Snippet = '[Tf Snippet]',
        })[kind] or '[Tf LSP]'
        
        -- Add additional context if available
        if entry.completion_item.detail then
          vim_item.menu = vim_item.menu .. ' ' .. entry.completion_item.detail
        end
      end
      return vim_item
    end
  }
}
