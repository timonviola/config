-- TODO: make this into a package
-- Disclaimer: Thanks for all the various blog posts, comments that inspired this
local M = {}
local notify = require("notify")

notify.setup({
    timeout = 500,
    render = 'compact',
})

local MAP_COLORSCHEMES_NVIM_TO_WEZTERM = {
    -- <nvim name> = <wezterm name>
    ["default"] = "NvimDark",
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
    ["kanagawa"] = "Kanagawa (Gogh)",
    -- add more color schemes here ...
}
--vim.api.nvim_create_autocmd("ColorSchemePre", {
--    group = au_group,
--    callback = function(args)
--        vim.cmd('set bg=dark')
--    end,
--}
--)
--
local State = { FAILED = "0", OK = "1", INIT_FILE_DOES_NOT_EXIST = "2" }

---@return State
local check_setup = function()
    local nvim_filename = vim.fn.stdpath("state") .. "/colorscheme"
    assert(type(nvim_filename) == "string", "Unexpected error: Could not derive state filename")
    -- I keep the file handle here, so it can be closed.
    local file_handle = io.open(nvim_filename, "r")
    local file_can_be_read = file_handle ~= nil
    if not file_can_be_read then
        -- log.error("IOError: Could not open file for reading" .. nvim_filename)
        return State.INIT_FILE_DOES_NOT_EXIST
    end
    file_handle.close()
    notify("Init file exists. All goode", vim.log.levels.INFO)
    return State.OK
end

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
    vim.api.nvim_create_autocmd("VimEnter", {
        group = au_group,
        callback = function()
            -- runs after startup; colorscheme likely set
            local current_color_scheme_name = vim.g.colors_name
            local initial_state = check_setup()
            if initial_state == State.INIT_FILE_DOES_NOT_EXIST then
                notify("Your initial colorscheme file does not exist.", vim.log.levels.ERROR)
                local set_colorscheme = false
                if current_color_scheme == nil then
                    current_color_scheme_name = "default"
                    notify("Your initial colorscheme file does not exist.", vim.log.levels.INFO)
                else
                    notify("Your initial colorscheme file does not exist.", vim.log.levels.DEBUG)
                end
                local ans = vim.fn.input("Should we set current color scheme:" ..
                    current_color_scheme_name .. " ? (y/n): ")
                ans = ans:lower():gsub("^%s*(.-)%s*$", "%1") -- trim
                if ans == "y" then
                    set_colorscheme = true
                else
                    notify("Your initial colorscheme file does not exist.", vim.log.levels.DEBUG)
                    return
                end
                if set_colorscheme then
                    -- try resolve colorscheme
                    local mapped_colorscheme = MAP_COLORSCHEMES_NVIM_TO_WEZTERM[current_color_scheme_name]
                    if not mapped_colorscheme then
                        notify("Could not resolve colorscheme: " .. current_color_scheme_name, vim.log.levels.ERROR)
                        return
                    end
                    local filename = vim.fn.stdpath("state") .. "/colorscheme"
                    M.write_colorscheme_file(filename, current_color_scheme_name)
                    local wezterm_filename = vim.fn.expand("$WEZTERM_CONFIG_DIR") .. "/colorscheme"
                    M.write_colorscheme_file(wezterm_filename, mapped_colorscheme)
                    notify("Setting WezTerm color scheme to " .. mapped_colorscheme, vim.log.levels.INFO)
                end
            elseif initial_state == State.OK then
                local nvim_filename = vim.fn.stdpath("state") .. "/colorscheme"
                assert(type(nvim_filename) == "string")
                local file = io.open(nvim_filename, "r")
                assert(file)
                local colorscheme = file:read("*l")
                notify(colorscheme, vim.log.levels.INFO)
                file:close()
                vim.cmd("silent colorscheme " .. colorscheme)
            end
        end,
    })


    vim.api.nvim_create_autocmd("ColorScheme", {
        group = au_group,
        callback = function(args)
            local current_color_scheme = vim.g.colors_name
            notify("ColorScheme: current_color_scheme" .. current_color_scheme, vim.log.levels.DEBUG)
            local new_colorscheme = args.match
            local colorscheme = MAP_COLORSCHEMES_NVIM_TO_WEZTERM[args.match]
            if not colorscheme then
                return
            end
            -- Write the colorscheme to a file
            local filename = vim.fn.stdpath("state") .. "/colorscheme"
            M.write_colorscheme_file(filename, new_colorscheme)
            -- Write the translated colorscheme to a file
            local wezterm_filename = vim.fn.expand("$WEZTERM_CONFIG_DIR") .. "/colorscheme"
            M.write_colorscheme_file(wezterm_filename, colorscheme)
            notify("Setting WezTerm color scheme to " .. colorscheme, vim.log.levels.INFO)
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

--- TODO: https://neo.vimhelp.org/health.txt.html#health-dev
---@param opts? {checkhealth?: boolean}
--function M.check
--    if check_setup() == State.OK
--        vim.health.ok("Setup is correct")
--      else
--        vim.health.error("Setup is incorrect")
--      end
--
--


return M
