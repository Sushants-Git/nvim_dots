return {
    {
        "prettier/vim-prettier",
        build = "yarn install --frozen-lockfile --production",                                                                                                            -- Install dependencies with yarn
        ft = { "javascriptreact", "typescriptreact", "javascript", "typescript", "css", "less", "scss", "json", "graphql", "markdown", "vue", "svelte", "yaml", "html" }, -- Supported filetypes
        config = function()
            -- vim-prettier's internal resolver returns -1 (a Number) when it can't
            -- find a local prettier, then passes it to executable() -> E1174.
            -- Resolving the path ourselves short-circuits that code path entirely.
            local function resolve_prettier()
                local node_modules = vim.fs.find("node_modules", {
                    upward = true,
                    type = "directory",
                    path = vim.fn.expand("%:p:h"),
                })[1]

                if node_modules then
                    local local_exec = node_modules .. "/.bin/prettier"
                    if vim.fn.executable(local_exec) == 1 then
                        return local_exec
                    end
                end

                return vim.fn.exepath("prettier")
            end

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

                local function run_prettier()
                    local exec = resolve_prettier()
                    if exec == "" then
                        vim.notify("prettier not found", vim.log.levels.WARN)
                        return
                    end
                    vim.g["prettier#exec_cmd_path"] = exec
                    vim.cmd("Prettier")
                end

                if has_config(prettier_configs) then
                    run_prettier()
                elseif has_config(oxfmt_configs) then
                    vim.cmd("write")
                    vim.fn.system("oxfmt --write .")
                    vim.cmd("edit!")
                else
                    run_prettier()
                end
            end

            vim.keymap.set("n", "<C-S-I>", smart_format, { noremap = true, silent = true })
            vim.keymap.set("n", "<S-H>", smart_format, { noremap = true, silent = true })
        end
    }
}
