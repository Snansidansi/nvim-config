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
                            GEMINI_API_KEY = "GEMINI_API_KEY",
                        },
                    })
                end,
            },
        },
    },

    config = function(_, opts)
        require("codecompanion").setup(opts)
        vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "AI Actions" })
        vim.keymap.set({ "n", "v" }, "<leader>ai", "<cmd>CodeCompanion<cr>", { desc = "AI Inline Prompt" })
        vim.keymap.set({ "n", "v" }, "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "AI Chat Toggle" })
        vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add selection to AI Chat" })

        vim.keymap.set("n", "<leader>Ai", function()
            local current_line = vim.api.nvim_get_current_line()

            -- Wenn die Zeile NICHT leer ist (enthält sichtbare Zeichen)
            if current_line:match("%S") then
                vim.cmd("normal! o") -- Erstelle neue Zeile darunter
                vim.cmd("stopinsert") -- Verlasse sofort den Insert-Mode wieder
            end

            -- 2. Die (jetzt leere oder aktuelle) Zeile im Visual-Line-Mode markieren
            vim.cmd("normal! V")

            local cmd = ":CodeCompanion Gib mir nur den code. "
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, false, true), "n", false)
        end, { desc = "Generate Code in new line" })
    end,
}
