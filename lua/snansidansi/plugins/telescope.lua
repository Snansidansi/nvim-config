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

				extensions = {
					aerial = {
						-- Set the width of the first two columns (the second
						-- is relevant only when show_columns is set to 'both')
						col1_width = 4,
						col2_width = 30,
						-- How to format the symbols
						format_symbol = function(symbol_path, filetype)
							if filetype == "json" or filetype == "yaml" then
								return table.concat(symbol_path, ".")
							else
								return symbol_path[#symbol_path]
							end
						end,
						-- Available modes: symbols, lines, both
						show_columns = "both",
					},
				},
			})

			vim.keymap.set("n", "<leader>pa", "<cmd>Telescope aerial<CR>")

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
