-- config/plugins/lsp/diagnostics.lua
local signs = {
  Error = "󰅚 ", 
  Warn  = "󰀦 ", 
  Info  = "󰋽 ", 
  Hint  = "󰛩 ", 
}

-- Configure diagnostics colors with more vibrant colors
vim.cmd([[
  " Error in bright red
  highlight DiagnosticError guifg=#ff5d62 gui=bold
  highlight DiagnosticVirtualTextError guifg=#ff5d62 guibg=#362c3d gui=bold,italic
  highlight DiagnosticUnderlineError guisp=#ff5d62 gui=undercurl

  " Warning in bright yellow/gold
  highlight DiagnosticWarn guifg=#ffa066 gui=bold
  highlight DiagnosticVirtualTextWarn guifg=#ffa066 guibg=#2e2a3f gui=bold,italic
  highlight DiagnosticUnderlineWarn guisp=#ffa066 gui=undercurl

  " Info in bright cyan/blue
  highlight DiagnosticInfo guifg=#7dcfff gui=bold
  highlight DiagnosticVirtualTextInfo guifg=#7dcfff guibg=#1f2c3d gui=bold,italic
  highlight DiagnosticUnderlineInfo guisp=#7dcfff gui=undercurl

  " Hint in bright green
  highlight DiagnosticHint guifg=#73daca gui=bold
  highlight DiagnosticVirtualTextHint guifg=#73daca guibg=#1f2d2a gui=bold,italic
  highlight DiagnosticUnderlineHint guisp=#73daca gui=undercurl

  " Make the sign column stand out more
  highlight SignColumn guibg=NONE
]])

-- Define diagnostic signs
for type, icon in pairs(signs) do
  local hl = "Diagnostic" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Configure diagnostics display
vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    source = "if_many",
    severity = {
      min = vim.diagnostic.severity.HINT,
    },
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
    -- Make float more visible
    style = 'minimal',
    focusable = false,
  },
})
