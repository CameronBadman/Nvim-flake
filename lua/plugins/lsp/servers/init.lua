-- lua/plugins/lsp/servers/init.lua
-- Dynamic language server loader that detects symlinked language directories

local M = {}

-- Function to check if a path is a symlink
local function is_symlink(path)
  local stat = vim.loop.fs_lstat(path)
  return stat and stat.type == "link"
end

-- Function to check if a directory exists
local function dir_exists(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "directory"
end

-- Function to safely require a module and handle errors
local function safe_require(module_path)
  local ok, result = pcall(require, module_path)
  if not ok then
    vim.notify("Failed to load language configuration: " .. module_path .. "\nError: " .. result, vim.log.levels.WARN)
    return nil
  end
  return result
end

-- Get the directory where this init.lua file is located
local function get_servers_dir()
  local info = debug.getinfo(1, "S")
  local script_path = info.source:match("@?(.*)")
  return vim.fn.fnamemodify(script_path, ":h")
end

-- Main function to load all language configurations
function M.setup()
  local servers_dir = get_servers_dir()
  
  -- Get all items in the servers directory
  local handle = vim.loop.fs_scandir(servers_dir)
  if not handle then
    vim.notify("Could not scan LSP servers directory: " .. servers_dir, vim.log.levels.ERROR)
    return
  end
  
  -- Prepare shared modules for language configs
  local shared = {
    lspconfig = require("lspconfig"),
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    keymaps = nil,
    format = nil,
  }
  
  -- Try to load shared modules if they exist
  pcall(function() 
    shared.keymaps = require("plugins.lsp.keymaps") 
  end)
  pcall(function() 
    shared.format = require("plugins.lsp.format") 
  end)
  
  local loaded_languages = {}
  local failed_languages = {}
  
  while true do
    local name, type = vim.loop.fs_scandir_next(handle)
    if not name then break end
    
    -- Skip the init.lua file itself
    if name == "init.lua" then
      goto continue
    end
    
    local full_path = servers_dir .. "/" .. name
    
    -- Only process directories that are symlinks
    if type == "directory" and is_symlink(full_path) then
      local init_file = full_path .. "/init.lua"
      
      -- Check if the symlinked directory has an init.lua
      if vim.fn.filereadable(init_file) == 1 then
        -- Construct the module path for require()
        local module_path = "plugins.lsp.servers." .. name .. ".init"
        
        local lang_config = safe_require(module_path)
        if lang_config then
          -- If the module has a setup function, call it with shared modules
          if type(lang_config.setup) == "function" then
            local ok, err = pcall(lang_config.setup, shared)
            if ok then
              table.insert(loaded_languages, name)
            else
              table.insert(failed_languages, name .. " (setup failed: " .. err .. ")")
            end
          else
            table.insert(failed_languages, name .. " (no setup function)")
          end
        else
          table.insert(failed_languages, name .. " (require failed)")
        end
      else
        table.insert(failed_languages, name .. " (no init.lua found)")
      end
    end
    
    ::continue::
  end
  
  -- Report loading results
  if #loaded_languages > 0 then
    vim.notify("Loaded language servers: " .. table.concat(loaded_languages, ", "), vim.log.levels.INFO)
  end
  
  if #failed_languages > 0 then
    vim.notify("Failed to load: " .. table.concat(failed_languages, ", "), vim.log.levels.WARN)
  end
  
  if #loaded_languages == 0 and #failed_languages == 0 then
    vim.notify("No language-specific LSP configurations found (no symlinked directories)", vim.log.levels.INFO)
  end
end

return M
