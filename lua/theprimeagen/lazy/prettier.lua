return {
    {
        "prettier/vim-prettier",
        build = "yarn install --frozen-lockfile --production",                                                                                -- Install dependencies with yarn
        ft = { "javascriptreact", "typescriptreact", "javascript", "typescript", "css", "less", "scss", "json", "graphql", "markdown", "vue", "svelte", "yaml", "html" }, -- Supported filetypes
        config = function()
            vim.keymap.set("n", "<C-S-I>", ":Prettier<CR>", { noremap = true, silent = true })
        end
    }
}
