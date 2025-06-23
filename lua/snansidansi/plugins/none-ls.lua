return {
	{
		"nvimtools/none-ls.nvim",

		dependencies = {
			"nvim-lua/plenary.nvim",
		},

		config = function()
			local null_ls = require("null-ls")
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

			local lsp_formatting = function(bufnr)
				vim.lsp.buf.format({
					filter = function(client)
						return client.name == "null-ls"
					end,
					bufnr = bufnr,
				})
			end

			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.google_java_format,
					null_ls.builtins.formatting.prettier,
					null_ls.builtins.formatting.clang_format,
				},

				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								lsp_formatting(bufnr)
							end,
						})
					end
				end,
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
