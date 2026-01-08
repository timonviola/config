return {
    "nvim-lua/plenary.nvim", -- lua functions that many plugins use
    -- 'nvim-treesitter/playground',
    'tpope/vim-abolish',
    'tpope/vim-vinegar',
    -- fix: looks buggy 'timonviola/easy-to-change.nvim',
    {
        'timonviola/easy-to-change.nvim',
        config = function()
            require("etc").setup()
        end
    },
    {
        'timonviola/terraform-doc-browser.nvim',
        config = function()
            require("terraform-doc-browser").setup()
        end
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
        'zbirenbaum/copilot.lua',
        optional = true,
        opts = {
            filtetypes = { ["*"] = true },
        },
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        optional = true,
        opts = { show_help = false },
        -- See Commands section for default commands if you want to lazy load on them
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require("ibl").setup { indent = { highlight = highlight, char = "│" } }
        end
    },
    { "catppuccin/nvim", name = "catppuccin" },
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
        "sourcegraph/amp.nvim",
        branch = "main",
        lazy = false,
        opts = { auto_start = true, log_level = "info" },
    }
}
