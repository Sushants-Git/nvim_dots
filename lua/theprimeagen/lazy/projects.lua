-- tabline: show project name (last cwd component) per tab
function _G.ProjectTabline()
    local s = ""
    for i = 1, vim.fn.tabpagenr("$") do
        local cwd = vim.fn.getcwd(-1, i)
        local name = vim.fn.fnamemodify(cwd, ":t")
        if i == vim.fn.tabpagenr() then
            s = s .. "%#TabLineSel# " .. name .. " %#TabLineFill#"
        else
            s = s .. "%#TabLine# " .. name .. " %#TabLineFill#"
        end
    end
    return s
end

vim.o.tabline = "%!v:lua.ProjectTabline()"
vim.o.showtabline = 0

-- no tabpages (we manage tabs ourselves), no curdir (we use tcd), no terminal
vim.o.sessionoptions = "buffers,folds,winsize,winpos,localoptions"

local session_dir = vim.fn.stdpath("data") .. "/project-sessions/"
vim.fn.mkdir(session_dir, "p")

local function session_file(cwd)
    return session_dir .. cwd:gsub("/", "%%") .. ".vim"
end

local function has_real_buffers()
    for _, buf in ipairs(vim.fn.tabpagebuflist()) do
        if vim.fn.bufname(buf) ~= ""
            and vim.fn.buflisted(buf) == 1
            and vim.bo[buf].filetype ~= "NvimTree" then
            return true
        end
    end
    return false
end

local function save_session(cwd)
    if not has_real_buffers() then return end
    pcall(vim.cmd, "NvimTreeClose")
    pcall(vim.cmd, "mksession! " .. vim.fn.fnameescape(session_file(cwd)))
end

local function restore_session(cwd)
    local f = session_file(cwd)
    if vim.fn.filereadable(f) == 1 then
        pcall(vim.cmd, "silent! source " .. vim.fn.fnameescape(f))
        return true
    end
    return false
end

-- auto-save session when leaving a tab or exiting
vim.api.nvim_create_autocmd({ "TabLeave", "VimLeavePre" }, {
    callback = function()
        save_session(vim.fn.getcwd())
    end,
})

vim.api.nvim_create_user_command("SessionClear", function()
    local files = vim.fn.glob(session_dir .. "*.vim", false, true)
    for _, f in ipairs(files) do vim.fn.delete(f) end
    vim.notify("Cleared " .. #files .. " session(s)")
end, {})

-- project picker
vim.keymap.set("n", "<leader>pp", function()
    local scan_dirs = {
        { path = vim.fn.expand("~/"), depth = 1 },
        { path = vim.fn.expand("~/Workspace"), depth = 2 },
        { path = vim.fn.expand("~/go/src"), depth = 2 },
    }

    local projects = {}
    local seen = {}

    for _, entry in ipairs(scan_dirs) do
        local base = entry.path
        if vim.fn.isdirectory(base) == 1 then
            local items = vim.fn.glob(base .. "/*", false, true)
            for _, dir in ipairs(items) do
                if vim.fn.isdirectory(dir) == 1 then
                    if vim.fn.isdirectory(dir .. "/.git") == 1 and not seen[dir] then
                        seen[dir] = true
                        table.insert(projects, dir)
                    end
                    if entry.depth == 2 then
                        local sub_items = vim.fn.glob(dir .. "/*", false, true)
                        for _, sub in ipairs(sub_items) do
                            if vim.fn.isdirectory(sub) == 1
                                and vim.fn.isdirectory(sub .. "/.git") == 1
                                and not seen[sub] then
                                seen[sub] = true
                                table.insert(projects, sub)
                            end
                        end
                    end
                end
            end
        end
    end

    table.sort(projects, function(a, b) return a:lower() < b:lower() end)

    local home = vim.fn.expand("~")

    require("telescope.pickers").new({}, {
        prompt_title = "Projects",
        finder = require("telescope.finders").new_table({
            results = projects,
            entry_maker = function(p)
                local disp = p:sub(1, #home) == home and ("~" .. p:sub(#home + 1)) or p
                return { value = p, display = disp, ordinal = disp }
            end,
        }),
        sorter = require("telescope.config").values.generic_sorter({}),
        attach_mappings = function(prompt_bufnr)
            require("telescope.actions").select_default:replace(function()
                local selection = require("telescope.actions.state").get_selected_entry()
                require("telescope.actions").close(prompt_bufnr)
                if not selection then return end

                local target = selection.value

                vim.schedule(function()
                    -- jump to existing tab if already open
                    for i = 1, vim.fn.tabpagenr("$") do
                        if vim.fn.getcwd(-1, i) == target then
                            vim.cmd("tabnext " .. i)
                            return
                        end
                    end

                    -- lock + save current tab before opening new one
                    local cur = vim.fn.getcwd()
                    vim.cmd("tcd " .. vim.fn.fnameescape(cur))
                    save_session(cur)

                    -- open new tab for target project
                    vim.cmd("tabnew")
                    vim.cmd("tcd " .. vim.fn.fnameescape(target))

                    vim.schedule(function()
                        if not restore_session(target) then
                            require("telescope.builtin").find_files()
                        end
                    end)
                end)
            end)
            return true
        end,
    }):find()
end, { desc = "Switch project" })

-- no plugin needed anymore
return {}
