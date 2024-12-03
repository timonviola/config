# NeoVim user config
Credit: this config is inspired by folke's dotfiles https://github.com/folke/dot/ and kickstart nvim https://github.com/nvim-lua/kickstart.nvim/

## Structure
```
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
```
## Cheat Sheet
### Folding
```markdown
    zf#j creates a fold from the cursor down # lines.
    zf/string creates a fold from the cursor to string .
    zj moves the cursor to the next fold.
    zk moves the cursor to the previous fold.
    zo opens a fold at the cursor.
    zO opens all folds at the cursor.
    zm increases the foldlevel by one.
    zM closes all open folds.
    zr decreases the foldlevel by one.
    zR decreases the foldlevel to zero -- all folds will be open.
    zd deletes the fold at the cursor.
    zE deletes all folds.
    [z move to start of open fold.
    ]z move to end of open fold.
    [source](https://gist.github.com/lestoni/8c74da455cce3d36eb68)
```
