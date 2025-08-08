return {
  {
    "folke/snacks.nvim",
    optional = true,
    opts = {
      bigfile = { enabled = true },
      picker = {
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
          },
        },
      },
      quickfile = { enabled = true },
    },
  },
  {
    "akinsho/bufferline.nvim",
    optional = true,
    opts = {
      options = {
        separator_style = "slant",
      },
    },
  },
  {
    "petertriho/nvim-scrollbar",
    event = "LazyFile",
    opts = {
      handlers = {
        gitsigns = true,
        search = true,
      },
    },
  },
  {
    "mvllow/modes.nvim",
    event = "BufEnter",
    opts = {},
  },
  {
    "kevinhwang91/nvim-hlslens",
    dependencies = { "petertriho/nvim-scrollbar" },
    event = { { event = "CmdlineEnter", pattern = "/" } },
    opts = {},
    config = function(_, opts)
      require("scrollbar.handlers.search").setup(opts)
    end,
  },
}
