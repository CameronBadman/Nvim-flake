return {
  sources = {
    { 
      name = 'nvim_lsp',
      priority = 1000,
      -- Enhanced filtering for Java completions
      entry_filter = function(entry)
        local kind = require('cmp.types').lsp.CompletionItemKind[entry:get_kind()]
        
        -- Filter out snippets but keep other useful completions
        if kind == 'Snippet' then
          return false
        end
        
        -- Boost score for commonly used Java patterns
        local word = entry:get_word()
        if kind == 'Keyword' then
          if word:match('^public') or word:match('^private') or word:match('^protected') or
             word:match('^static') or word:match('^final') or word:match('^abstract') or
             word:match('^synchronized') or word:match('^volatile') then
            entry.score_offset = 100
          end
        end
        
        -- Prioritize methods from commonly used packages
        if kind == 'Method' or kind == 'Function' then
          local detail = entry.completion_item.detail or ""
          if detail:match('java%.util%.') or detail:match('java%.lang%.') or 
             detail:match('java%.io%.') or detail:match('java%.time%.') then
            entry.score_offset = 50
          end
        end
        
        return true
      end,
      -- Group completions by type
      group_index = function(entry)
        local kind = require('cmp.types').lsp.CompletionItemKind[entry:get_kind()]
        if kind == 'Method' or kind == 'Function' then
          return 1
        elseif kind == 'Field' or kind == 'Property' then
          return 2
        elseif kind == 'Class' or kind == 'Interface' or kind == 'Enum' then
          return 3
        elseif kind == 'Variable' or kind == 'Constant' then
          return 4
        else
          return 5
        end
      end
    },
    { name = 'luasnip', priority = 750 },
    { 
      name = 'buffer',
      priority = 500,
      option = {
        get_bufnrs = function()
          -- Complete from visible Java buffers only
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == 'java' then
              bufs[#bufs + 1] = buf
            end
          end
          return bufs
        end,
        keyword_length = 3,  -- Java identifiers tend to be longer
      }
    },
    { name = 'path', priority = 250 },
  },
  formatting = {
    format = function(entry, vim_item)
      -- Enhanced Java-specific formatting
      if entry.source.name == 'nvim_lsp' then
        local kind = vim_item.kind
        vim_item.menu = ({
          Method = '[Java Method]',
          Function = '[Java Func]',
          Field = '[Java Field]',
          Property = '[Java Prop]',
          Class = '[Java Class]',
          Interface = '[Java Interface]',
          Enum = '[Java Enum]',
          EnumMember = '[Java EnumVal]',
          Package = '[Java Pkg]',
          Variable = '[Java Var]',
          Constant = '[Java Const]',
          Constructor = '[Java Ctor]',
          TypeParameter = '[Java Generic]',
          Keyword = '[Java Keyword]',
        })[kind] or '[Java LSP]'
        
        -- Add method signature or type info if available
        if entry.completion_item.detail then
          local detail = entry.completion_item.detail
          
          -- Clean up common Java package prefixes for readability
          detail = detail:gsub('java%.lang%.', '')
          detail = detail:gsub('java%.util%.', 'util.')
          detail = detail:gsub('java%.io%.', 'io.')
          detail = detail:gsub('java%.time%.', 'time.')
          detail = detail:gsub('java%.net%.', 'net.')
          
          -- Shorten long signatures
          if string.len(detail) > 60 then
            detail = string.sub(detail, 1, 57) .. "..."
          end
          vim_item.menu = vim_item.menu .. ' ' .. detail
        end
        
        -- Add special indicators for different method types
        if kind == 'Method' then
          local label = entry.completion_item.label
          -- Static method indicator
          if entry.completion_item.detail and entry.completion_item.detail:match('static') then
            vim_item.menu = vim_item.menu .. ' ⚡'
          end
          -- Deprecated method indicator
          if entry.completion_item.tags and #entry.completion_item.tags > 0 then
            for _, tag in ipairs(entry.completion_item.tags) do
              if tag == 1 then -- Deprecated
                vim_item.menu = vim_item.menu .. ' ⚠️'
                break
              end
            end
          end
        end
        
        -- Add indicators for collections and streams
        if entry.completion_item.label:match('stream') or 
           entry.completion_item.label:match('collect') or
           entry.completion_item.label:match('filter') or
           entry.completion_item.label:match('map') then
          vim_item.menu = vim_item.menu .. ' 🌊'
        end
        
        -- Add indicators for annotation processing
        if kind == 'Class' and entry.completion_item.label:match('^@') then
          vim_item.menu = vim_item.menu .. ' 📝'
        end
        
      elseif entry.source.name == 'luasnip' then
        vim_item.menu = '[Java Snippet]'
      elseif entry.source.name == 'buffer' then
        vim_item.menu = '[Java Buffer]'
      elseif entry.source.name == 'path' then
        vim_item.menu = '[Path]'
      end
      
      return vim_item
    end
  },
  -- Java-specific completion behavior
  completion = {
    keyword_length = 1,
    keyword_pattern = [[\k\+]],
  },
  -- Enhanced sorting for Java completions
  sorting = {
    priority_weight = 2,
    comparators = {
      require('cmp').config.compare.offset,
      require('cmp').config.compare.exact,
      require('cmp').config.compare.score,
      require('cmp').config.compare.recently_used,
      require('cmp').config.compare.locality,
      require('cmp').config.compare.kind,
      require('cmp').config.compare.sort_text,
      require('cmp').config.compare.length,
      require('cmp').config.compare.order,
    },
  },
}
