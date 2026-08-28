-- Available themes list
local themes = {
    "default",
    "onehalfdark", -- mitchellh's colorscheme (colors/onehalfdark.vim)
    "molokai",     -- mitchellh's older colorscheme (colors/molokai.vim)
    "catppuccin",
    "rose-pine-moon",
    "tokyonight-storm",
    "gruvbox",
    "oxocarbon",
    "brightburn",
    -- github (projekt0n/github-nvim-theme)
    "github_dark",
    "github_dark_default",
    "github_dark_dimmed",
    "github_dark_high_contrast",
    "github_dark_colorblind",
    "github_dark_tritanopia",
    "github_light",
    "github_light_default",
    "github_light_high_contrast",
    "github_light_colorblind",
    "github_light_tritanopia",

    "catppuccin-latte", -- light variant
    "catppuccin-mocha", -- dark variant

    "kanagawa",
    "kanagawa-wave",
    "kanagawa-dragon",
    "kanagawa-lotus",

    "rusticated",

    "bearded",

    "solarized-osaka",
    "solarized-osaka-storm",
    "solarized-osaka-night",
    "solarized-osaka-day",

    -- ayu (variant selected via g:ayucolor below)
    "ayu-dark",
    "ayu-mirage",
    "ayu-light",

    -- zenbones collection (background=dark variants)
    "zenbones",
    "zenwritten",
    "neobones",
    "zenburned",
    "kanagawabones",
    "duckbones",
    "rosebones", -- dark (background=dark forced by ColorMyPencils)
}

-- Path to store theme preference
local theme_file = vim.fn.stdpath('data') .. '/current_theme.txt'

-- Function to save theme to file
local function save_theme(theme)
    local file = io.open(theme_file, 'w')
    if file then
        file:write(theme)
        file:close()
        print("Theme saved to: " .. theme_file)
    else
        print("Error: Could not save theme to " .. theme_file)
    end
end

-- Function to load saved theme
local function load_theme()
    local file = io.open(theme_file, 'r')
    if file then
        local theme = file:read('*all')
        file:close()
        -- Trim whitespace and remove quotes if present
        theme = theme:match("^%s*(.-)%s*$")
        theme = theme:gsub("^['\"](.+)['\"]$", "%1")
        return theme
    end
    print("No saved theme found, using default")
    return "rose-pine-moon" -- default theme
end

function ColorMyPencils(color)
    color = color or load_theme()

    -- Reset state so previous theme's overrides don't leak into the new one
    vim.opt.background = "dark"
    vim.cmd("hi clear")
    if vim.fn.exists("syntax_on") == 1 then
        vim.cmd("syntax reset")
    end

    -- ayu ships one colorscheme ("ayu") with variants chosen via g:ayucolor
    if color == "ayu-dark" or color == "ayu-mirage" or color == "ayu-light" then
        local variant = color:gsub("^ayu%-", "")
        if variant == "light" then
            vim.opt.background = "light"
        end
        vim.g.ayucolor = variant
        color = "ayu"
    end

    -- light colorschemes need background=light before loading
    if color:match("^github_light") then
        vim.opt.background = "light"
    end

    vim.cmd.colorscheme(color)

    -- NOTE: We intentionally do NOT strip the theme background anymore.
    -- Each theme keeps its own bg color; Ghostty's `background-opacity` +
    -- `background-opacity-cells = true` makes those bg colors slightly
    -- transparent (with blur) at the terminal level.

    -- GitHub dark themes: keep each variant's own background (github_dark_default
    -- is #0d1117, matching the Ghostty/Rune "GitHub Dark Default" theme) and just
    -- make floats and NvimTree follow it, instead of forcing one hardcoded bg.
    if color:match("^github_dark") then
        local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
        local bg = normal.bg and string.format("#%06x", normal.bg) or "#0d1117"
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = bg })
        set_nvimtree_background(bg)
    end

    if color == "oxocarbon" then
        local bg = "#161616"
        local bg_alt = "#262626"
        local fg = "#f2f4f8"
        local accent = "#82cfff"

        -- Cleaner core surfaces
        vim.api.nvim_set_hl(0, "Normal", { bg = bg, fg = fg })
        vim.api.nvim_set_hl(0, "NormalNC", { bg = bg, fg = fg })
        vim.api.nvim_set_hl(0, "SignColumn", { bg = bg })
        vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = bg, fg = bg })
        vim.api.nvim_set_hl(0, "LineNr", { bg = bg, fg = "#525252" })
        vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1c1c1c" })
        vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "#1c1c1c", fg = accent, bold = true })
        vim.api.nvim_set_hl(0, "VertSplit", { bg = bg, fg = "#262626" })
        vim.api.nvim_set_hl(0, "WinSeparator", { bg = bg, fg = "#262626" })
        vim.api.nvim_set_hl(0, "StatusLine", { bg = bg_alt, fg = fg })
        vim.api.nvim_set_hl(0, "StatusLineNC", { bg = bg, fg = "#6f6f6f" })
        vim.api.nvim_set_hl(0, "Visual", { bg = "#393939" })

        -- Floats / popups
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = bg, fg = fg })
        vim.api.nvim_set_hl(0, "FloatBorder", { bg = bg, fg = "#393939" })
        vim.api.nvim_set_hl(0, "Pmenu", { bg = bg_alt, fg = fg })
        vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#393939", fg = accent, bold = true })
        vim.api.nvim_set_hl(0, "PmenuSbar", { bg = bg_alt })
        vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#525252" })

        -- Telescope
        vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = bg, fg = fg })
        vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = bg, fg = "#393939" })
        vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = bg_alt })
        vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = bg_alt, fg = bg_alt })
        vim.api.nvim_set_hl(0, "TelescopePromptTitle", { bg = accent, fg = bg, bold = true })
        vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { bg = "#42be65", fg = bg, bold = true })
        vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { bg = bg, fg = bg })
        vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "#393939", fg = fg, bold = true })

        -- NvimTree
        vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = bg, fg = fg })
        vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = bg, fg = fg })
        vim.api.nvim_set_hl(0, "NvimTreeNormalFloat", { bg = bg })
        vim.api.nvim_set_hl(0, "NvimTreeFloatBorder", { bg = bg, fg = "#393939" })
        vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = bg, fg = bg })
        vim.api.nvim_set_hl(0, "NvimTreeSignColumn", { bg = bg })
        vim.api.nvim_set_hl(0, "NvimTreeStatusLine", { bg = bg })
        vim.api.nvim_set_hl(0, "NvimTreeStatusLineNC", { bg = bg })
        vim.api.nvim_set_hl(0, "NvimTreeVertSplit", { bg = bg, fg = "#262626" })
        vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { bg = bg, fg = "#262626" })
        vim.api.nvim_set_hl(0, "NvimTreeRootFolder", { fg = accent, bold = true })
        vim.api.nvim_set_hl(0, "NvimTreeFolderIcon", { fg = accent })
        vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = fg, bold = true })
        vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = "#393939" })

        -- Diagnostics readability
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { bg = "none", fg = "#ee5396" })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { bg = "none", fg = "#ff7eb6" })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { bg = "none", fg = "#82cfff" })
        vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { bg = "none", fg = "#3ddbd9" })

        -- Gitsigns
        vim.api.nvim_set_hl(0, "GitSignsAdd", { bg = bg, fg = "#42be65" })
        vim.api.nvim_set_hl(0, "GitSignsChange", { bg = bg, fg = "#82cfff" })
        vim.api.nvim_set_hl(0, "GitSignsDelete", { bg = bg, fg = "#ee5396" })
    end
end

function set_nvimtree_background(bg)
    bg = bg or "#0d1117"

    -- Main tree background
    vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = bg })
    vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = bg })

    -- Floating tree (if used)
    vim.api.nvim_set_hl(0, "NvimTreeNormalFloat", { bg = bg })
    vim.api.nvim_set_hl(0, "NvimTreeFloatBorder", { bg = bg })

    -- Side elements
    vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = bg })
    vim.api.nvim_set_hl(0, "NvimTreeSignColumn", { bg = bg })
    vim.api.nvim_set_hl(0, "NvimTreeStatusLine", { bg = bg })
    vim.api.nvim_set_hl(0, "NvimTreeStatusLineNC", { bg = bg })
    vim.api.nvim_set_hl(0, "NvimTreeVertSplit", { bg = bg })
end

-- Theme switcher function with live preview (arrow-key navigation)
function SwitchTheme()
    local original = vim.g.colors_name or load_theme()

    local buf = vim.api.nvim_create_buf(false, true)
    local width = 40
    local height = #themes
    local ui = vim.api.nvim_list_uis()[1] or { width = vim.o.columns, height = vim.o.lines }
    local row = math.floor((ui.height - height) / 2 - 1)
    local col = math.floor((ui.width - width) / 2)

    local lines = {}
    for _, t in ipairs(themes) do table.insert(lines, "  " .. t) end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'rounded',
        title = ' Select a theme ',
        title_pos = 'center',
    })

    vim.api.nvim_win_set_option(win, 'cursorline', true)

    -- find current theme index
    local start_idx = 1
    for i, t in ipairs(themes) do
        if t == original then start_idx = i break end
    end
    vim.api.nvim_win_set_cursor(win, { start_idx, 0 })

    local confirmed = false

    local apply_preview = function()
        local line = vim.api.nvim_win_get_cursor(win)[1]
        local theme = themes[line]
        if theme then pcall(ColorMyPencils, theme) end
    end

    -- preview the initial selection
    apply_preview()

    local group = vim.api.nvim_create_augroup('ThemePreview', { clear = true })
    vim.api.nvim_create_autocmd('CursorMoved', {
        group = group,
        buffer = buf,
        callback = apply_preview,
    })

    local close = function()
        vim.api.nvim_clear_autocmds({ group = group })
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
        if not confirmed then
            pcall(ColorMyPencils, original)
        end
    end

    local confirm = function()
        local line = vim.api.nvim_win_get_cursor(win)[1]
        local theme = themes[line]
        if theme then
            confirmed = true
            save_theme(theme)
            ColorMyPencils(theme)
            print("Switched to: " .. theme)
        end
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
        vim.api.nvim_clear_autocmds({ group = group })
    end

    local opts = { buffer = buf, nowait = true, silent = true }
    vim.keymap.set('n', '<CR>', confirm, opts)
    vim.keymap.set('n', '<Esc>', close, opts)
    vim.keymap.set('n', 'q', close, opts)
    vim.keymap.set('n', '<C-c>', close, opts)

    -- disable j/k/h/l so they don't move (user requested arrow-only)
    vim.keymap.set('n', 'j', '<Nop>', opts)
    vim.keymap.set('n', 'k', '<Nop>', opts)
    vim.keymap.set('n', 'h', '<Nop>', opts)
    vim.keymap.set('n', 'l', '<Nop>', opts)

    vim.api.nvim_create_autocmd('BufLeave', {
        group = group,
        buffer = buf,
        once = true,
        callback = close,
    })
end

-- Create the command
vim.api.nvim_create_user_command('ThemeSwitch', SwitchTheme, {})

return {
    ColorMyPencils = ColorMyPencils,
    SwitchTheme = SwitchTheme,
    {
        "erikbackman/brightburn.vim",
    },
    {
        "catppuccin/nvim",
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            require("tokyonight").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                style = "storm",        -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
                transparent = false,    -- Keep the theme's own bg; Ghostty handles transparency
                terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
                styles = {
                    -- Style to be applied to different syntax groups
                    -- Value is any valid attr-list value for `:help nvim_set_hl`
                    comments = { italic = false },
                    keywords = { italic = false },
                    -- Background styles. Can be "dark", "transparent" or "normal"
                    sidebars = "dark", -- style for sidebars, see below
                    floats = "dark",   -- style for floating windows
                },
            })
            ColorMyPencils()
        end
    },
    {
        "ellisonleao/gruvbox.nvim",
        name = "gruvbox",
        config = function()
            require("gruvbox").setup({
                terminal_colors = true, -- add neovim terminal colors
                undercurl = true,
                underline = false,
                bold = true,
                italic = {
                    strings = false,
                    emphasis = false,
                    comments = false,
                    operators = false,
                    folds = false,
                },
                strikethrough = true,
                invert_selection = false,
                invert_signs = false,
                invert_tabline = false,
                invert_intend_guides = false,
                inverse = true, -- invert background for search, diffs, statuslines and errors
                contrast = "",  -- can be "hard", "soft" or empty string
                palette_overrides = {},
                overrides = {},
                dim_inactive = false,
                transparent_mode = false,
            })
        end,
    },
    {
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                style = "storm",        -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
                transparent = false,    -- Keep the theme's own bg; Ghostty handles transparency
                terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
                styles = {
                    -- Style to be applied to different syntax groups
                    -- Value is any valid attr-list value for `:help nvim_set_hl`
                    comments = { italic = false },
                    keywords = { italic = false },
                    -- Background styles. Can be "dark", "transparent" or "normal"
                    sidebars = "dark", -- style for sidebars, see below
                    floats = "dark",   -- style for floating windows
                },
            })
        end
    },
    {
        "ellisonleao/gruvbox.nvim",
        name = "gruvbox",
        config = function()
            require("gruvbox").setup({
                undercurl = true,
                underline = false,
                bold = true,
                italic = {
                    strings = false,
                    comments = false,
                    operators = false,
                    folds = false,
                },
                strikethrough = true,
                invert_selection = false,
                invert_signs = false,
                invert_tabline = false,
                invert_intend_guides = false,
                inverse = true, -- invert background for search, diffs, statuslines and errors
                contrast = "",  -- can be "hard", "soft" or empty string
                palette_overrides = {},
                overrides = {},
            })
        end
    },
    {
        "nyoom-engineering/oxocarbon.nvim",
        name = "oxocarbon",
        lazy = false,
        priority = 1000,
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require('rose-pine').setup({
                disable_background = false,
                dim_inactive_windows = false,
                styles = {
                    italic = false,
                },
            })
        end
    },
    {
        "projekt0n/github-nvim-theme",
        name = "github-theme",
        lazy = false,
        priority = 1000,
        config = function()
            require("github-theme").setup({
                options = {
                    -- styles = {
                    --     comments = "NONE",
                    --     keywords = "NONE",
                    --     functions = "bold",
                    -- },
                    -- darken = {
                    --     floats = false,
                    --     sidebars = false,
                    -- },
                },
            })
        end,
    },
    {
        "rebelot/kanagawa.nvim",
        name = "kanagawa",
        lazy = false,
        priority = 1000,
        config = function()
            require("kanagawa").setup({
                compile = false,
                undercurl = true,
                commentStyle = { italic = false },
                keywordStyle = { italic = false },
                statementStyle = { bold = true },
                transparent = false, -- keep theme bg; Ghostty handles transparency
                dimInactive = false,
                terminalColors = true,

                colors = {
                    theme = {
                        all = {
                            ui = {
                                bg_gutter = "none", -- cleaner look
                            },
                        },
                    },
                },

                overrides = function(colors)
                    local theme = colors.theme
                    return {
                        Pmenu = { bg = theme.ui.bg_p1 },
                    }
                end,

                theme = "wave", -- default variant
            })
        end,
    },
    {
        "d00h/nvim-rusticated",
        name = "rusticated",
        lazy = false,
        priority = 1000,
    },
    {
        "craftzdog/solarized-osaka.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            transparent = false,
        },
    },
    {
        "zenbones-theme/zenbones.nvim",
        dependencies = "rktjmp/lush.nvim",
        lazy = false,
        priority = 1000,
    },
    {
        "ayu-theme/ayu-vim",
        name = "ayu",
        lazy = false,
        priority = 1000,
    },
    {
        "Ferouk/bearded-nvim",
        name = "bearded",
        lazy = false,
        priority = 1000,
        build = function()
            local doc = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "bearded", "doc")
            pcall(vim.cmd, "helptags " .. doc)
        end,
        config = function()
            require("bearded").setup({ flavor = "arc" })
        end,
    },
}
