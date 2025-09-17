return {
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      {
        "<leader>cj",
        function()
          require("treesj").toggle()
        end,
        mode = "n",
        desc = "toggle by TreeSJ",
      },
    },
    opts = {},
  },
}
