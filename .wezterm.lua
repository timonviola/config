--
-- ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
-- ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
-- ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
-- ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
-- ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
-- A GPU-accelerated cross-platform terminal emulator
-- https://wezfurlong.org/wezterm/

-- Check this + NVIM integration: https://github.com/joshmedeski/dotfiles/blob/main/.config/wezterm/utils/keys.lua#L29
-- TODO: Check this for more https://alexplescan.com/posts/2024/08/10/wezterm/


-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action
-- This will hold the configuration.
local config = wezterm.config_builder()

--- Return True if HOME looks like as on Linux.
local function is_linux()
    return "/home/timon" == os.getenv("HOME")
end


-- This is where you actually apply your config choices
-- Font
config.font_size = 14
config.font = wezterm.font 'FiraCode Nerd Font Mono'
config.harfbuzz_features = {"zero" , "ss01", "cv05"}
config.line_height = 1.1
config.window_decorations = 'RESIZE'

if is_linux() then
    config.font_size = 12
    config.line_height = 1.0
    config.enable_wayland = true
    config.window_decorations = 'NONE'
end

config.freetype_load_target = "Light"
config.color_scheme = 'Tokyo Night'
-- and finally, return the configuration to wezterm
config.window_background_opacity = 0.75
config.text_background_opacity = 0.3
config.macos_window_background_blur = 8
config.window_padding = {
    left = 20,
    right = 10,
    top = 20,
    bottom = 10,
}
-- General
--config.enable_tab_bar = false
config.native_macos_fullscreen_mode = false
config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 }
config.debug_key_events = true
config.keys = {
    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    {
        key = '[',
        mods = 'LEADER',
        action = act.ActivateCopyMode,
    },
    {
        key = 'z',
        mods = 'LEADER',
        action = act.TogglePaneZoomState,
    },
    {
        key = 'x',
        mods = 'LEADER',
        action = act.CloseCurrentPane { confirm = false },
    },
    {
        key = '%',
        mods = 'LEADER',
        action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
        key = '"',
        mods = 'LEADER',
        action = act.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    {
        key = 'j',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection('Down'),
    },
    {
        key = 'k',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection('Up'),
    },
    {
        key = 'l',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection('Right'),
    },
    {
        key = 'h',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection('Left'),
    },
}


local function segments_for_right_status(window)
    return {
        window:active_workspace(),
        wezterm.strftime('%a %b %-d %H:%M'),
        wezterm.hostname(),
    }
end

wezterm.on('update-status', function(window, _)
    local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
    local segments = segments_for_right_status(window)

    local color_scheme = window:effective_config().resolved_palette
    -- Note the use of wezterm.color.parse here, this returns
    -- a Color object, which comes with functionality for lightening
    -- or darkening the colour (amongst other things).
    local bg = wezterm.color.parse(color_scheme.background)
    local fg = color_scheme.foreground

    -- Each powerline segment is going to be coloured progressively
    -- darker/lighter depending on whether we're on a dark/light colour
    -- scheme. Let's establish the "from" and "to" bounds of our gradient.
    local gradient_to, gradient_from = bg, bg
    if true then
        gradient_from = gradient_to:lighten(0.2)
    else
        gradient_from = gradient_to:darken(0.2)
    end

    -- Yes, WezTerm supports creating gradients, because why not?! Although
    -- they'd usually be used for setting high fidelity gradients on your terminal's
    -- background, we'll use them here to give us a sample of the powerline segment
    -- colours we need.
    local gradient = wezterm.color.gradient(
        {
            orientation = 'Horizontal',
            colors = { gradient_from, gradient_to },
        },
        #segments -- only gives us as many colours as we have segments.
    )

    -- We'll build up the elements to send to wezterm.format in this table.
    local elements = {}

    for i, seg in ipairs(segments) do
        local is_first = i == 1

        if is_first then
            table.insert(elements, { Background = { Color = 'none' } })
        end
        table.insert(elements, { Foreground = { Color = gradient[i] } })
        table.insert(elements, { Text = SOLID_LEFT_ARROW })

        table.insert(elements, { Foreground = { Color = fg } })
        table.insert(elements, { Background = { Color = gradient[i] } })
        table.insert(elements, { Text = ' ' .. seg .. ' ' })
    end

    window:set_right_status(wezterm.format(elements))
end)

return config
