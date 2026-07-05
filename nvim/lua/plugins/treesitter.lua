return {
  "nvim-treesitter/nvim-treesitter",
  config = function()
    vim.opt.runtimepath:append("C:/nvimdata/nvim-data/site")
    require("nvim-treesitter.install").compilers = { "gcc" }
    require("nvim-treesitter").setup({})
  end,
}
