return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")
    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
        "ts_ls",           -- TypeScript/JavaScript
        "html",              -- HTML
        "cssls",             -- CSS
        "tailwindcss",       -- Tailwind CSS
        "lua_ls",            -- Lua
        "emmet_ls",          -- Emmet
        "angularls",         -- Angular
        "jsonls",            -- JSON
        "eslint",            -- ESLint
        "graphql",           -- GraphQL
        "prismals",          -- Prisma
        "svelte",            -- Svelte
      },
      automatic_installation = true,
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettier",          -- prettier formatter
        "stylua",           -- lua formatter
        "eslint_d",         -- js/ts linter
        "jsonlint",         -- json linter
      },
    })
  end,
}
