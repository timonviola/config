return {
    {
        "j-hui/fidget.nvim",
        opts = {}
    },
    {
        "scalameta/nvim-metals",
        lazy = true,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "mfussenegger/nvim-dap",
        }
    },
    { "kevinhwang91/nvim-bqf" },
    {
        "nvim-telescope/telescope.nvim",
        lazy = true,
        dependencies = {
            { "nvim-lua/popup.nvim" },
            { "nvim-lua/plenary.nvim" },
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        },
        extensions = {
            fzf = {
                fuzzy = true,                   -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true,    -- override the file sorter
                case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                -- the default case_mode is "smart_case"
            }
        },
        config = function()
            local telescope = require('telescope')
            telescope.load_extension('fzf')
            telescope.setup {
                defaults = {
                    -- Default configuration for telescope goes here:
                    layout_config = {
                        -- Enable line numbers
                        prompt_position = "top",
                        preview_cutoff = 120,
                    },
                    file_ignore_patterns = {
                        "^project/",
                        "^target/",
                    },
                }
            }
        end
    },
    { "hrsh7th/cmp-nvim-lsp", lazy = true },
    { "hrsh7th/cmp-path",     lazy = true },
    { "hrsh7th/cmp-buffer",   lazy = true },
    { "hrsh7th/cmp-omni",     lazy = true },
    { "hrsh7th/cmp-cmdline",  lazy = true },
    {
        "quangnguyen30192/cmp-nvim-ultisnips",
        lazy = true,
        dependencies = { 'sirver/ultisnips' }
    },
    {
        "hrsh7th/nvim-cmp",
        name = "nvim-cmp",
        event = "VeryLazy",
        config = function()
            require("plugins.config.nvim-cmp")
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        options = { theme = 'tokyonight' },
        config = function()
            require("lualine").setup {
                options = {
                    theme = 'auto',
                    section_separators = { '', '' },
                    component_separators = { '|', '|' },
                },
                sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { { 'filename', { path = 1 } } },
                    lualine_x = { 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location', 'mode' },
                },
                inactive_sections = {
                    lualine_b = {},
                    lualine_c = { { 'filename', { path = 1 } } },
                    lualine_x = { 'location' },
                    tabline = {
                        { lualine_b = { 'branch' } },
                    }
                }
            }
        end
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
        -- use opts = {} for passing setup options
        -- this is equivalent to setup({}) function
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("plugins.config.lsp")
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        config = function()
            require("treesitter-context").setup {
                enable = true,
                max_lines = 1
            }
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        config = function()
            require("treesitter-context").setup {
                enable = true,
                max_lines = 1
            }
        end,
    },
    {
        'tpope/vim-fugitive',
        config = function()
            vim.keymap.set("n", "<leader>gs", vim.cmd.Git);
        end,
    },

    {
        'rcarriga/nvim-notify',
        config = function()
            require("notify").setup({
            })
        end,
    },

    {
        'mrcjkb/rustaceanvim',
        version = '^6', -- Recommended
        lazy = false,   -- This plugin is already lazy
    },
    {
        'mbbill/undotree',
        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end,
    },
    -- allows me to open netrw with '-'
    -- and makes netwr easier for me
    --:help vinegar
    'tpope/vim-vinegar',
    {
        "qvalentin/helm-ls.nvim",
        ft = "helm",
        opts = {
            conceal_templates = {
                -- enable the replacement of templates with virtual text of their current values
                enabled = true, -- tree-sitter must be setup for this feature
            },
            indent_hints = {
                -- enable hints for indent and nindent functions
                enabled = true, -- tree-sitter must be setup for this feature
            },
        },
    },
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("kanagawa").setup({
                colors = {
                    theme = {
                        all = {
                            ui = {
                                bg_gutter = "none",
                            },
                        },
                    },
                },
            })

            vim.cmd.colorscheme("kanagawa")
            local kanagawa_colors = require("kanagawa.colors").setup()

            vim.cmd(string.format([[hi! StatusLine guifg=%s guibg=%s]], kanagawa_colors.palette.fujiWhite,
                kanagawa_colors.palette.sumiInk3))

            vim.cmd([[hi! link StatusLineNC Comment]])
            vim.cmd([[hi! link StatusError DiagnosticError]])
            vim.cmd([[hi! link StatusWarn DiagnosticWarn]])
            vim.cmd([[hi! link WinSeparator Comment]])

            local kanagawa_group = vim.api.nvim_create_augroup("kanagawa", { clear = true })
            vim.api.nvim_create_autocmd("TextYankPost", {
                pattern = "*",
                callback = function()
                    vim.highlight.on_yank()
                end,
                group = kanagawa_group,
            })
        end
    },
    {
        "timonviola/wezterm-colorsync.nvim",
        config = function()
            require("colorsync").setup()
        end
    },
}
