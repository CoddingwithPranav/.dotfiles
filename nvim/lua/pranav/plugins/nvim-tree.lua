-- return {
--   "nvim-tree/nvim-tree.lua",
--   dependencies = "nvim-tree/nvim-web-devicons",
--   config = function()
--     local nvimtree = require("nvim-tree")
--
--     -- recommended settings from nvim-tree documentation
--     vim.g.loaded_netrw = 1
--     vim.g.loaded_netrwPlugin = 1
--
--     nvimtree.setup({
--       view = {
--         width = 35,
--         relativenumber = true,
--       },
--       -- change folder arrow icons
--       renderer = {
--         indent_markers = {
--           enable = true,
--         },
--         icons = {
--           glyphs = {
--             folder = {
--               arrow_closed = "", -- arrow when folder is closed
--               arrow_open = "", -- arrow when folder is open
--             },
--           },
--         },
--       },
--       -- disable window_picker for
--       -- explorer to work well with
--       -- window splits
--       actions = {
--         open_file = {
--           window_picker = {
--             enable = false,
--           },
--         },
--       },
--       filters = {
--         custom = { ".DS_Store" },
--       },
--       git = {
--         ignore = false,
--       },
--     })
--
--     -- set keymaps
--     local keymap = vim.keymap -- for conciseness
--
--     keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
--     keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
--     keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
--     keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
--   end
-- }
return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '<leader>ee', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    { '<leader>ec', ':Neotree close<CR>', desc = 'NeoTree close', silent = true },
    { '<leader>ef', ':Neotree focus<CR>', desc = 'NeoTree focus', silent = true },
  },
  opts = {
    sources = { "filesystem", "buffers", "git_status", "document_symbols" },
    add_blank_line_at_top = false,
    close_if_last_window = true,
    popup_border_style = "rounded",
    filesystem = {
      follow_current_file = {
        enabled = true,
      },
      hijack_netrw_behavior = "open_default",
      use_libuv_file_watcher = true,
      filtered_items = {
        visible = false,
        hide_dotfiles = true,
        hide_gitignored = true,
        never_show = {
          ".DS_Store",
        },
      },
      window = {
        width = 35,
        mappings = {
          ['\\'] = 'close_window',
          ['l'] = 'open',
          ['h'] = 'close_node',
        },
      },
    },
    window = {
      position = "left",
      width = 35,
      mapping_options = {
        noremap = true,
        nowait = true,
      },
    },
    git_status = {
      window = {
        position = "float",
        mappings = {
          ['g'] = 'refresh',
          ['<CR>'] = 'open',
        },
      },
    },
    event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function(_) vim.opt_local.signcolumn = "auto" end,
      },
    },
  },
}

