-- lua/plugins/treesitter.lua
require('nvim-treesitter.configs').setup({
  -- Syntax highlighting
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  -- Indentation
  indent = {
    enable = true,
  },

  -- Auto tag management (closing HTML/XML tags)
  autotag = {
    enable = true,
  },

  -- Code folding
  fold = {
    enable = true,
  },

  -- Auto pairs
  autopairs = {
    enable = true,
  },

  -- Context
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },

  -- Better incremental selection
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      node_incremental = '<CR>',
      node_decremental = '<BS>',
      scope_incremental = '<TAB>',
    },
  },
})

-- Folding settings
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldenable = false  -- Disable folding at startup
