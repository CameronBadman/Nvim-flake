local M = {}

M.get_mappings = function(cmp)
  -- Detect if running on macOS
  local is_mac = vim.fn.has('macunix') == 1
  
  local mappings = cmp.mapping.preset.insert({
    -- Scroll docs (same on all platforms)
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    
    -- Original mappings as fallbacks
    ['<Up>'] = cmp.mapping.scroll_docs(-4),
    ['<Down>'] = cmp.mapping.scroll_docs(4),
    
    -- Complete, abort, confirm (same on all platforms)
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
  })
  
  -- Define the option/alt key mappings based on OS
  local next_key = is_mac and '<M-j>' or '<A-j>'
  local prev_key = is_mac and '<M-k>' or '<A-k>'
  
  -- Add the mappings (M- is recognized as Option on Mac and Alt elsewhere)
  mappings[next_key] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    else
      fallback()
    end
  end, { 'i', 's' })
  
  mappings[prev_key] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    else
      fallback()
    end
  end, { 'i', 's' })
  
  -- For compatibility, always include M- mappings which work cross-platform
  -- (M- is recognized as Option on Mac and Alt elsewhere)
  mappings['<M-j>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    else
      fallback()
    end
  end, { 'i', 's' })
  
  mappings['<M-k>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    else
      fallback()
    end
  end, { 'i', 's' })
  
  return mappings
end

return M
