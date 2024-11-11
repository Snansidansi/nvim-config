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

vim.cmd([[
    augroup line_wrapping
        autocmd!
        autocmd FileType markdown setlocal wrap
        autocmd FileType text setlocal wrap
    augroup end
]])
