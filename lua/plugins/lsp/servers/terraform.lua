local M = {}

function M.setup()
  local lspconfig = require('lspconfig')
  local cmp_nvim_lsp = require('cmp_nvim_lsp')

  -- Enhanced capabilities with nvim-cmp
  local capabilities = cmp_nvim_lsp.default_capabilities()

  -- Terraform-ls setup with enhanced completion
  lspconfig.terraformls.setup({
    filetypes = { "terraform", "tf", "terraform-vars", "hcl" },
    root_dir = lspconfig.util.root_pattern(".terraform", "*.tf", "*.tfvars", ".git"),
    capabilities = capabilities,
    settings = {
      terraform = {
        -- Disable LSP-based formatting
        format = { enable = false },
        experimentalFeatures = {
          validateOnSave = true
        }
      }
    },
    -- Optional: Add custom on_attach for additional keymappings or configurations
    on_attach = function(client, bufnr)
      -- Example of setting up keymaps when LSP attaches
      local opts = { noremap = true, silent = true, buffer = bufnr }
      
      -- Common LSP keymaps
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    end
  })

  -- Existing formatting and filetype detection logic remains the same
  vim.api.nvim_create_augroup("TerraformFormatting", { clear = true })

  -- Post-save formatting
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = "TerraformFormatting",
    pattern = {"*.tf", "*.tfvars"},
    callback = function()
      local file = vim.fn.expand('%:p')
      local cursor_pos = vim.api.nvim_win_get_cursor(0)
      local view = vim.fn.winsaveview()

      vim.fn.jobstart('terraform fmt ' .. vim.fn.shellescape(file), {
        on_exit = function(_, code)
          if code == 0 then
            vim.schedule(function()
              vim.cmd('edit!')
              vim.fn.winrestview(view)
              pcall(function() vim.api.nvim_win_set_cursor(0, cursor_pos) end)
              vim.notify("Terraform file formatted", vim.log.levels.INFO)
            end)
          end
        end
      })
    end
  })

  -- Pre-write formatting safeguard
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = "TerraformFormatting",
    pattern = {"*.tf", "*.tfvars"},
    callback = function()
      local file = vim.fn.expand('%:p')
      vim.fn.system('terraform fmt ' .. vim.fn.shellescape(file))
    end
  })

  -- Filetype detection
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

  -- Manual format command
  vim.api.nvim_create_user_command("TerraformFormat", function()
    local file = vim.fn.expand('%')
    vim.fn.system('terraform fmt ' .. vim.fn.shellescape(file))
    vim.cmd('checktime')
  end, {})
end

return M
