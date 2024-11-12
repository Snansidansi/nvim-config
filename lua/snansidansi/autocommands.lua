vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.cmd([[
    augroup jdtls_lsp
        autocmd!
        autocmd FileType java lua require("snansidansi.jdtls").setup_jdtls()
    augroup end
]])

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("LineWrapping", { clear = true }),
    pattern = { "markdown", "text" },
    callback = function()
        vim.opt_local.wrap = true
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "java" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.colorcolumn = "100"
    end,
})
