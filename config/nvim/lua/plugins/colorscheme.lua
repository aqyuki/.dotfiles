return {
  {
    "Shatur/neovim-ayu",
    lazy = true,
    opts = {
      terminal = true,
    },
    config = function(_, opts)
      require("ayu").setup(opts)
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = {},
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "moon",
    },
  },
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = true,
    opts = {
      transparent = false,
    },
  },
  {
    "cocopon/iceberg.vim",
    lazy = true,
  },
  {
    "shaunsingh/nord.nvim",
    lazy = true,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
  },
  {
    "catppuccin/nvim",
    lazy = true,
    opts = {
      flavour = "mocha",
      transparent_background = true,
      float = {
        transparent = true,
      },
      integrations = {
        blink_cmp = {
          style = "bordered",
        },
      },
    },
  },
}
