return {
    {
        "williamboman/mason.nvim",

        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "+",
                        package_pending = "~",
                        package_uninstalled = "x"
                    }
                }
            })
        end
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
                }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({
                capabilities = capabilities
            })
            lspconfig.clangd.setup({
                capabilities = capabilities
            })
            lspconfig.pyright.setup({
                capabilities = capabilities
            })
            lspconfig.gopls.setup({
                capabilities = capabilities
            })
            lspconfig.jdtls.setup({
                capabilities = capabilities
            })

            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
            vim.keymap.set('n', "gd", vim.lsp.buf.definition, {})
            vim.keymap.set({ 'n', 'v' }, "<leader>ca", vim.lsp.buf.code_action, {})
            vim.keymap.set('n', "<leader>r", vim.lsp.buf.rename, {})
            vim.keymap.set('n', "<leader>cd", vim.diagnostic.setqflist, {})
            vim.keymap.set('n', "<leader>cr", vim.lsp.buf.references, {})
            vim.keymap.set('n', "<leader>ci", vim.lsp.buf.implementation, {})
        end
    },
    {
        "mfussenegger/nvim-jdtls",

        dependencies = {
            "mfussenegger/nvim-dap",
        }
    },
}
