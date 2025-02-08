require('lualine').setup {
  options = {
    theme = 'kanagawa',
    icons_enabled = true,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    globalstatus = true,
    refresh = {
      statusline = 50,
      tabline = 50,
      winbar = 50
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {
      'branch',
      {
        'diff',
        symbols = {
          added = ' ',
          modified = ' ',
          removed = ' '
        }
      }
    },
    lualine_c = {
      {
        'filename',
        path = 1,
        symbols = {
          modified = '●',
          readonly = '',
          unnamed = '[No Name]'
        }
      }
    },
    lualine_x = {
      {
        'diagnostics',
        sources = {'nvim_diagnostic'},
        symbols = {
          error = ' ',
          warn = ' ',
          info = ' ',
          hint = ' '
        }
      }
    },
    lualine_y = {'filetype'},
    lualine_z = {'location'}
  }
}
