return {
  {
    'img-paste-devs/img-paste.vim',
    lazy = false, -- Ensure it loads immediately
    config = function()
      vim.g.mdip_imgdir = "img"  -- Set the image directory
      vim.g.mdip_imgname = "image" -- Set the default image name

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.keymap.set("n", "<leader>i", ":call mdip#MarkdownClipboardImage()<CR>", { buffer = true, silent = true })
        end,
      })
    end
  }
}

