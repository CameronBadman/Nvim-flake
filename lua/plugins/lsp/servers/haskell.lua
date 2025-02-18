-- lua/plugins/lsp/servers/haskell.lua
local lspconfig = require('lspconfig')
local keymaps = require('lua.plugins.lsp.keymaps')
local format = require('lua.plugins.lsp.format')

local M = {}

function M.setup()
    -- Haskell-specific format settings
    local format_opts = {
        async = true,
        format_on_save = false,
        timeout_ms = 3000,
        formatting_options = {
            tabWidth = 2,
            maxBindingLength = 40,
        }
    }

    -- Haskell Language Server setup
    lspconfig.hls.setup({
        on_attach = function(client, bufnr)
            keymaps.set_keymaps(client, bufnr)
            
            -- Set up formatting with Haskell-specific options
            format.setup(client, bufnr, format_opts)
            
            -- Format on save
            if format_opts.format_on_save then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({
                            async = format_opts.async,
                            bufnr = bufnr,
                            filter = function(fmt_client)
                                return fmt_client.id == client.id
                            end
                        })
                    end
                })
            end
        end,
        settings = {
            haskell = {
                checkProject = true,
                formattingProvider = "ormolu",
                plugin = {
                    hlint = {
                        globalOn = true,
                        diagnosticsOn = true,
                        codeActionsOn = true,
                    },
                    ['ghcide-type-lenses'] = {
                        globalOn = true,
                        config = {
                            mode = "always",
                        }
                    },
                }
            }
        },
        flags = {
            debounce_text_changes = 150,
        }
    })
end

return M
