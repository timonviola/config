return {
    "neovim/nvim-lspconfig",
    version = "^2.0.0",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
        { "folke/neodev.nvim",                   opts = {} },
    },
    config = function()
        -- import lspconfig plugin
        local lspconfig = require("lspconfig")

        -- import mason_lspconfig plugin
        local mason_lspconfig = require("mason-lspconfig")

        -- import cmp-nvim-lsp plugin
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        local keymap = vim.keymap -- for conciseness

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local opts = { buffer = ev.buf, silent = true }

                -- set keybinds
                opts.desc = "Show LSP references"
                keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

                opts.desc = "Go to declaration"
                keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

                opts.desc = "Show LSP definitions"
                keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions
                --    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)

                opts.desc = "Show LSP implementations"
                keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

                opts.desc = "Show LSP type definitions"
                keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

                opts.desc = "See available code actions"
                keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

                opts.desc = "Show references"
                keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)

                opts.desc = "Smart rename"
                keymap.set("n", "<F2>", vim.lsp.buf.rename, opts) -- smart rename

                opts.desc = "Show signature help"
                keymap.set("n", "<leader>h", function() vim.lsp.buf.signature_help() end, opts)

                opts.desc = "Show buffer diagnostics"
                keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

                opts.desc = "Show line diagnostics"
                keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

                opts.desc = "Go to previous diagnostic"
                keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

                opts.desc = "Go to next diagnostic"
                keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

                opts.desc = "Show documentation for what is under cursor"
                keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

                opts.desc = "Restart LSP"
                keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

                opts.desc = "Workspace symbols"
                keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)

                opts.desc = "Format"
                keymap.set({ "n", "x" }, "<F3>", function() vim.lsp.buf.format({ async = false, timeout_ms = 5000 }) end,
                    opts)
            end,
        })

        -- Auto format on save using LSP native format()
        vim.api.nvim_create_autocmd("BufWritePre", {
            callback = function()
                local mode = vim.api.nvim_get_mode().mode
                local filetype = vim.bo.filetype
                if vim.bo.modified == true and mode == 'n' then
                    vim.cmd('lua vim.lsp.buf.format()')
                else
                end
            end
        })


        -- used to enable autocompletion (assign to every lsp server config)
        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- Change the Diagnostic symbols in the sign column (gutter)
        -- (not in youtube nvim video)
        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }

        local signConf = {
            text = {},
            texthl = {},
            numhl = {},
        }
        for type, icon in pairs(signs) do
            local severityName = string.upper(type)
            local severity = vim.diagnostic.severity[severityName]
            local hl = "DiagnosticSign" .. type
            signConf.text[severity] = icon
            signConf.texthl[severity] = hl
            signConf.numhl[severity] = hl
        end

        vim.diagnostic.config({
            signs = signConf,
        })
    end,
}
