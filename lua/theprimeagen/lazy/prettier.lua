return {
    {
        "prettier/vim-prettier",
        build = "yarn install --frozen-lockfile --production",                                                                                                            -- Install dependencies with yarn
        ft = { "javascriptreact", "typescriptreact", "javascript", "typescript", "css", "less", "scss", "json", "graphql", "markdown", "vue", "svelte", "yaml", "html" }, -- Supported filetypes
        config = function()
            local function smart_format()
                local prettier_configs = {
                    ".prettierrc", ".prettierrc.json", ".prettierrc.json5",
                    ".prettierrc.yaml", ".prettierrc.yml", ".prettierrc.toml",
                    ".prettierrc.js", ".prettierrc.cjs", ".prettierrc.mjs",
                    "prettier.config.js", "prettier.config.cjs", "prettier.config.mjs",
                }
                local oxfmt_configs = {
                    ".oxfmtrc.json", ".oxlintrc.json",
                }
                local root = vim.fn.getcwd()

                local function has_config(names)
                    for _, name in ipairs(names) do
                        if vim.fn.filereadable(root .. "/" .. name) == 1 then
                            return true
                        end
                    end
                    return false
                end

                if has_config(prettier_configs) then
                    vim.cmd("Prettier")
                elseif has_config(oxfmt_configs) then
                    vim.cmd("write")
                    vim.fn.system("oxfmt --write .")
                    vim.cmd("edit!")
                else
                    vim.cmd("Prettier")
                end
            end

            vim.keymap.set("n", "<C-S-I>", smart_format, { noremap = true, silent = true })
            vim.keymap.set("n", "<S-H>", smart_format, { noremap = true, silent = true })
        end
    }
}
