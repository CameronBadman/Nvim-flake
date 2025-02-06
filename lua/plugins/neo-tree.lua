require('neo-tree').setup({
  close_if_last_window = true,
  enable_git_status = true,
  enable_diagnostics = true,
  window = {
    width = 30,
  },
  filesystem = {
    filtered_items = {
      visible = false,
      hide_dotfiles = true,
      hide_gitignored = true,
    },
    follow_current_file = true,
    use_libuv_file_watcher = true,
  }
})
