return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },

    config = function()
        local telescope = require("telescope")

        telescope.setup({
            defaults = {
                -- Optional: tweak ripgrep arguments if you want
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                },
            },
            pickers = {
                -- 👇 Enable regex input mode by default for live_grep
                live_grep = {
                    use_regex = true,
                },
            },
        })

        local builtin = require("telescope.builtin")

        -- 🔍 File pickers
        vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
        vim.keymap.set("n", "<C-p>", builtin.git_files, {})

        -- 🔎 Word under cursor (small word / large word)
        vim.keymap.set("n", "<leader>pws", function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set("n", "<leader>pWs", function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)

        vim.keymap.set('n', '<leader>pr', require('telescope.builtin').resume, { desc = 'Resume last Telescope' })

        vim.keymap.set("n", "<leader>ps", function()
            local builtin = require("telescope.builtin")

            -- Prompt user for input and trim it before search
            local input = vim.fn.input("Grep: ")
            input = vim.trim(input)

            if input ~= "" then
                builtin.live_grep({
                    prompt_title = "Live Grep (regex supported)",
                    default_text = input,
                })
            end
        end)

        -- -- 🧠 Live Grep with regex support (your main fix)
        -- vim.keymap.set("n", "<leader>ps", function()
        --     builtin.live_grep({
        --         prompt_title = "Live Grep (regex supported)",
        --     })
        -- end)

        -- 📚 Help tags
        vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
    end,
}
