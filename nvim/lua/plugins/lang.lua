return {
	-- project configuration
	{
		"tpope/vim-projectionist",
		event = "BufReadPost",
		keys = {
			{ "<leader>a", "<cmd>A<cr>", desc = "[A]lt file" }
		},
		init = function()
			vim.g.projectionist_heuristics = {
				-- make and cmake
				["build/Makefile"] = {
					["*"] = {
						make = "make -C {project}/build/", dispatch = "./build/{project|basename}"
					}
				},
				-- rust
				["Cargo.toml"] = {
					["*"] = { make = "cargo check", dispatch = "cargo run" }
				},
				-- html
				["index.html"] = {
					["*"] = { start = "xdg-open index.html" }
				},
				-- Headers and source files for cpp and c
				["src/*.c|*.c|src/*.cpp|*.cpp"] = {
					["*.cpp"] = {
						alternate = { "{}.h", "{}.hpp" }
					},
					["*.c"] = {
						alternate = "{}.h"
					},
					["*.h"]   = {
						alternate = { "{}.c", "{}.cpp" }
					},
					["*.hpp"]   = {
						alternate = "{}.cpp"
					}
				},	
			}
		end,
	},
	-- latex
	{
		"lervag/vimtex",
		lazy = false,
		config = function()
			vim.g.vimtex_view_method = "sioyek"
			vim.g.vimtex_format_enabled = 1
		end,
	}
}
