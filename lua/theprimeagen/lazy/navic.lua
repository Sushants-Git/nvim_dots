return {
    "SmiteshP/nvim-navic",
    config = function()
        require("nvim-navic").setup({
        })
        vim.o.winbar = ""
    end,
    opts = {
        separator = " ",
        highlight = true,
        depth_limit = 5,
        lazy_update_context = true,
    },
}

