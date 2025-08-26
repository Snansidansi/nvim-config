return {
    "nvim-lualine/lualine.nvim",

    config = function()
        require("lualine").setup({
            options = {
                icons_enabled = false,
                theme = "ayu_mirage",
                refresh = {
                    statusline = 1000,
                },
            },
        })
    end,
}
