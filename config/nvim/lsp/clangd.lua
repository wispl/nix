return {
	cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
	filetypes = { "c", "cpp" },
	root_markers = { "compile_commands.json", ".git" },
}
