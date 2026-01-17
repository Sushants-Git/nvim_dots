-- Available themes list
local themes = {
    "catppuccin",
    "rose-pine-moon",
    "tokyonight-storm",
    "gruvbox",
    "oxocarbon",
    "brightburn",
    "github_dark_dimmed",
    "catppuccin-latte", -- light variant
    "catppuccin-mocha", -- dark variant
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
    vim.cmd.colorscheme(color)

    -- Set custom background for GitHub themes
    if string.match(color, "github") then
        set_nvimtree_background()
        vim.api.nvim_set_hl(0, "Normal", { bg = "#181818" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#181818" })
    end
end

function set_nvimtree_background()
    local bg = "#181818"

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

-- Theme switcher function
function SwitchTheme()
    vim.ui.select(themes, {
        prompt = 'Select a theme:',
        format_item = function(item)
            return item
        end,
    }, function(choice)
        if choice then
            save_theme(choice)
            ColorMyPencils(choice)
            print("Switched to: " .. choice)
        end
    end)
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
                transparent = true,     -- Enable this to disable setting the background color
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
                transparent = true,     -- Enable this to disable setting the background color
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
        config = function()
            -- require("oxocarbon").setup({
            --     styles = {
            --         comments = { italic = false },
            --         keywords = { italic = false },
            --         functions = { italic = false },
            --         variables = { italic = false },
            --         sidebars = "dark",
            --         floats = "dark",
            --     },
            -- })
        end
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require('rose-pine').setup({
                disable_background = true,
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
}
