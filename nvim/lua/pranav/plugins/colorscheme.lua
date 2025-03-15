return {
  -- Tokyo Night Theme
  -- {
  --   "folke/tokyonight.nvim",
  --   priority = 1000, -- Load before other start plugins
  --   config = function()
  --     local transparent = false -- Enable transparency
  --     local bg = "#011628"
  --     local bg_dark = "#011423"
  --     local bg_highlight = "#143652"
  --     local bg_search = "#0A64AC"
  --     local bg_visual = "#275378"
  --     local fg = "#CBE0F0"
  --     local fg_dark = "#B4D0E9"
  --     local fg_gutter = "#627E97"
  --     local border = "#547998"

  --     require("tokyonight").setup({
  --       style = "night",
  --       transparent = transparent,
  --       styles = {
  --         sidebars = transparent and "transparent" or "dark",
  --         floats = transparent and "transparent" or "dark",
  --       },
  --       on_colors = function(colors)
  --         colors.bg = bg
  --         colors.bg_dark = transparent and colors.none or bg_dark
  --         colors.bg_float = transparent and colors.none or bg_dark
  --         colors.bg_highlight = bg_highlight
  --         colors.bg_popup = bg_dark
  --         colors.bg_search = bg_search
  --         colors.bg_sidebar = transparent and colors.none or bg_dark
  --         colors.bg_statusline = transparent and colors.none or bg_dark
  --         colors.bg_visual = bg_visual
  --         colors.border = border
  --         colors.fg = fg
  --         colors.fg_dark = fg_dark
  --         colors.fg_float = fg
  --         colors.fg_gutter = fg_gutter
  --         colors.fg_sidebar = fg_dark
  --       end,
  --     })
  --     -- Uncomment to load Tokyo Night by default
  --     -- vim.cmd([[colorscheme tokyonight]])
  --   end,
  -- },
  -- -- Catppuccin Theme
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin", -- Ensure proper naming for Lazy.nvim
  --   priority = 1000, -- Load early
  --   config = function()
  --     local transparent = true -- Match transparency preference

  --     require("catppuccin").setup({
  --       flavour = "mocha", -- Mocha for a rich dark look
  --       transparent_background = transparent,
  --       term_colors = true,
  --       styles = {
  --         comments = { "italic" },
  --         conditionals = { "italic" },
  --         loops = {},
  --         functions = {},
  --         keywords = {},
  --         strings = {},
  --         variables = {},
  --         numbers = {},
  --         booleans = {},
  --         properties = {},
  --         types = {},
  --         operators = {},
  --       },
  --       integrations = {
  --         cmp = true,
  --         gitsigns = true,
  --         nvimtree = true,
  --         telescope = true,
  --         notify = true,
  --         mini = true,
  --       },
  --       custom_highlights = function(colors)
  --         return {
  --           Normal = { fg = colors.text, bg = transparent and nil or colors.base },
  --           LineNr = { fg = colors.overlay0 },
  --           CursorLineNr = { fg = colors.mauve },
  --           StatusLine = { bg = transparent and nil or colors.mantle },
  --           VertSplit = { fg = colors.surface0 },
  --         }
  --       end,
  --     })
  --     -- Uncomment to load Catppuccin by default
  --     -- vim.cmd([[colorscheme catppuccin]])
  --   end,
  -- },
  -- -- Nightfly Theme
  {
    "bluz71/vim-nightfly-guicolors",
    priority = 1000, -- Load early
    config = function()
      -- Nightfly doesn’t have a Lua setup function, so we configure via Vim globals
      -- vim.g.nightflyTransparent = true -- Enable transparency
      vim.g.nightflyCursorColor = true -- Highlight cursor with color
      vim.g.nightflyNormalFloat = true -- Normal background for floating windows
      -- vim.g.nightflyTerminalColors = true -- Use Nightfly colors in terminal

      -- Load Nightfly by default (comment out to try others)
      vim.cmd([[colorscheme nightfly]])
    end,
  },
}