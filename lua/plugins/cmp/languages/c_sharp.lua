return {
  sources = {
    { 
      name = 'nvim_lsp',
      priority = 1000,
      -- Enhanced filtering for C# completions
      entry_filter = function(entry)
        local kind = require('cmp.types').lsp.CompletionItemKind[entry:get_kind()]
        
        -- Filter out snippets but keep other useful completions
        if kind == 'Snippet' then
          return false
        end
        
        -- Prioritize commonly used C# constructs
        local word = entry:get_word()
        if kind == 'Keyword' and (
          word:match('^using') or 
          word:match('^namespace') or 
          word:match('^class') or 
          word:match('^interface') or
          word:match('^public') or
          word:match('^private') or
          word:match('^protected') or
          word:match('^internal')
        ) then
          entry.score_offset = 100
        end
        
        return true
      end,
      -- Group completions by type
      group_index = function(entry)
        local kind = require('cmp.types').lsp.CompletionItemKind[entry:get_kind()]
        if kind == 'Method' or kind == 'Function' then
          return 1
        elseif kind == 'Property' or kind == 'Field' then
          return 2
        elseif kind == 'Class' or kind == 'Interface' or kind == 'Struct' then
          return 3
        else
          return 4
        end
      end
    },
    { name = 'luasnip', priority = 750 },
    { 
      name = 'buffer',
      priority = 500,
      option = {
        get_bufnrs = function()
          -- Complete from visible C# buffers only
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == 'cs' then
              bufs[#bufs + 1] = buf
            end
          end
          return bufs
        end,
        keyword_length = 2,  -- C# identifiers can be shorter
      }
    },
    { name = 'path', priority = 250 },
  },
  formatting = {
    format = function(entry, vim_item)
      -- Enhanced C#-specific formatting
      if entry.source.name == 'nvim_lsp' then
        local kind = vim_item.kind
        vim_item.menu = ({
          Method = '[C# Method]',
          Function = '[C# Func]',
          Property = '[C# Prop]',
          Field = '[C# Field]',
          Class = '[C# Class]',
          Interface = '[C# Interface]',
          Struct = '[C# Struct]',
          Enum = '[C# Enum]',
          EnumMember = '[C# EnumVal]',
          Namespace = '[C# NS]',
          Variable = '[C# Var]',
          Constant = '[C# Const]',
          Constructor = '[C# Ctor]',
          Event = '[C# Event]',
          Operator = '[C# Op]',
          TypeParameter = '[C# Generic]',
        })[kind] or '[C# LSP]'
        
        -- Add method signature or type info if available
        if entry.completion_item.detail then
          local detail = entry.completion_item.detail
          -- Shorten long signatures
          if string.len(detail) > 50 then
            detail = string.sub(detail, 1, 47) .. "..."
          end
          vim_item.menu = vim_item.menu .. ' ' .. detail
        end
        
        -- Add special indicators for async methods
        if kind == 'Method' and entry.completion_item.label:match('Async$') then
          vim_item.menu = vim_item.menu .. ' ⚡'
        end
        
        -- Add indicators for extension methods
        if entry.completion_item.labelDetails and 
           entry.completion_item.labelDetails.description and
           entry.completion_item.labelDetails.description:match('extension') then
          vim_item.menu = vim_item.menu .. ' 🔗'
        end
      elseif entry.source.name == 'luasnip' then
        vim_item.menu = '[C# Snippet]'
      elseif entry.source.name == 'buffer' then
        vim_item.menu = '[C# Buffer]'
      elseif entry.source.name == 'path' then
        vim_item.menu = '[Path]'
      end
      
      return vim_item
    end
  },
  -- C#-specific completion behavior
  completion = {
    keyword_length = 1,
    keyword_pattern = [[\k\+]],
  },
  -- Enhanced sorting for C# completions
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

Smart, efficient model for everyday use Learn more
Artifacts

Content

