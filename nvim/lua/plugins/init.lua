return {
  {
    "j-hui/fidget.nvim",
    -- don't remove the empty opts, it's needed to start the plugin w/ metals
    opts = {},
  },
  {
    "scalameta/nvim-metals",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
  },
  "kevinhwang91/nvim-bqf",
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    dependencies = {
      { "nvim-lua/popup.nvim" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzy-native.nvim" },
    },
    config = function()
      require("mesopotamia.plugins.telescope").setup()
    end,
  },
  {
    "saghen/blink.cmp",
    lazy = false, -- lazy loading handled internally
    dependencies = "rafamadriz/friendly-snippets",
    version = "*",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "enter",
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },
      signature = { enabled = true },
    },
    opts_extend = { "sources.default" },
  },
  { "fei6409/log-highlight.nvim", event = "BufRead *.log", ft = { "log" }, opts = {} },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- ensure parsers are installed
      require("nvim-treesitter").install({
        "lua",
        "javascript",
        "typescript",
        "python",
        "scala",
        "rust",
        "go",
      })

      -- enable treesitter highlighting
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },
  --
  -- colors
  --
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

      vim.cmd(
        string.format(
          [[hi! StatusLine guifg=%s guibg=%s]],
          kanagawa_colors.palette.fujiWhite,
          kanagawa_colors.palette.sumiInk3
        )
      )

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
    end,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      local transparent = true -- set to true if you would like to enable transparency

      local bg = "#011628"
      local bg_dark = "#011423"
      local bg_highlight = "#a36b18"
      local bg_search = "#0A64AC"
      local bg_visual = "#82c3fa"
      local fg = "#CBE0F0"
      local fg_dark = "#B4D0E9"
      local fg_gutter = "#627E97"
      local border = "#547998"

      require("tokyonight").setup({
        style = "night",
        transparent = transparent,
        styles = {
          sidebars = transparent and "transparent" or "dark",
          floats = transparent and "transparent" or "dark",
        },
        on_colors = function(colors)
          colors.bg = bg
          colors.bg_dark = transparent and colors.none or bg_dark
          colors.bg_float = transparent and colors.none or bg_dark
          colors.bg_highlight = bg_highlight
          colors.bg_popup = bg_dark
          colors.bg_search = bg_search
          colors.bg_sidebar = transparent and colors.none or bg_dark
          colors.bg_statusline = transparent and colors.none or bg_dark
          colors.bg_visual = bg_visual
          colors.border = border
          colors.fg = fg
          colors.fg_dark = fg_dark
          colors.fg_float = fg
          colors.fg_gutter = fg_gutter
          colors.fg_sidebar = fg_dark
          colors.git.add = "#04c904"
        end,
        on_highlights = function(hl)
          hl.comment = { bg = "#000000", fg = "#518a50" }
          hl.perlComment = { bg = "#000000", fg = "#518a50" }
          hl.Comment = { bg = "#000000", fg = "#518a50" }
        end,
      })
      -- vim.cmd("colorscheme tokyonight")
    end,
  },
  --  {
  --    "timonviola/wezterm-colorsync.nvim",
  --    dependencies = {
  --      { "rcarriga/nvim-notify" },
  --    },
  --    config = function()
  --      require("colorsync").setup()
  --    end,
  --  },
  {
    dir = vim.fn.expand("/Users/TIVI/timon/wezterm-colorsync.nvim"),
    dependencies = {
      { "rcarriga/nvim-notify" },
    },
    name = "colorsync", -- recommended if the dir name isn't unique
    config = function()
      require("colorsync").setup()
    end,
  },
  --
  -- langs, LSP
  --
  {
    -- let's keep mason around for now
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^9",
    -- this plugin does not need lazy
    lazy = false,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "wezterm-types",      mods = { "wezterm" } },
      },
    },
  },
  -- Other stuff
  --
  -- allows me to open netrw with '-'
  -- and makes netwr easier for me
  --:help vinegar
  "tpope/vim-vinegar",
  -- comment out lines with `gc`
  -- alternative: https://github.com/numToStr/Comment.nvim
  "tpope/vim-commentary",
  {
    "tpope/vim-fugitive",
    config = function()
      vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup({
        enable = true,
        max_lines = 1,
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end,
  },
  --    {
  --        "ThePrimeagen/harpoon",
  --        branch = "master",
  --        dependencies = { "nvim-lua/plenary.nvim" },
  --        config = function()
  --            local harpoon = require("harpoon")
  --            harpoon:setup()
  --            vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
  --            vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
  --            vim.keymap.set("n", "<C-a>", function() harpoon:list():select(1) end)
  --            vim.keymap.set("n", "<C-s>", function() harpoon:list():select(2) end)
  --            vim.keymap.set("n", "<C-d>", function() harpoon:list():select(3) end)
  --            vim.keymap.set("n", "<C-f>", function() harpoon:list():select(4) end)
  --
  --            -- Toggle previous & next buffers stored within Harpoon list
  --            vim.keymap.set("n", "<C-S-i>", function() harpoon:list():prev() end)
  --            vim.keymap.set("n", "<C-S-d>", function() harpoon:list():next() end)
  --        end,
  --    }
}
