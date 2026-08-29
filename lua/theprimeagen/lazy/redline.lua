-- redline.nvim - https://github.com/Sushants-Git/redline.nvim
--
-- Installed from GitHub like any other user would get it, rather than from the
-- local checkout, so this config exercises the real install path.
-- Development happens in ~/redline.nvim; push there, then :Lazy update redline.nvim.
--
-- lazy = false because setup() owns 26 keymaps that have to exist the moment
-- you reach for them, and the whole plugin loads in ~1ms: it does not run a
-- single git command until you actually turn it on.
--
-- telescope and nvim-web-devicons are deliberately NOT dependencies: redline
-- pcalls for them, and only when you open the overview, so declaring them here
-- would drag telescope into startup for nothing.
return {
  {
    "Sushants-Git/redline.nvim",
    lazy = false,
    opts = {},
  },
}
