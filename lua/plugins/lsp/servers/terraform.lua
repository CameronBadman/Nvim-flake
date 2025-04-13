-- lua/plugins/lsp/servers/terraform.lua
local M = {}

function M.setup()
  local lspconfig = require('lspconfig')
  
  -- Simple terraform-ls setup WITHOUT LSP formatting
  lspconfig.terraformls.setup({
    filetypes = { "terraform", "tf", "terraform-vars", "hcl" },
    root_dir = lspconfig.util.root_pattern(".terraform", "*.tf", "*.tfvars", ".git"),
    settings = {
      terraform = {
        -- Disable LSP-based formatting
        format = { enable = false },
        experimentalFeatures = {
          validateOnSave = true
        }
      }
    }
  })
  
  -- Set up terraform fmt on save
  vim.api.nvim_create_augroup("TerraformFormatting", { clear = true })
  
  -- This runs after the file is saved
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = "TerraformFormatting",
    pattern = {"*.tf", "*.tfvars"},
    callback = function()
      -- Get file path and cursor info
      local file = vim.fn.expand('%:p')
      local cursor_pos = vim.api.nvim_win_get_cursor(0)
      local view = vim.fn.winsaveview()
      
      -- Run terraform fmt
      vim.fn.jobstart('terraform fmt ' .. vim.fn.shellescape(file), {
        on_exit = function(_, code)
          if code == 0 then
            -- Only reload if formatting succeeded
            vim.schedule(function()
              -- Reload the file content
              vim.cmd('edit!')
              
              -- Restore cursor and view
              vim.fn.winrestview(view)
              pcall(function() vim.api.nvim_win_set_cursor(0, cursor_pos) end)
              
              vim.notify("Terraform file formatted", vim.log.levels.INFO)
            end)
          end
        end
      })
    end
  })
  
  -- Also format before writing as a safeguard
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = "TerraformFormatting",
    pattern = {"*.tf", "*.tfvars"},
    callback = function()
      -- We're using BufWritePost as the primary method, but also try
      -- to format pre-write as a fallback
      local file = vim.fn.expand('%:p')
      vim.fn.system('terraform fmt ' .. vim.fn.shellescape(file))
    end
  })
  
  -- Basic filetype detection
  vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = {"*.tf", "*.tfvars"},
    callback = function()
      vim.bo.filetype = "terraform"
    end
  })
  
  vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = {"*.hcl"},
    callback = function()
      vim.bo.filetype = "hcl"
    end
  })
  
  -- Add manual format command as a fallback
  vim.api.nvim_create_user_command("TerraformFormat", function()
    local file = vim.fn.expand('%')
    vim.fn.system('terraform fmt ' .. vim.fn.shellescape(file))
    vim.cmd('checktime')
  end, {})
end

return M
