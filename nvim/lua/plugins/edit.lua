return {
	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		version = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				config = function()
					require("telescope").load_extension("fzf")
				end
			}
		},
		keys = {
			{ "<leader>f", "<cmd>Telescope find_files<cr>" },
			{ "<leader>b", "<cmd>Telescope buffers sort_mru=true<cr>" },
			{ "<leader>g", "<cmd>Telescope live_grep<cr>" },
			{ "<leader>/", "<cmd>Telescope grep_string<cr>" },
			{ "<leader>;", "<cmd>Telescope command_history<cr>" },
			{ "<leader>m", "<cmd>Telescope marks mark_type=global<cr>" },
		},
		opts = {
			defaults = {
				prompt_prefix = " ",
				layout_strategy = "flex",
				selection_caret = "  ",
				entry_prefix = "  ",
				dynamic_preview_title = true,
				results_title = "",
				sorting_strategy = "ascending",
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.55
					},
					width = 0.80,
					height = 0.85
				}
			}
		}
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
	}
}
