require('neo-tree').setup({
  close_if_last_window = true,
  enable_git_status = true,
  enable_diagnostics = true,
  
  -- Improved appearance settings
  window = {
    width = 30,
    position = "left", -- Can be "left", "right", "top", "bottom"
    mapping_options = {
      noremap = true,
      nowait = true,
    },
  },
  
  -- Show icons in the file explorer
  default_component_configs = {
    icon = {
      folder_closed = "󰉋",
      folder_open = "󰝰",
      folder_empty = "󰜌",
    },
    git_status = {
      symbols = {
        added     = "✚",
        modified  = "",
        deleted   = "✖",
        renamed   = "󰁕",
        untracked = "",
        ignored   = "",
        unstaged  = "󰄱",
        staged    = "",
        conflict  = "",
      },
    },
  },
  
  -- File system settings
  filesystem = {
    filtered_items = {
      visible = true, -- Set to true to show filtered items by default
      hide_dotfiles = false, -- Show dotfiles/hidden files
      hide_gitignored = false, -- Show git ignored files
      always_show = { -- Always show these files even if hide_dotfiles is true
        ".gitignore",
        ".env",
      },
      never_show = { -- Never show these files
        ".DS_Store",
        "thumbs.db",
      },
    },
    follow_current_file = {
      enabled = true, -- Follow the current file when opened
    },
    group_empty_dirs = true, -- Group empty directories
    use_libuv_file_watcher = true, -- Use more efficient file watcher
    
    -- Add helpful commands
    commands = {
      -- Override delete to use trash instead of permanently deleting files
      delete = function(state)
        local path = state.tree:get_node().path
        vim.fn.system({ "trash", vim.fn.fnameescape(path) })
        require("neo-tree.sources.manager").refresh(state.name)
      end,
    },
  },
  
  -- Enhanced sorting behavior
  sort_case_insensitive = true,
  sort_function = function(a, b)
    -- Sort directories before files
    if a.type == "directory" and b.type ~= "directory" then
      return true
    elseif a.type ~= "directory" and b.type == "directory" then
      return false
    end
    return a.path:lower() < b.path:lower()
  end,
})
