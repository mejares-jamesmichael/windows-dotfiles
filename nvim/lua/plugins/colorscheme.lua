return {
  -- add catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      transparent_background = true,
    },
  },

  -- Configure LazyVim to load catppuccin-mocha
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
}
