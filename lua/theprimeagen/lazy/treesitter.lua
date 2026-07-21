return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
        local ts = require("nvim-treesitter")

        ts.install({
            "vimdoc", "javascript", "typescript", "c", "lua", "rust",
            "jsdoc", "bash", "templ",
        })

        vim.treesitter.language.register("templ", "templ")

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("theprimeagen-treesitter", { clear = true }),
            callback = function(args)
                local buf = args.buf
                local lang = vim.treesitter.language.get_lang(args.match)
                if not lang or lang == "html" then
                    return
                end

                local max_filesize = 500 * 1024 -- 500 KB
                local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    vim.notify(
                        "File larger than 500KB treesitter disabled for performance",
                        vim.log.levels.WARN,
                        { title = "Treesitter" }
                    )
                    return
                end

                local function start()
                    if not pcall(vim.treesitter.start, buf, lang) then
                        return
                    end
                    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    if lang == "markdown" then
                        vim.bo[buf].syntax = "on"
                    end
                end

                if vim.treesitter.language.add(lang) then
                    start()
                elseif vim.tbl_contains(require("nvim-treesitter.config").get_available(), lang) then
                    -- Parser not installed yet: install it, then attach.
                    ts.install({ lang }):await(function()
                        if vim.api.nvim_buf_is_valid(buf) then
                            start()
                        end
                    end)
                end
            end,
        })
    end,
}
