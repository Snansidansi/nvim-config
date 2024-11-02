return {
    {
        "mfussenegger/nvim-dap",

        dependencies = {
            "mfussenegger/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
        },

        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            dapui.setup({})

            -- Setup and event listener for when the debugger is launched
            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"]=function()
                pcall(function() dapui.close() end)
            end

            -- Keymaps
            vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint)
            vim.keymap.set("n", "<leader>dc", dap.continue)
            vim.keymap.set("n", "<leader>di", dap.step_into)
            vim.keymap.set("n", "<leader>do", dap.step_over)
            vim.keymap.set("n", "<leader>dO", dap.step_out)
            vim.keymap.set("n", "<leader>dC", function()
                dap.disconnect({ terminateDebuggee = true })
            end)

            vim.keymap.set({ "n", "v" }, "<leader>dh", function() dapui.eval() end)
        end,
    },
    {
        "jay-babu/mason-nvim-dap.nvim",

        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },

        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = {
                    "javadbg",
                    "javatest",
                },
            })
        end,
    },
}
