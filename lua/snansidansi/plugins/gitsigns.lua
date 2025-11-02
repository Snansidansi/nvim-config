return {
    "lewis6991/gitsigns.nvim",

    config = function()
        require("gitsigns").setup({
            signs_staged = {
                add = { text = ">┃" },
                change = { text = ">┃" },
                delete = { text = ">_" },
                topdelete = { text = ">‾" },
                changedelete = { text = ">~" },
                untracked = { text = ">┆" },
            },
        })

        local gitsigns = require("gitsigns")

        vim.keymap.set("n", "<C-j>", function()
            gitsigns.nav_hunk("next")
        end)

        vim.keymap.set("n", "<C-k>", function()
            gitsigns.nav_hunk("prev")
        end)

        vim.keymap.set("n", "<leader>hs", gitsigns.stage_hunk)
        vim.keymap.set("n", "<leader>hu", gitsigns.undo_stage_hunk)
        vim.keymap.set("n", "<leader>hp", gitsigns.preview_hunk)
        vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk)
        vim.keymap.set("n", "<leader>hb", gitsigns.blame_line)
    end,
}
