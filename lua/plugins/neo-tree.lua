require('neo-tree').setup({
  close_if_last_window = true,
  enable_git_status = true,
  enable_diagnostics = true,
  
  -- Force refresh more often
  enable_refresh_on_write = true,
  
  -- Improved appearance settings
  window = {
    width = 30,
    position = "left",
    mapping_options = {
      noremap = true,
      nowait = true,
    },
    mappings = {
      -- Add manual refresh mapping
      ["R"] = "refresh",
      ["<F5>"] = "refresh",
    },
  },
  
  -- Enhanced icons and symbols
  default_component_configs = {
    container = {
      enable_character_fade = true,
    },
    indent = {
      indent_size = 2,
      padding = 1,
      with_markers = true,
      indent_marker = "│",
      last_indent_marker = "└",
      highlight = "NeoTreeIndentMarker",
      with_expanders = nil,
      expander_collapsed = "",
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",
    },
    icon = {
      folder_closed = "",
      folder_open = "",
      folder_empty = "󰜌",
      folder_empty_open = "󰜌",
      default = "󰈚",
      highlight = "NeoTreeFileIcon"
    },
    modified = {
      symbol = "[+]",
      highlight = "NeoTreeModified",
    },
    name = {
      trailing_slash = false,
      use_git_status_colors = true,
      highlight = "NeoTreeFileName",
    },
    git_status = {
      symbols = {
        -- Change type
        added     = "✚", -- or "✚", but I like the filled circle
        modified  = "", -- or "", but this is cleaner
        deleted   = "✖", -- or ""
        renamed   = "󰁕", -- or ""
        -- Status type
        untracked = "", -- or ""
        ignored   = "", -- or ""
        unstaged  = "󰄱", -- or ""
        staged    = "", -- or ""
        conflict  = "", -- or ""
      }
    },
    file_size = {
      enabled = true,
      required_width = 64, -- min width of window required to show this column
    },
    type = {
      enabled = true,
      required_width = 122, -- min width of window required to show this column
    },
    last_modified = {
      enabled = true,
      required_width = 88, -- min width of window required to show this column
    },
    created = {
      enabled = true,
      required_width = 110, -- min width of window required to show this column
    },
    symlink_target = {
      enabled = false,
    },
  },
  
  -- File system settings with enhanced watching
  filesystem = {
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = false,
      always_show = {
        ".gitignore",
        ".env",
      },
      never_show = {
        ".DS_Store",
        "thumbs.db",
      },
    },
    follow_current_file = {
      enabled = true,
      leave_dirs_open = false, -- Close dirs when leaving them
    },
    group_empty_dirs = true,
    
    -- Enhanced file watching for sudo scenarios
    use_libuv_file_watcher = true,
    scan_mode = "deep", -- Scan deeper into directories
    
    -- Commands with better delete handling
    commands = {
      -- Smart delete command with fallbacks
      delete = function(state)
        local path = state.tree:get_node().path
        local name = vim.fn.fnamemodify(path, ':t')
        
        -- Confirm deletion
        local choice = vim.fn.confirm(
          "Delete " .. name .. "?",
          "&Yes\n&No",
          2
        )
        
        if choice ~= 1 then
          return
        end
        
        -- Try different deletion methods
        local success = false
        
        -- Method 1: Try trash command (safest)
        if vim.fn.executable('trash') == 1 then
          local result = vim.fn.system({ "trash", vim.fn.fnameescape(path) })
          if vim.v.shell_error == 0 then
            success = true
            vim.notify("Moved to trash: " .. name, vim.log.levels.INFO)
          end
        end
        
        -- Method 2: Try trash-put (Linux)
        if not success and vim.fn.executable('trash-put') == 1 then
          local result = vim.fn.system({ "trash-put", vim.fn.fnameescape(path) })
          if vim.v.shell_error == 0 then
            success = true
            vim.notify("Moved to trash: " .. name, vim.log.levels.INFO)
          end
        end
        
        -- Method 3: Try gio trash (GNOME/Linux)
        if not success and vim.fn.executable('gio') == 1 then
          local result = vim.fn.system({ "gio", "trash", vim.fn.fnameescape(path) })
          if vim.v.shell_error == 0 then
            success = true
            vim.notify("Moved to trash: " .. name, vim.log.levels.INFO)
          end
        end
        
        -- Method 4: Permanent deletion as last resort
        if not success then
          local confirm_permanent = vim.fn.confirm(
            "No trash command available. PERMANENTLY delete " .. name .. "?",
            "&Yes, delete permanently\n&Cancel",
            2
          )
          
          if confirm_permanent == 1 then
            if vim.fn.isdirectory(path) == 1 then
              vim.fn.system({ "rm", "-rf", vim.fn.fnameescape(path) })
            else
              vim.fn.system({ "rm", "-f", vim.fn.fnameescape(path) })
            end
            
            if vim.v.shell_error == 0 then
              success = true
              vim.notify("Permanently deleted: " .. name, vim.log.levels.WARN)
            else
              vim.notify("Failed to delete: " .. name, vim.log.levels.ERROR)
            end
          end
        end
        
        -- Refresh neo-tree if deletion was successful
        if success then
          require("neo-tree.sources.manager").refresh(state.name)
        end
      end,
      
      -- Add a force refresh command
      force_refresh = function(state)
        require("neo-tree.sources.manager").refresh(state.name)
        vim.notify("Neo-tree refreshed", vim.log.levels.INFO)
      end,
    },
    
    window = {
      mappings = {
        -- Map Ctrl+R to force refresh
        ["<C-r>"] = "force_refresh",
        -- Git operations
        ["ga"] = "git_add_file",
        ["gr"] = "git_revert_file", 
        ["gu"] = "git_unstage_file",
        -- File operations
        ["<bs>"] = "navigate_up",
        ["."] = "set_root",
        ["H"] = "toggle_hidden",
        ["/"] = "fuzzy_finder",
        ["D"] = "fuzzy_finder_directory",
        ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
        ["f"] = "filter_on_submit",
        ["<c-x>"] = "clear_filter",
        ["[g"] = "prev_git_modified",
        ["]g"] = "next_git_modified",
        ["o"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" } },
        ["oc"] = { "order_by_created", nowait = false },
        ["od"] = { "order_by_diagnostics", nowait = false },
        ["og"] = { "order_by_git_status", nowait = false },
        ["om"] = { "order_by_modified", nowait = false },
        ["on"] = { "order_by_name", nowait = false },
        ["os"] = { "order_by_size", nowait = false },
        ["ot"] = { "order_by_type", nowait = false },
      },
    },
  },
  
  -- Git source configuration for better sudo compatibility
  git_status = {
    window = {
      position = "float",
      mappings = {
        ["A"] = "git_add_all",
        ["gu"] = "git_unstage_file",
        ["ga"] = "git_add_file",
        ["gr"] = "git_revert_file",
        ["gc"] = "git_commit",
        ["gp"] = "git_push",
        ["gg"] = "git_commit_and_push",
      },
    },
  },
  
  -- Enhanced sorting behavior
  sort_case_insensitive = true,
  sort_function = function(a, b)
    if a.type == "directory" and b.type ~= "directory" then
      return true
    elseif a.type ~= "directory" and b.type == "directory" then
      return false
    end
    return a.path:lower() < b.path:lower()
  end,
})

-- Helper function to safely refresh neo-tree
local function safe_refresh_neotree(source_name)
  -- First check if neo-tree is even loaded
  local neotree_ok = pcall(require, "neo-tree")
  if not neotree_ok then
    return false
  end
  
  -- Check if manager is available
  local manager_ok, manager = pcall(require, "neo-tree.sources.manager")
  if not manager_ok or not manager then
    return false
  end
  
  -- Check if the manager has the get_state function and if states are initialized
  if not manager.get_state then
    return false
  end
  
  -- Try to get state, but catch any errors from state creation
  local state_ok, state = pcall(manager.get_state, source_name)
  if not state_ok or not state or not state.tree then
    return false
  end
  
  -- Finally, try to refresh
  local refresh_ok = pcall(manager.refresh, source_name)
  return refresh_ok
end

-- Auto-refresh neo-tree when files change (simplified version)
vim.api.nvim_create_autocmd({"BufWritePost"}, {
  callback = function()
    -- Only refresh if neo-tree window is actually visible
    for _, win in pairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local buf_name = vim.api.nvim_buf_get_name(buf)
      if string.match(buf_name, "neo%-tree") then
        -- Neo-tree is visible, try to refresh after a delay
        vim.defer_fn(function()
          safe_refresh_neotree("filesystem")
        end, 500)
        break
      end
    end
  end,
})

-- Simple refresh command you can run manually if needed
vim.api.nvim_create_user_command('NeoTreeRefresh', function()
  safe_refresh_neotree("filesystem")
  safe_refresh_neotree("git_status")
end, {})
