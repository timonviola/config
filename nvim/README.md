# NeoVim user config

## Structure
.
├── README.md
├── after                         -- everything here is applied last, so these user configs will take precedence over the default ones
│   ├── ftplugin                  -- language specific config
│   │   └── python.vim
│   └── plugin                    -- 3. (last) user config of plugins
│       ├── colors.lua
│       ├── diagnostic.lua
│       ├── etc.lua
│       ├── fugitive.lua
│       ├── gitsigns.lua
│       ├── harpoon.lua
│       ├── lsp.lua
│       ├── neogen.lua
│       ├── notify.lua
│       ├── telescope.lua
│       ├── tokyonight.lua
│       ├── treesitter.lua
│       └── undotree.lua
├── init.lua                      -- 0. execution starts, bootstrap lazy (pgk manager)
├── lazy-lock.json
├── lua                           -- 1. plugins definition, each plugin can have their own file
│   ├── plugins
│   │   └── init.lua
│   └── timon                     -- user specific config vimcmd, remap, vim settings
│       ├── init.lua
│       ├── keymap.lua
│       ├── remap.lua
│       └── set.lua
├── plugin
└── spell                         -- spelling related files
    ├── en.utf-8.add
    ├── en.utf-8.add.spl
    ├── en.utf-8.spl
    └── en.utf-8.sug

9 directories, 26 files
