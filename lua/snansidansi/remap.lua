vim.g.mapleader = " "

vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("x", "<leader>p", '"_dP')

vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')

vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')

vim.keymap.set("n", "<leader>t", ':sp<CR><C-w>j:term<CR>:exe "resize " . (&lines / 4)<CR>i')
vim.keymap.set("t", "<Esc>", "<C-\\><C-N>")
vim.keymap.set("t", "<C-c>", "<C-\\><C-N>:q<CR>")

vim.keymap.set("n", "<C-U>", "<C-U>zz")
vim.keymap.set("n", "<C-D>", "<C-D>zz")

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<C-w>v", "<C-w>v<C-w>l")
vim.keymap.set("n", "<C-w>s", "<C-w>s<C-w>j")
