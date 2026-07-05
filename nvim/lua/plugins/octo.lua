return {
  "pwntester/octo.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = "Octo",
  opts = {
    enable_builtin = true,
    default_remote = { "origin" },
    picker = "snacks",
  },
  keys = {
    { "<leader>oi", "<cmd>Octo issue list<cr>", desc = "List Issues" },
    { "<leader>oI", "<cmd>Octo issue create<cr>", desc = "Create Issue" },
    { "<leader>op", "<cmd>Octo pr list<cr>", desc = "List PRs" },
    { "<leader>oP", "<cmd>Octo pr create<cr>", desc = "Create PR" },
    { "<leader>or", "<cmd>Octo review start<cr>", desc = "Start Review" },
    { "<leader>oR", "<cmd>Octo review submit<cr>", desc = "Submit Review" },
  },
}
