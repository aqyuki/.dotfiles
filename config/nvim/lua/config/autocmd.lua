local autocmd = vim.api.nvim_create_autocmd
autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})
