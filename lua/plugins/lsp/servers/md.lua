-- lua/plugins/lsp/servers/md.lua
local lspconfig = require('lspconfig')
local keymaps = require('lua.plugins.lsp.keymaps')
local format = require('lua.plugins.lsp.format')

local M = {}

function M.setup()
    -- Get capabilities directly from cmp_nvim_lsp to avoid lsp-zero conflicts
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local util = require('lspconfig/util')

    -- Markdown-specific format settings
    local format_opts = {
        async = false,
        format_on_save = true,
        timeout_ms = 3000,
        formatting_options = {
            tabSize = 2,
            insertSpaces = true,
        }
    }

    -- Configure marksman - dedicated Markdown language server
    lspconfig.marksman.setup({
        capabilities = capabilities,
        filetypes = { "markdown", "markdown.mdx" },
        root_dir = util.root_pattern(".git", ".marksman.toml"),
        on_attach = function(client, bufnr)
            -- Set up keymaps
            keymaps.set_keymaps(client, bufnr)
            
            -- Set up formatting
            format.setup(client, bufnr, format_opts)
            
            -- Set markdown-specific options
            vim.api.nvim_buf_set_option(bufnr, 'conceallevel', 0)
            vim.api.nvim_buf_set_option(bufnr, 'wrap', true)
            vim.api.nvim_buf_set_option(bufnr, 'spell', true)
            vim.api.nvim_buf_set_option(bufnr, 'spelllang', 'en_us')
            
            -- Add markdown-specific keymaps
            vim.keymap.set('n', '<leader>mp', ':MarkdownPreview<CR>', 
                { buffer = bufnr, desc = "Markdown Preview" })
            
            vim.keymap.set('n', '<leader>mt', ':TableModeToggle<CR>', 
                { buffer = bufnr, desc = "Toggle Table Mode" })
        end
    })
    
    -- Configure efm server using the Nix-provided wrapper
    lspconfig.efm.setup({
        capabilities = capabilities,
        cmd = { "efm-langserver-markdown" },  -- Use wrapper script from Nix
        filetypes = { "markdown", "markdown.mdx" },
        root_dir = util.root_pattern(".git"),
        on_attach = function(client, bufnr)
            -- Only attach format capability for efm
            client.server_capabilities.documentFormattingProvider = true
            
            -- Clear document highlighting capability to avoid conflict with marksman
            client.server_capabilities.documentHighlightProvider = false
            
            -- Add formatting on save with efm
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    -- Format the file
                    vim.lsp.buf.format({ 
                        bufnr = bufnr,
                        timeout_ms = 3000,
                        filter = function(fmt_client)
                            return fmt_client.name == "efm"
                        end
                    })
                end
            })
        end
    })
    
    -- Configure ltex-ls for spelling and grammar (if installed)
    pcall(function()
        lspconfig.ltex.setup({
            capabilities = capabilities,
            filetypes = { "markdown", "markdown.mdx", "text" },
            root_dir = util.root_pattern(".git"),
            settings = {
                ltex = {
                    enabled = { "markdown", "text" },
                    language = "en-US",
                    diagnosticSeverity = "information",
                    checkFrequency = "save"
                }
            },
            on_attach = function(client, bufnr)
                -- Only enable spelling/grammar checking
                client.server_capabilities.documentFormattingProvider = false
            end
        })
    end)

    -- Set up a simple autocmd for markdown file type detection
    vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        pattern = { '*.md', '*.markdown', '*.mdx' },
        callback = function(ev)
            vim.bo[ev.buf].filetype = 'markdown'
        end
    })
end

return M
