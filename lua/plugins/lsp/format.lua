local M = {}

-- Helper function to set up formatting for a client
function M.setup(client, bufnr, format_opts)
    if client.server_capabilities.documentFormattingProvider then
        -- Create format function with provided options
        local function format()
            vim.lsp.buf.format({
                bufnr = bufnr,
                async = format_opts.async or false,
                timeout_ms = format_opts.timeout_ms or 5000,
                filter = function(fmt_client)
                    return fmt_client.id == client.id
                end
            })
        end

        -- Set up format on save if enabled
        if format_opts.format_on_save then
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = format
            })
        end

        return format
    end
end

-- Generic format buffer function
function M.format_buffer()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.lsp.buf.format({
        async = false,
        timeout_ms = 5000,
        filter = function(client)
            return client.server_capabilities.documentFormattingProvider
        end
    })
end

return M
