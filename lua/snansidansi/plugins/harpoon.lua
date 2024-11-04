return {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    branch = "harpoon2",
    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        local harpoon = require("harpoon")

        -- REQUIRED
        harpoon:setup()
        -- REQUIRED

        vim.keymap.set("n", "M", function() harpoon:list():add() end)
        vim.keymap.set("n", "<leader><Tab>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

        vim.keymap.set("n", "<leader>sh", function() harpoon:list():select(1) end)
        vim.keymap.set("n", "<leader>sj", function() harpoon:list():select(2) end)
        vim.keymap.set("n", "<leader>sk", function() harpoon:list():select(3) end)
        vim.keymap.set("n", "<leader>sl", function() harpoon:list():select(4) end)
    end
}
