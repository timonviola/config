return {
    -- Packer can manage itself
    'williamboman/mason.nvim',
    {
        'folke/tokyonight.nvim',
        lazy = false,
        priority = 1000,
        opts = {},
    },
    {
        'nvim-telescope/telescope.nvim',
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
            'neovim/nvim-lspconfig',         -- Required
            'williamboman/mason.nvim',       -- Optional
            'williamboman/mason-lspconfig.nvim', -- Optional
            -- Autocompletion
            'hrsh7th/nvim-cmp',              -- Required
            'hrsh7th/cmp-nvim-lsp',          -- Required
            'hrsh7th/cmp-buffer',            -- Optional
            'hrsh7th/cmp-path',              -- Optional
            'saadparwaiz1/cmp_luasnip',      -- Optional
            'hrsh7th/cmp-nvim-lua',          -- Optional
            -- Snippets
            'L3MON4D3/LuaSnip',              -- Required
            'rafamadriz/friendly-snippets',  -- Optional
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
}

