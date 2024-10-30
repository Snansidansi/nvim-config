return {
	{
		"nvimtools/none-ls.nvim",

		dependencies = {
			"nvim-lua/plenary.nvim",
		},

		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.google_java_format,
				},
			})

			vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format)
		end,
	},
	{
		"jay-babu/mason-null-ls.nvim",

		event = { "BufReadPre", "BufNewFile" },

		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
		},

		config = function()
			require("mason").setup()
			require("mason-null-ls").setup({
				handlers = {},
				automatic_installation = true,
			})
		end,
	},
}
