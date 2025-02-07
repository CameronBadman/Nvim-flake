-- Basic Settings
vim.g.mapleader = ' '
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.updatetime = 50

-- Kanagawa theme setup
require('kanagawa').setup({
    transparent = true,     -- Enable transparency
    theme = "dragon",       -- Load the dragon variant
    background = {         -- Customize the background color
        dark = "dragon",
        light = "lotus"
    },
})

-- Set the colorscheme
vim.cmd("colorscheme kanagawa")

-- Additional transparency settings if needed
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
