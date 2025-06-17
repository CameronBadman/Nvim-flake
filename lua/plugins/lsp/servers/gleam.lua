-- lua/plugins/lsp/servers/gleam.lua
local lspconfig = require('lspconfig')
local keymaps = require('lua.plugins.lsp.keymaps')
local format = require('lua.plugins.lsp.format')

local M = {}

function M.setup()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- Gleam format settings (Gleam has opinionated formatting built-in)
    local format_opts = {
        async = false,
        format_on_save = true,
        timeout_ms = 3000,
    }

    -- Function to ensure gleam.toml exists for project configuration
    local function ensure_gleam_project()
        local gleam_toml = vim.fn.getcwd() .. '/gleam.toml'
        if vim.fn.filereadable(gleam_toml) == 0 then
            vim.notify("No gleam.toml found. Run 'gleam new project_name' to create a Gleam project.", vim.log.levels.WARN)
        end
    end

    -- Function to check if we're in a valid Gleam project
    local function is_gleam_project()
        return vim.fn.filereadable(vim.fn.getcwd() .. '/gleam.toml') == 1
    end

    lspconfig.gleam.setup({
        capabilities = capabilities,
        cmd = { "gleam", "lsp" },
        filetypes = { "gleam" },
        root_dir = function(fname)
            -- Look for gleam.toml to identify project root
            return lspconfig.util.root_pattern("gleam.toml", ".git")(fname) or
                   vim.fn.getcwd()
        end,
        settings = {
            gleam = {
                -- Enable all diagnostics
                diagnostics = {
                    enable = true,
                },
                -- Enable completion
                completion = {
                    enable = true,
                },
                -- Enable hover information
                hover = {
                    enable = true,
                },
            }
        },
        on_attach = function(client, bufnr)
            -- Set up keymaps
            keymaps.set_keymaps(client, bufnr)
            
            -- Set up formatting with Gleam-specific options
            format.setup(client, bufnr, format_opts)
            
            -- Ensure we're in a valid Gleam project
            vim.defer_fn(function()
                ensure_gleam_project()
            end, 1000)
            
            -- Add formatting on save (Gleam's built-in formatter)
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    if is_gleam_project() then
                        -- Use Gleam's built-in formatter via LSP
                        vim.lsp.buf.format({ 
                            bufnr = bufnr,
                            timeout_ms = 3000
                        })
                    end
                end
            })
            
            -- Show diagnostics in hover
            vim.api.nvim_create_autocmd("CursorHold", {
                buffer = bufnr,
                callback = function()
                    local opts = {
                        focusable = false,
                        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                        border = 'rounded',
                        source = 'always',
                        prefix = ' ',
                        scope = 'cursor',
                    }
                    vim.diagnostic.open_float(nil, opts)
                end
            })


        end,
        init_options = {
            -- Gleam LSP doesn't have many init options currently
            -- Most configuration is done via gleam.toml in the project
        }
    })
    
    -- Debug print to check if gleam setup is being called
    print("Gleam LSP setup completed")
end

return M
