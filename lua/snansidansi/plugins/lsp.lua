return {
	{
		"williamboman/mason.nvim",

		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "+",
						package_pending = "~",
						package_uninstalled = "x",
					},
					border = "rounded",
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",

		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"clangd",
					"pyright",
					"gopls",
					"jdtls",
                    "lemminx",
                    "ts_ls",
                    "cssls"
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			lspconfig.cssls.setup({
				capabilities = capabilities,
			})

			lspconfig.ts_ls.setup({
				capabilities = capabilities,
			})

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})

			lspconfig.clangd.setup({
				capabilities = capabilities,
			})

			lspconfig.pyright.setup({
				capabilities = capabilities,
			})

            lspconfig.lemminx.setup({
                capabilities = capabilities,
            })

			lspconfig.gopls.setup({
				capabilities = capabilities,
                on_attach = function ()
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        pattern = "*.go",
                        callback = function()
                            local params = vim.lsp.util.make_range_params()
                            params.context = {only = {"source.organizeImports"}}
                            -- buf_request_sync defaults to a 1000ms timeout. Depending on your
                            -- machine and codebase, you may want longer. Add an additional
                            -- argument after params if you find that you have to write the file
                            -- twice for changes to be saved.
                            -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
                            local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
                            for cid, res in pairs(result or {}) do
                                for _, r in pairs(res.result or {}) do
                                    if r.edit then
                                        local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                                        vim.lsp.util.apply_workspace_edit(r.edit, enc)
                                    end
                                end
                            end
                            vim.lsp.buf.format({async = false})
                        end
                    })
                end
			})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {})
			vim.keymap.set("n", "<leader>cd", vim.diagnostic.setqflist, {})
			vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>ci", vim.lsp.buf.implementation, {})
		end,
	},
	{
		"mfussenegger/nvim-jdtls",

		dependencies = {
			"mfussenegger/nvim-dap",
		},
	},
}
