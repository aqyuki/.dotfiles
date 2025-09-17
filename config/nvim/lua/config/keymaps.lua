local map = vim.keymap.set

-- Change mode
map("i", "jj", "<esc>", { silent = true, noremap = true })

-- Better delete
map("n", "x", '"_x', { silent = true, noremap = true })
