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
	-- async commmands for building and running
	{
		"tpope/vim-dispatch",
		cmd = { "Dispatch", "Make", "Start" },
		keys = {
			{ "<leader>cc", "<cmd>Make<cr>", desc = "[C]ode [C]ompile" },
			{ "<leader>rr", "<cmd>Dispatch<cr>", desc = "[R]un [R]un" },
		},
		init = function()
			vim.g.dispatch_no_maps = 1
		end
	},
	-- latex
	{
		"lervag/vimtex",
		lazy = false,
		config = function()
			vim.g.vimtex_view_method = "sioyek"
		end,
	}
}
