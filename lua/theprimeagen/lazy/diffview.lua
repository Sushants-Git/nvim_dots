return {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    config = function()
        require("diffview").setup()

        -- Open the diff view against the index / a git rev
        vim.keymap.set("n", "<leader>gdo", "<cmd>DiffviewOpen<CR>", { desc = "Diffview: open" })
        vim.keymap.set("n", "<leader>gdc", "<cmd>DiffviewClose<CR>", { desc = "Diffview: close" })

        -- File history: whole repo or just the current file
        vim.keymap.set("n", "<leader>gdh", "<cmd>DiffviewFileHistory<CR>", { desc = "Diffview: repo history" })
        vim.keymap.set("n", "<leader>gdf", "<cmd>DiffviewFileHistory %<CR>", { desc = "Diffview: file history" })

        -- Toggle the file panel
        vim.keymap.set("n", "<leader>gdt", "<cmd>DiffviewToggleFiles<CR>", { desc = "Diffview: toggle files" })
    end
}
