return {
	cmd = { "lua_language_server" },
	filetypes = { "lua" },
	root_pattern = { ".luarc.json", ".git" },
	settings = {
		Lua = {
			workspace = { checkThirdParty = false },
		},
	}
}
