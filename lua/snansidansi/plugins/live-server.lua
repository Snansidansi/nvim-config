return {
    --  run `npm install -g live-server`
    'barrett-ruth/live-server.nvim',

    config = function()
        require("live-server").setup({
            args = { "--browser=explorer.exe" }
        })
    end,

    cmd = { "LiveServerStart", "LiveServerStop" },

    vim.keymap.set("n", "<leader>ls", "<cmd>LiveServerStart<CR>"),
    vim.keymap.set("n", "<leader>lS", "<cmd>LiveServerStop<CR>"),
}
