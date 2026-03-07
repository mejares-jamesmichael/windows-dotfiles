return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        -- Set markdown to an empty table to disable linting for it entirely
        markdown = {}, 
      },
    },
  },
}