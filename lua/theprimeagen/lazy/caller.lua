-- caller.nvim - https://github.com/Sushants-Git/caller.nvim
--
-- Installed from GitHub like any other user would get it, rather than from the
-- local checkout, so this config exercises the real install path.
-- Development happens in ~/caller; push there, then :Lazy update caller.nvim.
return {
  {
    "Sushants-Git/caller.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    cmd = { "Caller", "CallerPick", "CallerQf", "CallerAll", "CallerQfAll" },
    keys = {
      { "<leader>cr", "<cmd>CallerPick<cr>", desc = "Callers (Telescope, with preview)" },
      { "<leader>ct", "<cmd>Caller<cr>", desc = "Callers (tree, whole chain at once)" },
      { "<leader>cq", "<cmd>CallerQf<cr>", desc = "Callers -> quickfix" },
    },
    opts = {},
  },
}
