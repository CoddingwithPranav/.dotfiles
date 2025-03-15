return {
  "norcalli/nvim-colorizer.lua",
  ft = { "css", "scss", "sass", "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "svelte", "angular" },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("colorizer").setup({
      filetypes = {
        "css",
        "scss",
        "sass",
        "html",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "vue",
        "svelte",
        "angular",
        "*", -- Highlight colors in all files
      },
      user_default_options = {
        RGB = true,           -- #RGB hex codes
        RRGGBB = true,       -- #RRGGBB hex codes
        RRGGBBAA = true,     -- #RRGGBBAA hex codes
        rgb_fn = true,       -- CSS rgb() and rgba() functions
        hsl_fn = true,       -- CSS hsl() and hsla() functions
        css = true,          -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true,       -- Enable all CSS *functions*: rgb_fn, hsl_fn
        mode = "background", -- Set the display mode: foreground or background
        tailwind = true,    -- Enable tailwind colors
        sass = { enable = true }, -- Enable sass colors
        virtualtext = "■",  -- Set the virtual text character
        always_update = true -- Update colors in real-time as you type
      },
      -- Exclude some filetypes from highlighting
      buftypes = {
        -- exclude these buftypes from highlighting
        "terminal",
        "popup",
      },
    })

    -- Create autocmds to ensure colorizer is attached
    local group = vim.api.nvim_create_augroup("Colorizer", { clear = true })
    
    -- Attach on InsertEnter
    vim.api.nvim_create_autocmd("InsertEnter", {
      group = group,
      pattern = { "*.css", "*.scss", "*.sass", "*.html", "*.js", "*.ts", "*.jsx", "*.tsx", "*.vue", "*.svelte" },
      command = "ColorizerAttachToBuffer",
    })

    -- Also attach on BufEnter to ensure it works when just opening files
    vim.api.nvim_create_autocmd("BufEnter", {
      group = group,
      pattern = { "*.css", "*.scss", "*.sass", "*.html", "*.js", "*.ts", "*.jsx", "*.tsx", "*.vue", "*.svelte" },
      command = "ColorizerAttachToBuffer",
    })
  end,
}
