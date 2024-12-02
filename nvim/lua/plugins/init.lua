return {
    -- Packer can manage itself
    'williamboman/mason.nvim',
    {
        'folke/tokyonight.nvim',
        -- lazy = true,
        priority = 1000,
        opts = {},
    },
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    {
        'nvim-telescope/telescope.nvim',
        lazy = true,
        version = '0.1.5',
        dependencies = { { 'nvim-lua/plenary.nvim' } }
    },
    'nvim-treesitter/nvim-treesitter',
    'nvim-treesitter/playground',
    'theprimeagen/harpoon',
    'mbbill/undotree',
    'tpope/vim-fugitive',
    {
        'lewis6991/gitsigns.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function() require('gitsigns').setup() end
    },
    {
        'VonHeikemen/lsp-zero.nvim',
        dependencies = {
            -- LSP Support
            {
                'neovim/nvim-lspconfig',
                cmd = 'LspInfo',
                event = { 'BufReadPre', 'BufNewFile' },
                dependencies = {
                    { 'hrsh7th/cmp-nvim-lsp' },
                },
            },
            'williamboman/mason.nvim',           -- Optional
            'williamboman/mason-lspconfig.nvim', -- Optional
            -- Autocompletion
            'hrsh7th/nvim-cmp',                  -- Required
            'hrsh7th/cmp-nvim-lsp',              -- Required
            'hrsh7th/cmp-buffer',                -- Optional
            'hrsh7th/cmp-path',                  -- Optional
            'saadparwaiz1/cmp_luasnip',          -- Optional
            'hrsh7th/cmp-nvim-lua',              -- Optional
            -- Snippets
            'L3MON4D3/LuaSnip',                  -- Required
            'rafamadriz/friendly-snippets',      -- Optional
        }
    },
    -- docstring generation https://github.com/danymat/neogen#installation
    {
        'danymat/neogen',
        config = function()
            require('neogen').setup {}
        end,
        dependencies = 'nvim-treesitter/nvim-treesitter',
    },
    -- notifications
    'rcarriga/nvim-notify',
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
    'tpope/vim-abolish',
    {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require("ibl").setup {}
        end
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
          "MunifTanjim/nui.nvim",
          -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        opts = {
            filesystem = {
                filtered_items = {
                    hide_dotfiles = false,
                },
            },
        },
        }
    }
}
