return {
    "nvim-lua/plenary.nvim", -- lua functions that many plugins use
    -- 'nvim-treesitter/playground',
    'tpope/vim-abolish',
    -- fix: looks buggy 'timonviola/easy-to-change.nvim',
    'timonviola/easy-to-change.nvim',
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
            require("ibl").setup {}
        end
    },
}
