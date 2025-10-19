return {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html", -- only runs if nvim-treesitter is available
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-treesitter/nvim-treesitter", -- ✅ add this
    },
    opts = {
        -- your configuration here
    },
}
