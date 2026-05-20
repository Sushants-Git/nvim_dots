return {
  "kyazdani42/nvim-tree.lua",

  config = function()
    -- Disable netrw at the very start
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- Optionally enable 24-bit color
    vim.opt.termguicolors = true

    local function quicklook(node)
      node = node or require("nvim-tree.api").tree.get_node_under_cursor()
      if not node or not node.absolute_path or node.nodes then return end
      vim.fn.jobstart({ "qlmanage", "-p", node.absolute_path }, { detach = true })
    end

    local function on_attach(bufnr)
      local api = require("nvim-tree.api")
      api.config.mappings.default_on_attach(bufnr)
      vim.keymap.set("n", "<leader>ql", quicklook,
        { desc = "Quick Look", buffer = bufnr, noremap = true, silent = true })
    end

    -- Setup nvim-tree with options
    require('nvim-tree').setup({
      on_attach = on_attach,
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

