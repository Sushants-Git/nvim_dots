vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- vim.opt.colorcolumn = "80"


-- ─────────────────────────────
-- FOLDING (treesitter-aware)
-- ─────────────────────────────

-- Use treesitter for folds when a parser exists, otherwise fold nothing.
_G.SmartFoldExpr = function()
    local parser = vim.treesitter.get_parser(0, nil, { error = false })
    if parser then
        return vim.treesitter.foldexpr()
    end
    return "0"
end

-- Folded lines render as: the first line (syntax highlighted) + a line count,
-- so a collapsed block is obvious instead of looking like an ordinary line.
_G.SmartFoldText = function()
    local lnum = vim.v.foldstart
    local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1] or ""
    line = line:gsub("\t", string.rep(" ", vim.bo.tabstop))

    local chunks = {}
    local text, hl = "", nil
    for col = 0, #line - 1 do
        local captures = vim.treesitter.get_captures_at_pos(0, lnum - 1, col)
        local this_hl = "Folded"
        if #captures > 0 then
            local c = captures[#captures]
            this_hl = "@" .. c.capture .. "." .. c.lang
        end
        if this_hl == hl then
            text = text .. line:sub(col + 1, col + 1)
        else
            if hl then
                table.insert(chunks, { text, hl })
            end
            text, hl = line:sub(col + 1, col + 1), this_hl
        end
    end
    if hl then
        table.insert(chunks, { text, hl })
    end

    local count = vim.v.foldend - vim.v.foldstart + 1
    table.insert(chunks, { "  ⋯ " .. count .. " lines ", "Folded" })
    return chunks
end

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.SmartFoldExpr()"
vim.opt.foldtext = "v:lua.SmartFoldText()"
vim.opt.fillchars:append({ fold = " " })  -- no trailing dots
vim.opt.foldnestmax = 4                   -- don't fold every tiny block
vim.opt.foldlevel = 99                    -- files open fully expanded...
vim.opt.foldlevelstart = 99               -- ...every time
