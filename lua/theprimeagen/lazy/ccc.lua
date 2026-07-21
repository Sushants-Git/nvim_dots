return {
    "uga-rosa/ccc.nvim",
    event = "VeryLazy",
    config = function()
        local ccc = require("ccc")
        ccc.setup({
            highlighter = {
                auto_enable = true,
                lsp = true,
            },
        })
    end,
    keys = {
        { "<leader>cp", "<cmd>CccPick<cr>", desc = "Color Picker" },
        { "<leader>ch", "<cmd>CccHighlighterToggle<cr>", desc = "Toggle Color Highlighter" },
    },
}
