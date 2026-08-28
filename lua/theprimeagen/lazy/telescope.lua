return {
    "nvim-telescope/telescope.nvim",
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
        })

        local builtin = require("telescope.builtin")
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

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

        vim.keymap.set('n', '<leader>pr', builtin.resume, { desc = 'Resume last Telescope' })

        -- 🔁 Regex toggle for live grep.
        -- false = literal search (ripgrep --fixed-strings), true = full regex.
        -- Sticky for the session; flip it with <C-g> while the picker is open.
        local use_regex = false

        -- Opens live_grep in the current mode, with <C-g> bound to relaunch
        -- in the other mode while keeping whatever you've typed so far.
        local function live_grep_toggleable(query, title, extra_args)
            local args = vim.deepcopy(extra_args or {})
            if not use_regex then
                table.insert(args, "--fixed-strings")
            end

            builtin.live_grep({
                prompt_title = string.format(
                    "%s [%s] — <C-g> toggle regex",
                    title,
                    use_regex and "regex" or "literal"
                ),
                default_text = query,
                additional_args = function()
                    return args
                end,
                attach_mappings = function(prompt_bufnr, map)
                    -- telescope's own live_grep mapping, kept since we're
                    -- overriding its attach_mappings
                    map("i", "<c-space>", actions.to_fuzzy_refine)

                    local toggle = function()
                        local line = action_state.get_current_line()
                        actions.close(prompt_bufnr)
                        use_regex = not use_regex
                        vim.schedule(function()
                            live_grep_toggleable(line, title, extra_args)
                        end)
                    end

                    map({ "i", "n" }, "<C-g>", toggle)
                    return true
                end,
            })
        end

        -- Prompts for the initial query, then hands off to the picker
        local function grep_prompt(label, title, extra_args)
            return function()
                vim.ui.input({
                    prompt = string.format("%s (%s): ", label, use_regex and "regex" or "literal"),
                    default = "",
                }, function(input)
                    if not input then
                        return
                    end

                    input = vim.trim(input)

                    if input ~= "" then
                        live_grep_toggleable(input, title, extra_args)
                    end
                end)
            end
        end

        vim.keymap.set("n", "<leader>ps", grep_prompt("Grep", "Live Grep"),
            { desc = "Live grep (toggle regex with <C-g>)" })

        -- 📦 Same as <leader>ps, but ignores .gitignore (searches node_modules, dotfiles, etc.)
        vim.keymap.set("n", "<leader>pn", grep_prompt(
            "Grep (no ignore)",
            "Live Grep (node_modules + hidden)",
            { "--no-ignore", "--hidden", "--glob=!.git/*" }
        ), { desc = "Live grep including node_modules/hidden files" })

        -- 🔀 Flip the default mode without opening a picker
        vim.keymap.set("n", "<leader>pg", function()
            use_regex = not use_regex
            vim.notify("Grep mode: " .. (use_regex and "regex" or "literal"))
        end, { desc = "Toggle grep regex mode" })

        -- 📚 Help tags
        vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
    end,
}
