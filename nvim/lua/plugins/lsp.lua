return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      phpactor = {
        mason = false,
        autostart = false,
      },
    },
  },
}
