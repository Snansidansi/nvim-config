return {
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',

        dependencies = { 'nvim-lua/plenary.nvim' },

        config = function()
            require("telescope").setup({})
            local builtin = require("telescope.builtin")

            vim.keymap.set('n', "<leader>pf", builtin.find_files, {})
            vim.keymap.set('n', "<leader>pg", builtin.live_grep, {})
            vim.keymap.set('n', "<leader>gf", builtin.git_files, {})
        end
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",

        config = function()
            require("telescope").setup {
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {
                        }
                    },
                },
                require("telescope").load_extension("ui-select")
            }
        end
    }
}
