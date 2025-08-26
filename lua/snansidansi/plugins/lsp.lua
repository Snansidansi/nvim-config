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
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")

            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

            local lsp_formatting = function(bufnr)
                vim.lsp.buf.format({ bufnr = bufnr })
            end

            local on_attach = function(client, bufnr)
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
            end

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "clangd",
                    "pyright",
                    "gopls",
                    "jdtls",
                    "lemminx",
                    "ts_ls",
                    "cssls",
                    "eslint",
                    "tailwindcss",
                },
                handlers = {
                    -- Default Handler für alle Server
                    function(server_name)
                        lspconfig[server_name].setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                        })
                    end,
                }
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- Autoformat beim Speichern für alle LSP-Clients, die Formatierung anbieten
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*",
                callback = function()
                    vim.lsp.buf.format({
                        -- Optional: nur bestimmte Clients
                        -- filter = function(client) return client.name == "gopls" or client.name == "null-ls" end
                    })
                end,
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
