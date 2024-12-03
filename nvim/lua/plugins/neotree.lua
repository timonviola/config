return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    popup_border_style = "rounded",
    filesystem = {
      hijack_netrw_behavior = "open_current",
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
