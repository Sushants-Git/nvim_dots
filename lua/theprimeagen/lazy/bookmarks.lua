-- Line bookmarks: mark a line, it gets a colored background + a sign in the
-- gutter, and it survives restarts. Marks live in a single file keyed by
-- absolute path, so they follow you across projects.
return {
    "tomasky/bookmarks.nvim",

    event = "VeryLazy",

    config = function()
        local bm = require("bookmarks")

        -- Colors for the marked line. Tweak these two tables to taste.
        local palette = {
            dark  = { line = "#3b3320", sign = "#e2b714", ann_line = "#20323b", ann_sign = "#5cc7e0" },
            light = { line = "#fff4c9", sign = "#b07d00", ann_line = "#d9f0f7", ann_sign = "#00728f" },
        }

        local function apply_highlights()
            local c = palette[vim.o.background] or palette.dark
            vim.api.nvim_set_hl(0, "BookMarksAdd", { fg = c.sign, bold = true })
            vim.api.nvim_set_hl(0, "BookMarksAddLn", { bg = c.line })
            vim.api.nvim_set_hl(0, "BookMarksAnn", { fg = c.ann_sign, bold = true })
            vim.api.nvim_set_hl(0, "BookMarksAnnLn", { bg = c.ann_line })
        end

        bm.setup({
            save_file = vim.fn.stdpath("data") .. "/bookmarks",
            signcolumn = true, -- ⚑ in the gutter
            linehl = true,     -- the colored line itself
            numhl = false,
            sign_priority = 8,
            signs = {
                add = { hl = "BookMarksAdd", text = "⚑", numhl = "BookMarksAddNr", linehl = "BookMarksAddLn" },
                ann = { hl = "BookMarksAnn", text = "♥", numhl = "BookMarksAnnNr", linehl = "BookMarksAnnLn" },
            },
        })

        -- The plugin only links its base groups, and colors.lua swaps themes at
        -- runtime, so re-assert ours after every colorscheme change.
        apply_highlights()
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("bookmarks-colors", { clear = true }),
            callback = apply_highlights,
        })

        pcall(function()
            require("telescope").load_extension("bookmarks")
        end)

        local function list()
            local ok = pcall(function()
                require("telescope").extensions.bookmarks.list()
            end)
            if not ok then
                bm.bookmark_list() -- quickfix fallback
                vim.cmd("copen")
            end
        end

        local map = vim.keymap.set
        map("n", "<leader>mm", bm.bookmark_toggle, { desc = "Bookmark: toggle on this line" })
        map("n", "<leader>mi", bm.bookmark_ann, { desc = "Bookmark: add/edit note" })
        map("n", "<leader>ml", list, { desc = "Bookmark: list all" })
        map("n", "<leader>mn", bm.bookmark_next, { desc = "Bookmark: next in buffer" })
        map("n", "<leader>mp", bm.bookmark_prev, { desc = "Bookmark: prev in buffer" })
        map("n", "<leader>mc", bm.bookmark_clean, { desc = "Bookmark: clear this buffer" })
        map("n", "<leader>mX", bm.bookmark_clear_all, { desc = "Bookmark: clear everywhere" })
    end,
}
