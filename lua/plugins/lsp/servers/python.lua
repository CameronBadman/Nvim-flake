-- config/plugins/lsp/servers/python.lua
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Pyright setup for type checking
lspconfig.pyright.setup({
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "strict",
        inlayHints = {
          variableTypes = true,
          functionReturnTypes = true
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
          reportUnusedClass = "hint"
        }
      }
    }
  }
})

-- Ruff setup for linting
lspconfig.ruff.setup({
  capabilities = capabilities,
  settings = {
    ruff = {
      lineLength = 88,
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
        "RUF"  -- ruff-specific rules
      },
      extendFixable = {"I"},
      targetVersion = "py311",
      organizeImports = {
        combineAsImports = true,
        extraStandardLibrary = {},
        relativeImportsOrder = "closest-to-furthest",
        splitOnTrailingComma = true
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
        ["PTH"] = "HINT"    -- pathlib suggestions
      }
    }
  }
})
