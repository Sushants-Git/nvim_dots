return {
    'ThePrimeagen/harpoon',

    dependencies = {
        "nvim-lua/plenary.nvim",
    },

    config = function()
        local harpoon_mark = require("harpoon.mark") -- Import the 'mark' module
        local harpoon_ui = require("harpoon.ui")     -- Import the 'ui' module

        require("harpoon").setup()

        -- Key mappings
        vim.keymap.set("n", "<leader>A", function() harpoon_mark.add_file() end)         -- Add file to Harpoon list
        vim.keymap.set("n", "<leader>a", function() harpoon_mark.add_file() end)         -- Add file to Harpoon list

        vim.keymap.set("n", "<C-e>", function() harpoon_ui.toggle_quick_menu() end)      -- Toggle the quick menu

        vim.keymap.set("n", "<C-h>", function() harpoon_ui.nav_file(1) end)              -- Navigate to first file
        vim.keymap.set("n", "<C-t>", function() harpoon_ui.nav_file(2) end)              -- Navigate to second file
        vim.keymap.set("n", "<C-n>", function() harpoon_ui.nav_file(3) end)              -- Navigate to third file
        vim.keymap.set("n", "<C-s>", function() harpoon_ui.nav_file(4) end)              -- Navigate to fourth file

        -- Replace a file in the list (Harpoon doesn't have a direct `replace_at` function)
        vim.keymap.set("n", "<leader><C-h>", function()
            harpoon_mark.add_file()
            vim.notify("Replaced file at index 1", vim.log.levels.INFO)
        end)
    end
}

