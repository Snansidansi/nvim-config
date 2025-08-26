return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",

        dependencies = { "nvim-lua/plenary.nvim" },

        config = function()
            require("telescope").setup({
                defaults = {
                    layout_config = {
                        vertical = {
                            width = 0.7,
                            height = 0.7,
                            prompt_position = "bottom",
                            preview_height = 0.5,
                            preview_cutoff = 0,
                        },
                    },
                    file_ignore_patterns = { "^target/", "node_modules/" },
                },
            })

            local builtin = require("telescope.builtin")

            vim.keymap.set("n", "<leader>pf", function()
                builtin.find_files({ layout_strategy = "vertical" })
            end)
            vim.keymap.set("n", "<leader>pg", function()
                builtin.live_grep({ layout_strategy = "vertical" })
            end)
            vim.keymap.set("n", "<leader>gf", function()
                builtin.git_files({ layout_strategy = "vertical" })
            end)
            vim.keymap.set("n", "<leader>lf", function()
                builtin.resume({ layout_strategy = "vertical" })
            end)
        end,
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",

        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
                require("telescope").load_extension("ui-select"),
            })
        end,
    },
}
