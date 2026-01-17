return {
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      local supermaven = require("supermaven-nvim")
      local api = require("supermaven-nvim.api")

      -- Setup without auto-start side effects
      supermaven.setup({})

      -- Force OFF on startup (new nvim instance)
      vim.schedule(function()
        if api.is_running() then
          api.stop()
        end
      end)

      -- Toggle keymap
      vim.keymap.set({ "n", "i" }, "<C-\\>", function()
        api.toggle()

        if api.is_running() then
          vim.schedule(function()
            pcall(vim.cmd, "SupermavenUseFree")
          end)
          vim.notify(
            "Supermaven Enabled ⚡ (Free Mode)",
            vim.log.levels.INFO,
            { title = "Supermaven" }
          )
        else
          vim.notify(
            "Supermaven Disabled 💤",
            vim.log.levels.WARN,
            { title = "Supermaven" }
          )
        end
      end, { desc = "Toggle Supermaven" })
    end,
  },
}

