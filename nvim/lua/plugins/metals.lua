-- Most of this configuration is based on:
-- Reference: https://github.com/ckipp01/dots/blob/master/nvim/.config/nvim/lua/mesopotamia/lsp.lua

-- Self-contained side-effect function that:
-- 1. invoke DAP
-- 2. configure DAP for scala
-- 3. configure DAP keymap
-- 4. configure metals with `setup_dap`
local configure_dap = function()
    print("configure_dap")
    -- nvim-dap
    -- I only use nvim-dap with Scala, so we keep it all in here
    local dap = require("dap")

    dap.configurations.scala = {
        {
            type = "scala",
            request = "launch",
            name = "Run or test with input",
            metals = {
                runType = "runOrTestFile",
                args = function()
                    local args_string = vim.fn.input("Arguments: ")
                    return vim.split(args_string, " +")
                end,
            },
        },
        {
            type = "scala",
            request = "launch",
            name = "Run or Test",
            metals = {
                runType = "runOrTestFile",
            },
        },
        {
            type = "scala",
            request = "launch",
            name = "Test Target",
            metals = {
                runType = "testTarget",
            },
        },
        {
            type = "scala",
            request = "launch",
            name = "Run minimal2 main",
            metals = {
                mainClass = "minimal2.Main",
                buildTarget = "minimal",
            },
        },
    }

    vim.keymap.set("n", "<leader>dc", require("dap").continue)
    vim.keymap.set("n", "<leader>dr", require("dap").repl.toggle)
    vim.keymap.set("n", "<leader>dK", require("dap.ui.widgets").hover)
    vim.keymap.set("n", "<leader>dtb", require("dap").toggle_breakpoint)
    vim.keymap.set("n", "<leader>dso", require("dap").step_over)
    vim.keymap.set("n", "<leader>dsi", require("dap").step_into)
    vim.keymap.set("n", "<leader>drl", require("dap").run_last)

    vim.keymap.set("n", "<leader>dtc", function()
        require("dap").toggle_breakpoint("x == 3")
    end)

    dap.listeners.after["event_terminated"]["nvim-metals"] = function()
        vim.notify("dap finished!")
        --dap.repl.open()
    end

    require("metals").setup_dap()
end

return {
    "scalameta/nvim-metals",
    dependencies = {
        {
            "nvim-lua/plenary.nvim",
            "mfussenegger/nvim-dap",
            "j-hui/fidget.nvim",
            opts = {},
        },
        {
            "mfussenegger/nvim-dap",
            config = function(self, opts)
                -- Debug settings if you're using nvim-dap
                local dap = require("dap")

                dap.configurations.scala = {
                    {
                        type = "scala",
                        request = "launch",
                        name = "RunOrTest",
                        metals = {
                            runType = "runOrTestFile",
                            --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
                        },
                    },
                    {
                        type = "scala",
                        request = "launch",
                        name = "Test Target",
                        metals = {
                            runType = "testTarget",
                        },
                    },
                }
            end
        },
    },
    ft = { "scala", "sbt", "java" },
    opts = function()
        local metals_config = require("metals").bare_config()

        metals_config.settings = {
            serverVersion = "1.6.7",
            defaultBspToBuildTool = true,
            enableSemanticHighlighting = false,
            inlayHints = {
                byNameParameters = { enable = true },
                hintsInPatternMatch = { enable = true },
                implicitArguments = { enable = true },
                implicitConversions = { enable = true },
                inferredTypes = { enable = true },
                typeParameters = { enable = true },

            },
        }

        metals_config.init_options = {
            statusBarProvider = "off",
            icons = "unicode"
        }
        metals_config.tvp = {
            icons = {
                enabled = true,
            },
        }

        -- Example if you are using cmp how to make sure the correct capabilities for snippets are set
        metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

        metals_config.on_attach = function(client, bufnr)
            require("metals").setup_dap()


            -- LSP mappings
            vim.keymap.set("n", "gD", vim.lsp.buf.definition)
            vim.keymap.set("n", "K", vim.lsp.buf.hover)
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
            vim.keymap.set("n", "gr", vim.lsp.buf.references)
            vim.keymap.set("n", "gds", vim.lsp.buf.document_symbol)
            vim.keymap.set("n", "gws", vim.lsp.buf.workspace_symbol)
            vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run)
            vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
            vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
            vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action)
            vim.keymap.set("n", "<leader>h", function()
                if client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                else
                    vim.notify("Server is not an inlayhint provider", vim.log.levels.ERROR)
                end
            end)
            vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
            -- More metals specific maps and autocmd
            vim.keymap.set("v", "K", require("metals").type_of_range)

            vim.keymap.set("n", "<leader>ws", function()
                require("metals").hover_worksheet({ border = "single" })
            end)

            vim.keymap.set("n", "<leader>tt", require("metals.tvp").toggle_tree_view)

            vim.keymap.set("n", "<leader>tr", require("metals.tvp").reveal_in_tree)

            vim.keymap.set("n", "<leader>mmc", require("metals").commands)

            -- A lot of the servers I use won't support document_highlight or codelens,
            -- so we just use them in Metals
            local lsp_group = vim.api.nvim_create_augroup("lsp", { clear = true })
            vim.api.nvim_create_autocmd("CursorHold", {
                callback = vim.lsp.buf.document_highlight,
                buffer = bufnr,
                group = lsp_group,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
                callback = function()
                    vim.lsp.buf.clear_references()
                end,
                buffer = bufnr,
                group = lsp_group,
            })
            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
                callback = vim.lsp.codelens.refresh,
                buffer = bufnr,
                group = lsp_group,
            })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "dap-repl" },
                callback = function()
                    require("dap.ext.autocompl").attach()
                end,
                group = lsp_group,
            })
            configure_dap()
        end

        -- Show metals commands in telescope
        vim.keymap.set("n", "<leader>mc", require("telescope").extensions.metals.commands)
        return metals_config
    end,
    config = function(self, metals_config)
        local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
            pattern = self.ft,
            callback = function()
                require("metals").initialize_or_attach(metals_config)
            end,
            group = nvim_metals_group,
        })
    end

}
