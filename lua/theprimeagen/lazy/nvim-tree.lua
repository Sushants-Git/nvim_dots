return {
  "kyazdani42/nvim-tree.lua",

  config = function()
    -- Disable netrw at the very start
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- Optionally enable 24-bit color
    vim.opt.termguicolors = true

    -- Setup nvim-tree with options
    require('nvim-tree').setup({
      sort = {
        sorter = "case_sensitive",
      },
      view = {
        width = 30,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = true,
      },
    })

    -- Key mapping for toggling NvimTree
    vim.keymap.set('n', '<leader>ee', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
  end
}

