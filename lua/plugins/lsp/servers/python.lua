-- lua/plugins/lsp/servers/python.lua
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local keymaps = require('lua.plugins.lsp.keymaps')
local format = require('lua.plugins.lsp.format')
local M = {}

function M.setup()
    -- Python-specific format settings
    local format_opts = {
        async = true,
        format_on_save = false,
        timeout_ms = 3000,
        formatting_options = {
            line_length = 88,  -- Black default
            indent_size = 4,
        }
    }

    -- Pyright setup for type checking
    lspconfig.pyright.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            keymaps.set_keymaps(client, bufnr)
            -- Pyright doesn't handle formatting, so we don't set up format here
        end,
        settings = {
            python = {
                analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = "workspace",
                    useLibraryCodeForTypes = true,
                    typeCheckingMode = "strict",
                    inlayHints = {
                        variableTypes = true,
                        functionReturnTypes = true,
                    },
                    strictListInference = true,
                    strictDictionaryInference = true,
                    strictSetInference = true,
                    strictParameterNoneValue = true,
                    enableTypeIgnoreComments = true,
                    -- Set diagnostic severities for pyright
                    diagnosticSeverityOverrides = {
                        -- Type checking errors
                        reportGeneralTypeIssues = "error",
                        reportPropertyTypeMismatch = "error",
                        reportFunctionMemberAccess = "error",
                        -- Warnings
                        reportOptionalMemberAccess = "warning",
                        reportOptionalSubscript = "warning",
                        reportPrivateUsage = "warning",
                        -- Info
                        reportUnusedImport = "information",
                        reportUnusedVariable = "information",
                        -- Hints
                        reportUnusedFunction = "hint",
                        reportUnusedClass = "hint",
                    },
                },
            },
        },
    })

    -- Ruff setup for linting and formatting
    lspconfig.ruff.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            keymaps.set_keymaps(client, bufnr)
            -- Set up formatting with Python-specific options
            format.setup(client, bufnr, format_opts)
        end,
        settings = {
            ruff = {
                lineLength = format_opts.formatting_options.line_length,
                select = {
                    "E",   -- pycodestyle errors
                    "F",   -- pyflakes
                    "I",   -- isort
                    "N",   -- pep8-naming
                    "UP",  -- pyupgrade
                    "B",   -- flake8-bugbear
                    "C4",  -- flake8-comprehensions
                    "DTZ", -- flake8-datetimez
                    "ISC", -- flake8-implicit-str-concat
                    "PIE", -- flake8-pie
                    "T20", -- flake8-print
                    "RET", -- flake8-return
                    "SIM", -- flake8-simplify
                    "PTH", -- flake8-use-pathlib
                    "PL",  -- pylint
                    "RUF", -- ruff-specific rules
                },
                extendFixable = { "I" },
                targetVersion = "py311",
                organizeImports = {
                    combineAsImports = true,
                    extraStandardLibrary = {},
                    relativeImportsOrder = "closest-to-furthest",
                    splitOnTrailingComma = true,
                },
                -- Add severity mappings for ruff
                severities = {
                    -- Errors (red)
                    ["E"] = "ERROR",    -- pycodestyle errors
                    ["F"] = "ERROR",    -- pyflakes errors
                    ["B"] = "ERROR",    -- flake8-bugbear errors

                    -- Warnings (yellow)
                    ["W"] = "WARNING",  -- pycodestyle warnings
                    ["C4"] = "WARNING", -- comprehension warnings
                    ["PIE"] = "WARNING", -- pie warnings
                    ["RET"] = "WARNING", -- return warnings

                    -- Info (blue)
                    ["I"] = "INFO",     -- isort formatting
                    ["UP"] = "INFO",    -- pyupgrade suggestions
                    ["RUF"] = "INFO",   -- ruff-specific info

                    -- Hints (teal)
                    ["F401"] = "HINT",  -- unused imports
                    ["F841"] = "HINT",  -- unused variables
                    ["N"] = "HINT",     -- naming suggestions
                    ["SIM"] = "HINT",   -- simplification suggestions
                    ["PTH"] = "HINT",   -- pathlib suggestions
                },
            },
        },
    })
end

return M
