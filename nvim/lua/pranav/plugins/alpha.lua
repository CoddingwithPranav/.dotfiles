return {
  "goolord/alpha-nvim",
  lazy = false,
  priority = 1000,
  init = function()
    -- Hide tabline and disable "No Name" buffer on startup
    vim.opt.showtabline = 0
    vim.opt.fillchars:append({ eob = " " })
  end,
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Set header
    dashboard.section.header.val = {
      "                                                     ",
      "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
      "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
      "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
      "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
      "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
      "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
      "                                                     ",
    }

    -- Set menu
    dashboard.section.buttons.val = {
      dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
      dashboard.button("SPC ee", "  > Toggle file explorer", "<cmd>NvimTreeToggle<CR>"),
      dashboard.button("SPC ff", "󰱼 > Find File", "<cmd>Telescope find_files<CR>"),
      dashboard.button("SPC fs", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
      dashboard.button("SPC wr", "󰁯  > Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
      dashboard.button("q", " > Quit NVIM", "<cmd>qa<CR>"),
    }

    -- Configure layout with padding
    dashboard.config.layout = {
      { type = "padding", val = 2 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
    }

    -- Setup alpha
    alpha.setup(dashboard.config)

    -- Force alpha to load on startup with no arguments
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        -- Only start Alpha if no arguments were passed and not in a git commit
        local should_skip = false
        if vim.fn.argc() > 0 or vim.fn.line2byte('$') ~= -1 or not vim.o.modifiable then
          should_skip = true
        end

        -- Skip alpha when a git commit is being created
        for _, arg in pairs(vim.v.argv) do
          if arg == "-c" or vim.startswith(arg, "+") or arg == "-b" then
            should_skip = true
            break
          end
        end

        if not should_skip then
          -- Delete empty initial buffer
          vim.cmd [[
            if bufnr('%') == 1 && bufname('%') == '' && !&modified
              bd!
            endif
          ]]
          -- Load alpha
          require('alpha').start()
        end
      end,
      group = vim.api.nvim_create_augroup("AlphaStart", { clear = true }),
    })

    -- Disable folding and other UI elements in alpha
    vim.cmd([[
      autocmd FileType alpha setlocal nofoldenable
      autocmd FileType alpha setlocal nomodifiable
      autocmd FileType alpha setlocal noshowmode
      autocmd FileType alpha setlocal noshowcmd
      autocmd FileType alpha setlocal nocursorline
      autocmd FileType alpha setlocal nocursorcolumn
    ]])
  end,
}
