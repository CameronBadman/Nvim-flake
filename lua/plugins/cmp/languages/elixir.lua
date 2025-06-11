-- lua/plugins/cmp/languages/elixir.lua
return {
  sources = {
    { 
      name = 'nvim_lsp',
      priority = 1000,
      -- Filter out snippets since we handle them separately
      entry_filter = function(entry)
        return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Snippet'
      end,
      -- Elixir-specific trigger characters
      trigger_characters = { ".", "@", "&", "%", "^", ":", "|" }
    },
    { 
      name = 'luasnip', 
      priority = 750,
      -- Custom snippets for Elixir patterns
      option = {
        use_show_condition = false,
      }
    },
    { 
      name = 'buffer',
      priority = 500,
      option = {
        get_bufnrs = function()
          -- Complete from visible Elixir buffers only
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local filetype = vim.bo[buf].filetype
            if filetype == 'elixir' or filetype == 'eelixir' or filetype == 'heex' or filetype == 'surface' then
              bufs[#bufs + 1] = buf
            end
          end
          return bufs
        end,
        keyword_length = 2,  -- Elixir has shorter meaningful completions
        keyword_pattern = [[\k\+]],
      }
    },
    { name = 'path', priority = 250 },
  },
  formatting = {
    format = function(entry, vim_item)
      -- Enhanced Elixir-specific formatting
      if entry.source.name == 'nvim_lsp' then
        local kind = vim_item.kind
        local detail = entry.completion_item.detail or ""
        
        -- Custom menu labels for Elixir constructs
        vim_item.menu = ({
          Function = '[Ex Func]',
          Method = '[Ex Method]',
          Module = '[Ex Module]',
          Struct = '[Ex Struct]',
          Variable = '[Ex Var]',
          Constant = '[Ex Const]',
          Field = '[Ex Field]',
          Keyword = '[Ex Keyword]',
          Interface = '[Ex Behaviour]',
          Class = '[Ex Protocol]',
          Constructor = '[Ex Constructor]',
          Property = '[Ex Property]',
          Unit = '[Ex Unit]',
          Value = '[Ex Value]',
          Enum = '[Ex Enum]',
          EnumMember = '[Ex EnumMember]',
          Reference = '[Ex Ref]',
          Folder = '[Ex Folder]',
          File = '[Ex File]',
          Color = '[Ex Color]',
          TypeParameter = '[Ex TypeParam]',
        })[kind] or '[Ex LSP]'
        
        -- Add type information for functions/modules
        if kind == 'Function' or kind == 'Method' then
          if detail and detail ~= "" then
            -- Clean up the detail for better readability
            local cleaned_detail = detail:gsub("^.*%s*->%s*", "→ ")
            vim_item.menu = vim_item.menu .. ' ' .. cleaned_detail
          end
        elseif kind == 'Module' then
          vim_item.menu = vim_item.menu .. ' 📦'
        elseif kind == 'Struct' then
          vim_item.menu = vim_item.menu .. ' 🏗️'
        elseif kind == 'Variable' and string.match(vim_item.word, '^@') then
          vim_item.menu = '[Ex Attr]'  -- Module attributes
        elseif kind == 'Keyword' then
          -- Distinguish between different keyword types
          if string.match(vim_item.word, '^def') then
            vim_item.menu = '[Ex Def]'
          elseif string.match(vim_item.word, '^use$') or string.match(vim_item.word, '^import$') or string.match(vim_item.word, '^alias$') or string.match(vim_item.word, '^require$') then
            vim_item.menu = '[Ex Import]'
          end
        end
        
        -- Add documentation preview if available
        if entry.completion_item.documentation then
          local doc = entry.completion_item.documentation
          if type(doc) == "table" and doc.value then
            -- Truncate long documentation
            local doc_preview = doc.value:gsub("\n.*", "")
            if #doc_preview > 50 then
              doc_preview = doc_preview:sub(1, 47) .. "..."
            end
            vim_item.menu = vim_item.menu .. ' | ' .. doc_preview
          end
        end
      elseif entry.source.name == 'buffer' then
        vim_item.menu = '[Buffer]'
      elseif entry.source.name == 'path' then
        vim_item.menu = '[Path]'
      elseif entry.source.name == 'luasnip' then
        vim_item.menu = '[Snippet]'
      end
      
      return vim_item
    end
  },
  
  -- Elixir-specific completion behavior
  completion = {
    completeopt = "menu,menuone,noinsert",
    keyword_length = 1,  -- Start completing after 1 character for Elixir
  },
  
  -- Custom sorting for Elixir completions
  sorting = {
    priority_weight = 2,
    comparators = {
      -- Prioritize exact matches
      require('cmp').config.compare.exact,
      -- Prioritize LSP completions
      require('cmp').config.compare.score,
      -- Prioritize shorter completions
      require('cmp').config.compare.length,
      -- Prioritize recently used
      require('cmp').config.compare.recently_used,
      -- Prioritize by kind (functions, modules, etc.)
      require('cmp').config.compare.kind,
      -- Sort alphabetically as fallback
      require('cmp').config.compare.sort_text,
      require('cmp').config.compare.order,
    },
  },
  
  -- Preselect behavior for Elixir
  preselect = require('cmp').PreselectMode.Item,
  
  -- Window styling
  window = {
    completion = {
      winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
      col_offset = -3,
      side_padding = 0,
    },
    documentation = {
      border = "rounded",
      winhighlight = "Normal:CmpDoc",
    },
  },
}
