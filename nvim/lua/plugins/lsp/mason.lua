return {
    'williamboman/mason.nvim',
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    },
    config = function()
        -- import mason
        local mason = require("mason")

        -- import mason-lspconfig
        local mason_lspconfig = require("mason-lspconfig")

        -- enable mason and configure icons
        mason.setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        mason_lspconfig.setup({
            -- list of servers for mason to install
            ensure_installed = {
                'ts_ls',
                'rust_analyzer',
                'lua_ls',
                'basedpyright',
                'ruff'
            },
            handlers = {
--                lua_ls = function()
--                    require('lspconfig').lua_ls.setup()
--                end,
                pyright = function()
                    require('lspconfig').basedpyright.setup({
                        autoImportCompletion = true,
                        disableOrganizeImports = true,
                        python = { analysis = { autoSearchPaths = true, diagnosticMode = 'openFilesOnly', useLibraryCodeForTypes = true } }
                    })
                end,
                -- PyRight and ruff might not play along very nicely, here is some discussion on that:
                -- https://github.com/astral-sh/ruff-lsp/issues/177#issuecomment-1924924000
            }
        })
    end,
}
