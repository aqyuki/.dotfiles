local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- from INSERT to NORMAL
keymap.set("i", "jj", "<Esc>", opts)
keymap.set("i", "kk", "<Esc>", opts)

-- delete
keymap.set("n", "x", '"_x', opts)

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')
