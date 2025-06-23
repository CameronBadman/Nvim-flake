-- lua/plugins/lsp/servers/rust-cmp.lua
return {
  sources = {
    { 
      name = 'nvim_lsp',
      priority = 1000,
      -- More aggressive filtering to prefer LSP completions
      entry_filter = function(entry, ctx)
        local kind = require('cmp.types').lsp.CompletionItemKind[entry:get_kind()]
        local item = entry.completion_item
        
        -- Always allow methods, functions, fields, etc.
        if kind == 'Method' or kind == 'Function' or kind == 'Field' or 
           kind == 'Property' or kind == 'Struct' or kind == 'Enum' or
           kind == 'Module' or kind == 'Constant' or kind == 'Variable' then
          return true
        end
        
        -- Filter out generic text unless it has detailed info
        if kind == 'Text' then
          return item.detail ~= nil and item.detail ~= ""
        end
        
        return true
      end,
      -- Force LSP to be the primary source
      keyword_length = 0,
      max_item_count = 50,
    },
    { 
      name = 'crates',  -- Cargo.toml dependency completion
      priority = 900,
      -- Only activate in Cargo.toml files
      trigger_characters = { '"', '.', '=' },
    },
    { name = 'luasnip', priority = 750 },
    { 
      name = 'buffer',
      priority = 300,  -- Lowered priority
      option = {
        get_bufnrs = function()
          -- Complete from visible Rust buffers only
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == 'rust' then
              bufs[#bufs + 1] = buf
            end
          end
          return bufs
        end,
        keyword_length = 4,  -- Higher threshold to avoid noise
        keyword_pattern = [[\k\+]],
      }
    },
    { name = 'path', priority = 100 },  -- Lowered priority
  },
  formatting = {
    format = function(entry, vim_item)
      -- Enhanced Rust-specific formatting
      if entry.source.name == 'nvim_lsp' then
        local kind = vim_item.kind
        vim_item.menu = ({
          Function = '[Rust Fn]',
          Method = '[Rust Method]',
          Struct = '[Rust Struct]',
          Enum = '[Rust Enum]',
          EnumMember = '[Rust Variant]',
          Interface = '[Rust Trait]',
          Module = '[Rust Mod]',
          Variable = '[Rust Var]',
          Constant = '[Rust Const]',
          Field = '[Rust Field]',
          TypeParameter = '[Rust Generic]',
          Keyword = '[Rust Keyword]',
          Snippet = '[Rust Snippet]',
          Property = '[Rust Prop]',
          Unit = '[Rust Unit]',
          Value = '[Rust Value]',
          TypeAlias = '[Rust Type]',
        })[kind] or '[Rust LSP]'
        
        -- Add type information if available
        if entry.completion_item.detail then
          local detail = entry.completion_item.detail
          -- Truncate very long type signatures
          if #detail > 50 then
            detail = detail:sub(1, 47) .. "..."
          end
          vim_item.menu = vim_item.menu .. ' ' .. detail
        end
        
        -- Special handling for macros
        if vim_item.word:match("!$") then
          vim_item.menu = '[Rust Macro]'
        end
        
      elseif entry.source.name == 'crates' then
        vim_item.menu = '[Crate]'
        
      elseif entry.source.name == 'luasnip' then
        vim_item.menu = '[Snippet]'
        
      elseif entry.source.name == 'buffer' then
        vim_item.menu = '[Buffer]'
        
      elseif entry.source.name == 'path' then
        vim_item.menu = '[Path]'
      end
      
      return vim_item
    end
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      require('cmp').config.compare.offset,
      require('cmp').config.compare.exact,
      require('cmp').config.compare.score,
      require('cmp').config.compare.recently_used,
      require('cmp').config.compare.locality,
      -- Prioritize shorter completions
      function(entry1, entry2)
        local len1 = string.len(entry1.completion_item.label)
        local len2 = string.len(entry2.completion_item.label)
        if len1 ~= len2 then
          return len1 < len2
        end
      end,
      require('cmp').config.compare.kind,
      require('cmp').config.compare.sort_text,
      require('cmp').config.compare.length,
      require('cmp').config.compare.order,
    },
  },
  -- Enhanced completion behavior for better LSP experience
  preselect = require('cmp').PreselectMode.Item,
  completion = {
    completeopt = 'menu,menuone,noinsert',
    keyword_length = 1,
    get_trigger_characters = function()
      return { '.', ':', '(' }
    end,
  },
  confirmation = {
    get_commit_characters = function(commit_characters)
      -- Add Rust-specific commit characters
      return vim.list_extend(commit_characters or {}, { ".", "::", "(", "[" })
    end,
  },
}
