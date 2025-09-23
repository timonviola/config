return {
    "nvim-lua/plenary.nvim", -- lua functions that many plugins use
    -- 'nvim-treesitter/playground',
    'tpope/vim-abolish',
    'tpope/vim-vinegar',
    -- fix: looks buggy 'timonviola/easy-to-change.nvim',
    'timonviola/easy-to-change.nvim',
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
}
