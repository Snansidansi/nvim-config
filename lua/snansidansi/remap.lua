vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>t", ":sp<CR><C-w>j:term<CR>:exe \"resize \" . (&lines / 4)<CR>i")
vim.keymap.set("t", "<Esc>", "<C-\\><C-N>")
vim.keymap.set("t", "<leader><Esc>", "<C-\\><C-N>:q<CR>")
