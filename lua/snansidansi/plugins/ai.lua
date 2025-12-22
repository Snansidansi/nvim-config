return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"j-hui/fidget.nvim",
	},

	init = function()
		require("snansidansi.utils.fidget_spinner"):init()
	end,

	opts = {
		ui = {
			events = true,
		},

		interactions = {
			chat = {
				adapter = {
					name = "gemini",
					model = "gemini-2.5-flash",
				},
			},
			inline = {
				adapter = {
					name = "gemini",
					model = "gemini-2.5-flash",
				},
			},
			cmd = {
				adapter = {
					name = "gemini",
					model = "gemini-2.5-flash",
				},
			},
		},

		adapters = {
			acp = {
				gemini_cli = function()
					return require("codecompanion.adapters").extend("gemini_cli", {
						defaults = {
							auth_method = "oauth-personal",
						},
					})
				end,
			},

			http = {
				gemini = function()
					return require("codecompanion.adapters").extend("gemini", {
						env = {
							GEMINI_API_KEY = "GEMINI-API-KEY",
						},
					})
				end,
			},
		},
	},

	config = function(_, opts)
		require("codecompanion").setup(opts)
		local map = vim.keymap.set
		map({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "AI Actions" })
		map({ "n", "v" }, "<leader>ai", "<cmd>CodeCompanion<cr>", { desc = "AI Inline Prompt" })
		map({ "n", "v" }, "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "AI Chat Toggle" })
		map("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add selection to AI Chat" })
	end,
}
