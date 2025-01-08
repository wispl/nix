return {
	-- fuzzy finder
	{
		"ibhagwan/fzf-lua",
		cmd = "FzfLua",
		keys = {
			{ "<leader>f", "<cmd>FzfLua files<cr>" },
			{ "<leader>b", "<cmd>FzfLua buffers sort_mru=true<cr>" },
			{ "<leader>g", "<cmd>FzfLua live_grep<cr>" },
			{ "<leader>/", "<cmd>FzfLua grep_cWORD<cr>" },
			{ "<leader>;", "<cmd>FzfLua command_history<cr>" },
			{ "<leader>m", "<cmd>FzfLua marks" },
		},
		opts = {
      "default-title",
			winopts = {
				row = 1,
				col = 1,
				height = 0.60,
				border = "empty",
				width = 1.00,
				preview = {
					scrollbar = false,
					border = "empty",
					layout = "horizontal",
				}
			},
			hls = {
				border = "PmenuSbar",
				title = "PmenuSel",
				preview_border = "PmenuSbar",
				preview_normal = "PmenuSbar",
				preview_title = "PmenuSel",
				scrollfloat_e = "",
				scrollfloat_f = "PmenuSel",
			},
			fzf_colors = {
				["gutter"] = { "bg", "PmenuSbar" },
				["bg"] = { "bg", "PmenuSbar" },
			}
		},
	},
	-- surround
	{
		"echasnovski/mini.surround",
		keys = {
			{ "ys", desc = "Add surrounding" },
			{ "ds", desc = "Delete surrounding" },
			{ "cs", desc = "Replace surrounding" },
			{ "S",
				[[:<C-u>lua MiniSurround.add('visual')<CR>]],
				desc = "Add surrounding (visual)",
				mode = "x",
				silent = true
			},
			{ "yss", "ys_", desc = "Add surrounding to line", remap = true },
		},
		config = function()
			require("mini.surround").setup({
				mappings = {
					add = "ys",
					delete = "ds",
					find = "",
					find_left = "",
					highlight = "",
					replace = "cs",
					update_n_lines = "",
				}
			})
			vim.keymap.del("x", "ys")
		end,
	},
	-- text objects
	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		opts = {
			custom_textobjects = {
				t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
				d = { "%f[%d]%d+" }, -- digits
				g = function()
					local from = { line = 1, col = 1 }
					local to = {
						line = vim.fn.line('$'),
						col = math.max(vim.fn.getline('$'):len(), 1)
					}
					return { from = from, to = to }
				end
			},
		}
	},
	-- search and replace
	{
		"MagicDuck/grug-far.nvim",
		cmd = "GrugFar",
		keys = {
			{
				"<leader>s",
				function()
					require("grug-far").open({ prefills = {
						search = vim.fn.expand("<cword>"),
						paths = vim.fn.expand("%")
					} })
				end,
				mode = { "n", "v" },
				desc = "Search and Replace",
			},
		},
		opts = {},
	},
	{
		"rgroli/other.nvim",
		keys = {
			{ "<leader>a", "<cmd>Other<cr>", desc = "[A]lt file" }
		},
		config = function()
			require("other-nvim").setup({
				mappings = {
					"c",
					"rust",
					{
						-- context = "C header",
						pattern = "(.*).cpp$",
						target = "%1.h",
					},
					{
						-- context = "C source file",
						pattern = "(.*).h$",
						target = "%1.cpp",
					},
				}
			})
		end
	},
}
