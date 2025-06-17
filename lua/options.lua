-- Basic Settings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '    -- Local leader (for filetype-specific mappings)

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true     -- Copy indent from current line when starting new line
vim.opt.breakindent = true    -- Wrapped lines continue visually indented

-- Text wrapping
vim.opt.wrap = false
vim.opt.linebreak = true      -- If wrap is enabled, break at word boundaries
vim.opt.textwidth = 0         -- Disable automatic line breaking

-- File handling
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.autoread = true       -- Auto-reload files changed outside vim
vim.opt.autowrite = true      -- Auto-save before switching buffers

-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true     -- Ignore case in search patterns
vim.opt.smartcase = true      -- Override ignorecase if search contains uppercase

-- Visual
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8     -- Horizontal scroll offset
vim.opt.signcolumn = "yes"    -- Always show sign column (for git signs, diagnostics)
vim.opt.colorcolumn = "80"    -- Show line at 80 characters
vim.opt.cursorline = true     -- Highlight current line

-- Performance
vim.opt.updatetime = 50
vim.opt.timeoutlen = 500      -- Time to wait for mapped sequence to complete (ms)
vim.opt.ttimeoutlen = 10      -- Time to wait for key code sequence to complete

-- Completion
vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
vim.opt.pumheight = 10        -- Maximum number of entries in popup menu

-- Brace/bracket matching
vim.opt.showmatch = true
vim.opt.matchtime = 2
vim.opt.matchpairs = "(:),{:},[:]"

-- Command line
vim.opt.wildmenu = true       -- Enhanced command line completion
vim.opt.wildmode = { "longest:full", "full" }
vim.opt.cmdheight = 1         -- Command line height
vim.opt.showcmd = true        -- Show partial commands

-- Splits
vim.opt.splitbelow = true     -- New horizontal splits below current
vim.opt.splitright = true    -- New vertical splits to the right

-- Mouse
vim.opt.mouse = "a"           -- Enable mouse in all modes

-- Clipboard
vim.opt.clipboard = "unnamedplus"  -- Use system clipboard

-- Folding (if you want to use it)
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false    -- Don't fold by default
vim.opt.foldlevel = 99        -- High fold level so folds are open by default

-- Status line (if not using lualine)
vim.opt.laststatus = 3        -- Global status line

-- Misc
vim.opt.confirm = true        -- Ask for confirmation instead of failing
vim.opt.hidden = true         -- Allow switching buffers without saving
vim.opt.spell = false         -- Disable spell checking by default
vim.opt.spelllang = "en_us"   -- Spell checking language

-- Kanagawa theme setup
require('kanagawa').setup({
    transparent = true,
    theme = "dragon",
    background = {
        dark = "dragon",
        light = "lotus"
    },
})

vim.cmd("colorscheme kanagawa")

-- Additional transparency settings
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- Show whitespace characters (helpful for programming)
vim.opt.list = true
vim.opt.listchars = { tab = "→ ", trail = "·", nbsp = "␣" }

-- Restore cursor position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})
