-- Get the Mason Registry to gain acces to downloaded binaries
local mason_registry = require("mason-registry")

local function get_jdtls()
	-- Find the JDTLS package in the Mason Registry
	local jdtls = mason_registry.get_package("jdtls")
	-- Find the full path to the directory where Mason has downloaded the JDTLS binaries
	local jdtls_path = jdtls:get_install_path()
	-- Optain the path to the jar which runs the language server
	local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
	-- Declare which operating system we are using
	local SYSTEM = "linux"
	-- Optain the path to configuration files for your specific os
	local config = jdtls_path .. "/config_" .. SYSTEM
	-- Obtain the path to the Lomboc jar
	local lombok = jdtls_path .. "/lombok.jar"
	return launcher, config, lombok
end

local function get_bundles()
	-- Find the Java Debug Adapter package in the Mason Registry
	local java_debug = mason_registry.get_package("java-debug-adapter")
	-- Optain the full path to the directory where Mason has downloaded the Java Debug Adapter binaries
	local java_debug_path = java_debug:get_install_path()
	local bundles = {
		vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", 1),
	}

	-- Find the Java Test package in the Mason Registry
	local java_test = mason_registry.get_package("java-test")
	-- Obtain the full path to the directory where Mason has downloaded the Java Test binaries
	local java_test_path = java_test:get_install_path()
	-- Add all of the Jars for running tests in debug mode to the bundles list
	vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar", 1), "\n"))
	return bundles
end

local function get_workspace()
	-- Get the home directory of your operating system
	local home = os.getenv("HOME")
	-- Declare a directory where you would like to store project information
	local workspace_path = home .. "/dev/.jdtls_workspace/"
	-- Determine the project name
	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
	-- Create the workspace directory by concatenating the designated workspace path and the project name
	local workspace_dir = workspace_path .. project_name
	return workspace_dir
end

local function java_keymaps()
	vim.cmd(
		"command! -buffer -nargs=? -complete=custom,v:lua.require('jdtls')._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
	)
	vim.cmd("command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()")
	vim.cmd("command! -buffer JdtBytecode lua require('jdtls').javap()")
	vim.cmd("command! -buffer JdtJshell lua require('jdtls').jshell()")

	-- Keymaps:
	vim.keymap.set("n", "<leader>Jo", "<Cmd> lua require('jdtls').organize_imports()<CR>")
	vim.keymap.set("n", "<leader>Jv", "<Cmd> lua require('jdtls').extract_variable()<CR>")
	vim.keymap.set("n", "<leader>Jt", "<Cmd> lua require('jdtls').test_nearest_method()<CR>")
	vim.keymap.set("n", "<leader>JT", "<Cmd> lua require('jdtls').test_class()<CR>")
	vim.keymap.set("n", "<leader>Ju", "<Cmd> JdtUpdateConfig<CR>")
end

local function setup_jdtls()
	local jdtls = require("jdtls")

	-- Get the paths to the jdtls jar, os specific config directory and lombok jar
	local launcher, os_config, lombok = get_jdtls()

	-- Get the path for the specified to hold the project information
	local workspace_dir = get_workspace()

	-- Get the bundles list with the jars to the debug adapter, and testing adapters
	local bundles = get_bundles()

	-- Determine the root directory of the project by looking for these specific markers
	local root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "settings.gradle" })

	-- Tell our JDTLS language features is is capable of
	local capabilities = {
		workspace = {
			configuration = true,
		},
		textDocument = {
			completion = {
				snippetSupport = false,
			},
		},
	}

	local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

	for k, v in pairs(lsp_capabilities) do
		capabilities[k] = v
	end

	-- Get the default extended client capabilities of the JDTLS language server
	local extendedClientCapabilities = jdtls.extendedClientCapabilities
	-- Modify one propertie called resolveAdditionalTextEditSupport and set it to true
	extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

	-- Set the command that starts the JDTLS language server jar
	local cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-javaagent:" .. lombok,
		"-jar",
		launcher,
		"-configuration",
		os_config,
		"-data",
		workspace_dir,
	}

	-- Configure settings in the JDTLS server
	local settings = {
		java = {
			-- Enable code formatting
			format = {
				enabled = true,
				-- Use the Google Style guide for code formatting
				settings = {
					profile = "GoogleStyle",
					url = vim.fn.stdpath("config") .. "/lang_servers/intellij-java-google-style.xml",
				},
			},
			-- Enable downloading archives from eclipse automatically
			eclipse = {
				downloadSource = true,
			},
			-- Enable downloading archives from maven automatically
			maven = {
				downloadSources = true,
			},
			-- Enable method signature help
			signatureHelp = {
				enabled = true,
			},
			-- Use the fernflower decompiler when using the javap command to decompile byte code back to java code
			contentProvider = {
				preferred = "fernflower",
			},
			-- Setup automatical package import organization on file save
			saveActions = {
				organizeImports = true,
			},
			-- Customize completion options
			completion = {
				-- Defines the sorting order of import statements
				favoriteStaticMembers = {
					--"org.hamcrest.MatcherAssert.assertThat",
					--"org.hamcrest.Matchers.*",
					--"org.hamcrest.CoreMatchers.*",
					"org.junit.Assert.*",
					"org.junit.jupiter.api.Assertions.*",
				},
				-- Try not to suggest imports from these packages in the code action window
				filteredTypes = {
					"com.sun.*",
					"io.micrometer.shaded.*",
					"java.awt.*",
					"jdk.*",
					"sun.*",
				},
				-- Set the order in which the language server should organize imports
				importOrder = {
					"java",
					"jakarta",
					"javax",
					"com",
					"org",
				},
			},
			source = {
				-- How many classes from a specific package should be imported before automatic imports combines themm all into a single import
				organizeImports = {
					starThreshold = 9999,
					staticThreshold = 9999,
				},
			},
			-- How should different pieces of code be generated?
			codeGeneration = {
				-- When generating toString use a json format
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
				-- When generating hashCode and equals methods use the java 7 objects method
				hashCodeEquals = {
					useJava7Objects = true,
				},
				-- When generation code use code blocks
				useBlocks = true,
			},
			-- If changes to the project will require the dev to update the projects configuration advise the dev before accepting the change
			configuration = {
				updateBuildConfiguration = "interactive",
			},
			-- enable code lens in the lsp
			refrenceCodeLens = {
				enabled = true,
			},
			-- enable inlay hints for parameters names
			inlayHints = {
				parameterNames = {
					enabled = "all",
				},
			},
		},
	}

	-- Create a table called init_options to pass the bundles with debug and testing jar, along with the extended client capablies to the start or attach function of JDTLS
	local init_options = {
		bundles = bundles,
		extendedClientCapabilities = extendedClientCapabilities,
	}

	-- Function that will be ran once the language server is attached
	local on_attach = function(_, bufnr)
		-- Map the Java specific key mappings once the server is attached
		java_keymaps()

		-- Setup the java debugadapter of the JDTLS server
		require("jdtls.dap").setup_dap()

		-- Find the main method(s) of the application so the debug adapter can successfully start up the application
		-- Sometimes this will randomly fail if language server takes to long to startup for the project, if a ClassDefNotFoundException occurs when running
		-- the debug tool, attempt to run the debug tool while in the main class of the application, or restart the neovim instance
		require("jdtls.dap").setup_dap_main_class_configs()
		-- Enable jdtls commands to be used in nvim
		require("jdtls.setup").add_commands()
		-- Refresh the codelens
		-- Code lens enables features such as code refrence counts, implemetation counts and more.
		vim.lsp.codelens.refresh()

		require("lsp_signature").on_attach({
			bind = true,
			padding = "",
			handler_opts = {
				border = "rounded",
			},
			hint_prefix = ">> ",
		}, bufnr)

		-- Setup a function that automatically runs every time a java files is saved to refesh the code lens
		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = { "*.java" },
			callback = function()
				local _, _ = pcall(vim.lsp.codelens.refresh)
			end,
		})
	end

	-- Create the configuration table for the start or attach function
	local config = {
		cmd = cmd,
		root_dir = root_dir,
		settings = settings,
		capabilities = capabilities,
		init_options = init_options,
		on_attach = on_attach,
	}

	-- Start the JDTLS server
	require("jdtls").start_or_attach(config)
end

return {
	setup_jdtls = setup_jdtls,
}
