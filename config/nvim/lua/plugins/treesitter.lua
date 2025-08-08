return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = {
        "css",
        "html",
        "typespec",
        "javascript",
        "typescript",
        "tsx",
        "go",
        "gomod",
        "gosum",
        "rust",
      },
    },
  },
}
