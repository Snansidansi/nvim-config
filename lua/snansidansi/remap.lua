local function feedkeys(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, false)
end

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("x", "<leader>p", '"_dP')

vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')

-- WSL copy to Windows clipboard
vim.keymap.set("v", "<leader>y", ':w !xclip -selection clipboard<CR><CR>')

vim.keymap.set("n", "<leader>t", ':sp<CR><C-w>j:term<CR>:exe "resize " . (&lines / 4)<CR>i')
vim.keymap.set("n", "<leader>T", function()
	local bufferDir = vim.fn.expand("%:p:h")
	feedkeys("<leader>t", "t")
	feedkeys("cd " .. bufferDir .. "<CR>", "n")
	feedkeys("clear<CR>", "n")
end)
vim.keymap.set("t", "<Esc>", "<C-\\><C-N>")
vim.keymap.set("t", "<C-x>", "<C-\\><C-N>:q<CR>")

vim.keymap.set("n", "<C-U>", "<C-U>zz")
vim.keymap.set("n", "<C-D>", "<C-D>zz")

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<C-w>v", "<C-w>v<C-w>l")
vim.keymap.set("n", "<C-w>s", "<C-w>s<C-w>j")

vim.keymap.set("n", "<leader>bw", "<cmd>setlocal wrap<CR>")
vim.keymap.set("n", "<leader>bW", "<cmd>setlocal nowrap<CR>")
