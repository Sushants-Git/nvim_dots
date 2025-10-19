return {
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      local api = require("supermaven-nvim.api")

      -- Stop Supermaven only if it's running at startup
      if api.is_running() then
        api.stop()
        vim.notify("Supermaven Disabled 💤", vim.log.levels.WARN, { title = "Supermaven" })
      end

      -- Keymap to toggle Supermaven
      vim.keymap.set({ "n", "i" }, "<C-\\>", function()
        if api.is_running() then
          api.stop()
          vim.notify("Supermaven Disabled 💤", vim.log.levels.WARN, { title = "Supermaven" })
        else
          api.start()
          api.use_free_version() -- ensure free mode when enabling
          vim.notify("Supermaven Enabled ⚡ (Free Mode)", vim.log.levels.INFO, { title = "Supermaven" })
        end
      end, { desc = "Toggle Supermaven" })
    end,
  },
}


-- return {
--   {
--     "supermaven-inc/supermaven-nvim",
--     config = function()
--       require("supermaven-nvim").setup({
--         disable_keymaps = false, -- ensures default keymaps are enabled
--         keymaps = {
--           accept_suggestion = "<C-J>", -- accept full suggestion
--           accept_word = "<C-j>",       -- accept next word
--           clear_suggestion = "<C-]>",  -- clear current suggestion
--         },
--         log_level = "info", -- optional: set to "off" for silence
--       })
--     end,
--   },
-- }

-- return {
--     {
--       "supermaven-inc/supermaven-nvim",
--       config = function()
--         require("supermaven-nvim").setup({})
--       end,
--     }
-- }
