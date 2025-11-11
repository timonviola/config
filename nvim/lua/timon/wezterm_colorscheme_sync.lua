local M = {}

local MAP_COLORSCHEMES_NVIM_TO_WEZTERM = {
    -- <nvim name> = <wezterm name>
    ["tokyonight-day"] = "Tokyo Night Day",
    ["tokyonight-storm"] = "Tokyo Night Storm",
    ["tokyonight-night"] = "Tokyo Night",
    ["catppuccin-frappe"] = "Catppuccin Frappe",
    ["catppuccin-latte"] = "Catppuccin Latte",
    ["catppuccin-macchiato"] = "Catppuccin Macchiato",
    ["catppuccin-mocha"] = "Catppuccin Mocha",
    ["gruvbox"] = "GruvboxDark",
    ["rose-pine"] = "rose-pine",
    ["rose-pine-main"] = "rose-pine",
    ["rose-pine-dawn"] = "rose-pine-dawn",
    ["rose-pine-moon"] = "rose-pine-moon",
    -- add more color schemes here ...
}
--vim.api.nvim_create_autocmd("ColorSchemePre", {
--    group = au_group,
--    callback = function(args)
--        vim.cmd('set bg=dark')
--    end,
--}
--)

-- Synchronise wezterm's theme and NVIM's colorscheme with the `:colorschme`
-- cmd.
-- Wezterm's config file needs modification, this plugin relies on state files
-- on your local filesystem.
--
-- Wezterm's colorscheme is stored under `$WEZTERM_CONFIG_DIR/colorscheme`.
-- NVIM's colorscheme is stored under `stdpath("state")/colorscheme`
--
-- The theme mapping is not-complete and manually maintained for now.
--
-- BUG: the `bg` light/dark value is not properly update on NVIM side after
-- switching from a light theme. This might be due to some colorscheme
-- shenanigans.
function M.setup()
    local au_group = vim.api.nvim_create_augroup("wezterm_colorscheme", { clear = true })

    vim.api.nvim_create_autocmd("ColorScheme", {
        group = au_group,
        callback = function(args)
            local new_colorscheme = args.match
            local colorscheme = MAP_COLORSCHEMES_NVIM_TO_WEZTERM[args.match]
            if not colorscheme then
                return
            end
            -- Write the colorscheme to a file
            local filename = vim.fn.stdpath("state") .. "/colorscheme"
            M.write_colorscheme_file(filename, new_colorscheme)
            -- Write the translated colorscheme to a file
            local filename = vim.fn.expand("$WEZTERM_CONFIG_DIR") .. "/colorscheme"
            M.write_colorscheme_file(filename, colorscheme)
            vim.notify("Setting WezTerm color scheme to " .. colorscheme, vim.log.levels.INFO)
        end,
    })
end

function M.write_colorscheme_file(filename, colorscheme)
    assert(type(filename) == "string")
    local file = io.open(filename, "w")
    assert(file)
    file:write(colorscheme)
    file:close()
end

return M
