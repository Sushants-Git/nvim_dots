function mason_setup()
  require("mason").setup()

  local mason_lspconfig = require("mason-lspconfig")
  mason_lspconfig.setup({
    ensure_installed = { "lua_ls", "rust_analyzer", "gopls", "pyright", "zls" },
    automatic_installation = true,
  })

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

  local on_attach = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
      require("nvim-navic").attach(client, bufnr)
    end
  end

  ---------------------------------------------------------------------------
  -- Configure default options (for merging)
  ---------------------------------------------------------------------------
  local default_opts = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  ---------------------------------------------------------------------------
  -- Use Mason’s installed servers
  ---------------------------------------------------------------------------
  for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
    if server ~= "lua_ls" and server ~= "zls" then
      -- Extend defaults for each server
      local opts = vim.tbl_deep_extend("force", default_opts, {})
      vim.lsp.config(server, opts)
      vim.lsp.enable(server)
    end
  end

  ---------------------------------------------------------------------------
  -- Custom: Lua LS
  ---------------------------------------------------------------------------
  vim.lsp.config("lua_ls", vim.tbl_deep_extend("force", default_opts, {
    settings = {
      Lua = {
        runtime = { version = "Lua 5.1" },
        diagnostics = {
          globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
        },
      },
    },
  }))
  vim.lsp.enable("lua_ls")

  ---------------------------------------------------------------------------
  -- Custom: Zig LS
  ---------------------------------------------------------------------------
  vim.lsp.config("zls", vim.tbl_deep_extend("force", default_opts, {
    cmd = { "zls" },
    root_dir = function(fname)
      return vim.fs.root(fname, { ".git", "build.zig", "zls.json" })
    end,
    settings = {
      zls = {
        enable_inlay_hints = true,
        enable_snippets = true,
        warn_style = true,
      },
    },
  }))
  vim.lsp.enable("zls")

  vim.g.zig_fmt_parse_errors = 0
  vim.g.zig_fmt_autosave = 0
end


-- function mason_setup()
--     -- mason.nvim just manages LSP server binaries
--     require("mason").setup()
--
--     -- mason-lspconfig only ensures installation
--     require("mason-lspconfig").setup({
--       ensure_installed = {
--         "lua_ls",
--         "rust_analyzer",
--         "gopls",
--         "pyright",
--         "zls",
--       },
--       automatic_installation = true, -- optional
--     })
--
--     -- Define your global LSP options
--     local lspconfig = require("lspconfig")
--     local capabilities = vim.lsp.protocol.make_client_capabilities()
--     -- If you’re using cmp_nvim_lsp:
--     -- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
--
--     local on_attach = function(client, bufnr)
--       if client.server_capabilities.documentSymbolProvider then
--          require("nvim-navic").attach(client, bufnr)
--       end
--     end
--
--
--
--     -- Default setup for all servers
--     for _, server in ipairs(require("mason-lspconfig").get_installed_servers()) do
--       if server ~= "lua_ls" and server ~= "zls" then
--         lspconfig[server].setup({
--           on_attach = on_attach,
--           capabilities = capabilities,
--         })
--       end
--     end
--
--     -- Custom: Lua LS
--     lspconfig.lua_ls.setup({
--       on_attach = on_attach,
--       capabilities = capabilities,
--       settings = {
--         Lua = {
--           runtime = { version = "Lua 5.1" },
--           diagnostics = {
--             globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
--           },
--         },
--       },
--     })
--
--     -- Custom: Zig LSP
--     lspconfig.zls.setup({
--       on_attach = on_attach,
--       capabilities = capabilities,
--       root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
--       settings = {
--         zls = {
--           enable_inlay_hints = true,
--           enable_snippets = true,
--           warn_style = true,
--         },
--       },
--     })
--     vim.g.zig_fmt_parse_errors = 0
--     vim.g.zig_fmt_autosave = 0
-- end


return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        require("conform").setup({
            formatters_by_ft = {
            }
        })
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        local on_attach = function(client, buffer)
            if client.server_capabilities.documentSymbolProvider then
                require("nvim-navic").attach(client, buffer)
            end
        end

        require("fidget").setup({})
        mason_setup()

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
