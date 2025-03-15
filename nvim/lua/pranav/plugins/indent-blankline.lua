-- return {
--   "lukas-reineke/indent-blankline.nvim",
--   event = { "BufReadPre", "BufNewFile" },
--   main = "ibl",
--   opts = {
--     indent = { char = "┊" },
--   },
-- }
return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },
}
