vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
-- vim.api.nvim_set_keymap('n', '<leader>cll', 'console.log()', { noremap = true, silent = true })


vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")
vim.keymap.set("n", "<C-S-P>", ":call mdip#MarkdownClipboardImage()<CR>")
vim.keymap.set("n", "mm", "<cmd>MarkdownPreview<CR>")

vim.keymap.set("n", "<leader>vwm", function()
    require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
    require("vim-with-me").StopVimWithMe()
end)

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- vim.keymap.set(
--     "n",
--     "<leader>ee",
--     "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
-- )

vim.keymap.set(
    "n",
    "<leader>ea",
    "oassert.NoError(err, \"\")<Esc>F\";a"
)

vim.keymap.set(
    "n",
    "<leader>ef",
    "oif err != nil {<CR>}<Esc>Olog.Fatalf(\"error: %s\\n\", err.Error())<Esc>jj"
)

vim.keymap.set(
    "n",
    "<leader>el",
    "oif err != nil {<CR>}<Esc>O.logger.Error(\"error\", \"error\", err)<Esc>F.;i"
)

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>");
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

-- terminal
vim.api.nvim_create_autocmd('TermOpen', {
    group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
    callback = function()
        vim.opt.number = false
        vim.opt.relativenumber = false
    end,
})

local job_id = 0

local term_buf = nil
local term_win = nil

vim.keymap.set("n", "<leader>st", function()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    -- Terminal is visible, hide it
    vim.api.nvim_win_hide(term_win)
    term_win = nil
  elseif term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    -- Terminal exists, reopen it in a horizontal split at the bottom
    vim.cmd("botright split")
    term_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(term_win, term_buf)
    vim.api.nvim_win_set_height(term_win, 15)
  else
    -- Create a new terminal
    vim.cmd("botright split")
    vim.cmd("term")
    term_win = vim.api.nvim_get_current_win()
    term_buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_win_set_height(term_win, 15)
  end

    job_id = vim.bo.channel
end, { noremap = true, silent = true })

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })

vim.keymap.set("n", "<leader>cll", function()
    vim.fn.chansend(job_id, {"clear\r\n"})
end)

vim.keymap.set("n", "<leader>br", function()
    vim.fn.chansend(job_id, {"bun run dev\r\n"})
end)

vim.keymap.set("n", "<leader>br", function()
    vim.fn.chansend(job_id, {"bun run dev\r\n"})
end)

vim.keymap.set("n", "<leader>tw", function()
  if vim.o.winbar == "" then
    vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
  else
    vim.o.winbar = ""
  end
end, { desc = "Toggle winbar with navic" })

-- Claude Code toggle (right-side vertical split)

local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
vim.keymap.set('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)

-- Re-order to previous/next
vim.keymap.set('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
vim.keymap.set('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)

-- Goto buffer in position 1-9
for i = 1, 9 do
    vim.keymap.set('n', '<A-' .. i .. '>', '<Cmd>BufferGoto ' .. i .. '<CR>', opts)
end
vim.keymap.set('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)













-- ─────────────────────────────
-- SPLIT MANAGEMENT REMAPS
-- ─────────────────────────────

local wk = { noremap = true, silent = true, desc = "" }

-- Create splits
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Horizontal Split" })
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Vertical Split" })

-- Navigate between splits (no conflict with your <C-j>/<C-k> quickfix)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move Left Split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move Right Split" })
vim.keymap.set("n", "<C-w>j", "<C-w>j", { desc = "Move Down Split" })
vim.keymap.set("n", "<C-w>k", "<C-w>k", { desc = "Move Up Split" })

-- Resize splits
vim.keymap.set("n", "<leader>w<Left>", ":vertical resize -5<CR>", { desc = "Resize Left" })
vim.keymap.set("n", "<leader>w<Right>", ":vertical resize +5<CR>", { desc = "Resize Right" })
vim.keymap.set("n", "<leader>w<Up>", ":resize +3<CR>", { desc = "Resize Up" })
vim.keymap.set("n", "<leader>w<Down>", ":resize -3<CR>", { desc = "Resize Down" })

-- Equalize or close splits
vim.keymap.set("n", "<leader>we", "<C-w>=", { desc = "Equalize Splits" })
vim.keymap.set("n", "<leader>wx", ":close<CR>", { desc = "Close Split" })

-- Switch between last two splits
vim.keymap.set("n", "<leader>ww", "<C-w>p", { desc = "Switch Last Split" })

-- Toggle between vertical/horizontal layout (reorganize)
vim.keymap.set("n", "<leader>wr", function()
  local win_count = #vim.api.nvim_tabpage_list_wins(0)
  if win_count == 2 then
    vim.cmd("wincmd H")
  end
end, { desc = "Rotate Split Layout" })

-- New tab with same buffer, same cursor position
vim.keymap.set("n", "<leader>tn", ":tab split<CR>", { desc = "New Tab Same Position" })
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { desc = "Close Tab" })

-- Zoom toggle: full-screen current split, press again to restore
local _zoom_state = {}
vim.keymap.set("n", "<leader>wz", function()
  local tab = vim.api.nvim_get_current_tabpage()
  if _zoom_state[tab] then
    vim.cmd("wincmd =")
    _zoom_state[tab] = false
  else
    vim.cmd("wincmd |")
    vim.cmd("wincmd _")
    _zoom_state[tab] = true
  end
end, { desc = "Toggle Zoom Split" })

vim.keymap.set('n', '<leader>q', ':q<CR>', { noremap = true, silent = true })

vim.keymap.set("n", "<leader>tb", function()
    vim.o.showtabline = vim.o.showtabline == 0 and 2 or 0
end, { desc = "Toggle tabline" })

-- Copy current line / selection with file path and line range (for Claude Code)
local function copy_for_claude(visual)
    local start_line, end_line
    if visual then
        start_line = vim.fn.line("v")
        end_line = vim.fn.line(".")
        if start_line > end_line then
            start_line, end_line = end_line, start_line
        end
    else
        start_line = vim.fn.line(".")
        end_line = start_line
    end

    local file = vim.fn.expand("%:p")
    local cwd = vim.fn.getcwd()
    local rel = file
    if file:sub(1, #cwd) == cwd then
        rel = file:sub(#cwd + 2)
    end

    local ref
    if start_line == end_line then
        ref = "@" .. rel .. "#L" .. start_line
    else
        ref = "@" .. rel .. "#L" .. start_line .. "-L" .. end_line
    end

    vim.fn.setreg("+", ref)
    vim.fn.setreg('"', ref)
    vim.notify("Copied " .. ref)
end

vim.keymap.set("n", "<leader>;;", function() copy_for_claude(false) end,
    { desc = "Copy file:line ref" })
vim.keymap.set("x", "<leader>;;", function() copy_for_claude(true) end,
    { desc = "Copy file:lines ref" })

-- Copy current line as GitHub permalink
vim.keymap.set("n", "<leader>gl", function()
    local file = vim.fn.expand("%:p")
    local line = vim.fn.line(".")

    local git_root = vim.fn.system("git -C " .. vim.fn.shellescape(vim.fn.fnamemodify(file, ":h")) .. " rev-parse --show-toplevel"):gsub("\n", "")
    local remote = vim.fn.system("git -C " .. vim.fn.shellescape(git_root) .. " remote get-url origin"):gsub("\n", "")
    local commit = vim.fn.system("git -C " .. vim.fn.shellescape(git_root) .. " rev-parse HEAD"):gsub("\n", "")
    local rel_path = file:sub(#git_root + 2)

    -- Normalize remote URL to https
    remote = remote:gsub("git@github%.com:", "https://github.com/")
    remote = remote:gsub("%.git$", "")

    local url = remote .. "/blob/" .. commit .. "/" .. rel_path .. "#L" .. line
    vim.fn.setreg("+", url)
    vim.notify("Copied: " .. url)
end, { desc = "Copy line as GitHub link" })

