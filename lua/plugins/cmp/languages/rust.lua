return {
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'crates' },  -- Rust-specific
    { name = 'path' },
  },
  formatting = {
    format = function(entry, vim_item)
      if entry.source.name == 'crates' then
        vim_item.menu = '[Crate]'
      end
      return vim_item
    end
  }
}

