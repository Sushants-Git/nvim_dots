return {
    "github/copilot.vim",
    event = "InsertEnter", -- lazy-load on Insert mode
    config = function()
        -- Disable Copilot for all filetypes by default
        vim.g.copilot_filetypes = { ["*"] = false }
        -- Create commands to toggle Copilot
        vim.api.nvim_create_user_command("CopilotOn", function()
            vim.b.copilot_enabled = true
            vim.notify("Copilot enabled")
        end, {})
        vim.api.nvim_create_user_command("CopilotOff", function()
            vim.b.copilot_enabled = false
            vim.notify("Copilot disabled")
        end, {})
        vim.api.nvim_create_user_command("CopilotToggle", function()
            -- Run built-in Copilot status command silently
            vim.cmd("silent! Copilot status")
            -- Then toggle the enabled state
            vim.b.copilot_enabled = not (vim.b.copilot_enabled or false)
            vim.notify("Copilot " .. (vim.b.copilot_enabled and "enabled" or "disabled"))
        end, {})
        -- Add statusline function
        _G.CopilotStatus = function()
            if vim.b.copilot_enabled == nil then
                return ""
            end
            return vim.b.copilot_enabled and "⚡ Copilot" or ""
        end
        -- Use a more reliable keymapping - Ctrl+\ is more widely supported
        vim.keymap.set("n", "<C-\\>", ":CopilotToggle<CR>", { silent = true })

        -- Properly integrate Copilot status into statusline
        -- Save the current statusline first
        local current_statusline = vim.o.statusline

        -- Only modify if there's a statusline to modify
        if current_statusline and current_statusline ~= "" then
            -- Check if statusline already has a right alignment marker
            if current_statusline:find("%%=") then
                -- Insert Copilot status before the last item on the right side
                local parts = vim.split(current_statusline, "%%=")
                if #parts >= 2 then
                    local right_items = parts[2]
                    -- Find a good position to insert our status (before the last segment)
                    local pos = right_items:find(" [^%%]-$")
                    if pos then
                        right_items = right_items:sub(1, pos) .. "%{%v:lua.CopilotStatus()%} " .. right_items:sub(pos+1)
                    else
                        right_items = "%{%v:lua.CopilotStatus()%} " .. right_items
                    end
                    vim.o.statusline = parts[1] .. "%=" .. right_items
                else
                    -- Fallback if split didn't work as expected
                    vim.o.statusline = current_statusline .. " %{%v:lua.CopilotStatus()%}"
                end
            else
                -- No right alignment yet, add it with Copilot status on the right
                vim.o.statusline = current_statusline .. "%=%{%v:lua.CopilotStatus()%}"
            end
        else
            -- If no statusline is set, create a basic one with Copilot status on the right
            vim.o.statusline = "%f %h%w%m%r%= %{%v:lua.CopilotStatus()%} %y %l,%c %P"
        end
    end
}
