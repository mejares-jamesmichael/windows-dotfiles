return {
  {
    "folke/snacks.nvim",
    opts = { dashboard = { enabled = false } },
  },
  {
    "MaximilianLloyd/ascii.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
  },
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local ascii = require("ascii")
      require("dashboard").setup({
        theme = "doom",
        hide = {
          statusline = false,
          tabline = false,
          winbar = false,
        },
        config = {
          header = (function()
            local art = ascii.art.text.neovim.delta_corps_priest1
            local top_padding = { "", "", "", "", "" }
            local bottom_padding = { "", "" }
            local result = {}
            vim.list_extend(result, top_padding)
            vim.list_extend(result, art)
            vim.list_extend(result, bottom_padding)
            return result
          end)(),
          center = {
            {
              icon = " ",
              desc = "Find File",
              key = "f",
              key_format = " %s",
              action = "lua Snacks.picker.files()",
            },
            {
              icon = " ",
              desc = "New File",
              key = "n",
              key_format = " %s",
              action = "ene | startinsert",
            },
            {
              icon = " ",
              desc = "Find Text",
              key = "g",
              key_format = " %s",
              action = "lua Snacks.picker.grep()",
            },
            {
              icon = " ",
              desc = "Recent Files",
              key = "r",
              key_format = " %s",
              action = "lua Snacks.picker.recent()",
            },
            {
              icon = " ",
              desc = "Restore Session",
              key = "s",
              key_format = " %s",
              action = "lua require('persistence').load()",
            },
            {
              icon = " ",
              desc = "Config",
              key = "c",
              key_format = " %s",
              action = "lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })",
            },
            {
              icon = "󰝰 ",
              desc = "File Browser (Yazi)",
              key = "y",
              key_format = " %s",
              action = "Yazi",
            },
            {
              icon = " ",
              desc = "LazyGit",
              key = "G",
              key_format = " %s",
              action = "lua Snacks.lazygit()",
            },
            {
              icon = " ",
              desc = "Lazy Extras",
              key = "x",
              key_format = " %s",
              action = "LazyExtras",
            },
            {
              icon = "󰒲 ",
              desc = "Lazy",
              key = "l",
              key_format = " %s",
              action = "Lazy",
            },
            {
              icon = " ",
              desc = "Quit",
              key = "q",
              key_format = " %s",
              action = "qa",
            },
          },
          footer = function()
            local stats = require("lazy").stats()
            return {
              "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. math.floor(
                stats.startuptime
              ) .. "ms",
            }
          end,
        },
      })
    end,
  },
}
