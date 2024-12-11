-- LSP inspired by VonHeikemen's and faimu's configs
local augroup = vim.api.nvim_create_augroup("lspconfig", {})
local lsp = vim.lsp

lsp.handlers["textDocument/hover"] = lsp.with(
  lsp.handlers.hover,
  { border = "rounded" }
)

lsp.handlers["textDocument/signatureHelp"] = lsp.with(
    lsp.handlers.signature_help,
    { border = "rounded" }
)

-- keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP keymaps",
	group = augroup,
	callback = function(args)
		local opts = { buffer = args.buf }
		local client = lsp.get_client_by_id(args.data.client_id)

		vim.keymap.set("n", "gd", lsp.buf.definition, opts)
		vim.keymap.set("n", "gD", lsp.buf.declaration, opts)
		vim.keymap.set("n", "gi", lsp.buf.implementation, opts)
		vim.keymap.set("n", "gr", lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>D", lsp.buf.type_definition, opts)

		vim.keymap.set("n", "K", lsp.buf.hover, opts)
		vim.keymap.set("n", "<space>ca", lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>cr", lsp.buf.rename, opts)
		if client.supports_method("textDocument/formatting") then
			vim.keymap.set({ "n", "v" }, "<leader>cf", function() lsp.buf.format() end, opts)
		end
	end,
})

local function make_capabilities(capabilities)
	return vim.tbl_extend(
		"force",
		lsp.protocol.make_client_capabilities(),
		require("cmp_nvim_lsp").default_capabilities(),
		capabilities or {}
	)
end

-- server configurations
local function setup_server(config)
	-- This is so cool
	vim.validate({
		name = { config.name, "string" },
		cmd = { config.cmd, "table" },
		filetypes = { config.filetypes, { "string", "table" } },
		root_pattern = { config.root_pattern, { "string", "table" } },
		capabilities = { config.capabilities, "table", true },
	})
	config.capabilities = make_capabilities(config.capabilities)
	config.root_dir = vim.fs.root(0, config.root_pattern)

	local filetypes = config.filetypes
	if type(filetypes) == string then
		filetypes = { filetypes }
	end
	config.filetypes = nil
	config.root_pattern = nil

	vim.api.nvim_create_autocmd("FileType", {
		pattern = filetypes,
		group = augroup,
		callback = function(opts) lsp.start(config) end
	})
end

setup_server({
	name = "clangd",
	filetypes = { "c", "cpp" },
	cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
	root_pattern = { "compile_commands.json", ".git" },
})

setup_server({
	name = "lua_language_server",
	filetypes = "lua",
	cmd = { "lua_language_server" },
	root_pattern = ".git",
	settings = {
		Lua = {
			workspace = { checkThirdParty = false, },
		},
	}
})
