-- LazyVim settings
vim.g.lazyvim_picker = "telescope"
vim.g.lazyvim_cmp = "blink.cmp"
vim.g.lazyvim_blink_main = true

-- Spell check
vim.opt.spelllang = { "cjk", "en" }

-- File
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = false
vim.opt.autoread = true

-- Encoding
vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- System integration
vim.opt.shell = "fish"
vim.opt.clipboard = { "unnamedplus", "unnamed" }

-- Diagnostic
vim.diagnostic.config({
  virtual_lines = {
    current_line = true,
  },
})
