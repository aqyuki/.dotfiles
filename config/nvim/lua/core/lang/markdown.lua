return {
  {
    "ixru/nvim-markdown",
    ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
    config = function(_, _)
      vim.g.vim_markdown_math = 1
      vim.g.vim_markdown_frontmatter = 1
      vim.g.vim_markdown_toml_frontmatter = 1
      vim.g.vim_markdown_json_frontmatter = 1
      vim.g.vim_markdown_no_default_key_mappings = 1
    end,
  },
}
