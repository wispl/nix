
return {
	-- ui for cmdheight = 0
	{
		"folke/noice.nvim",
		dependencies = "MunifTanjim/nui.nvim",
		event = "VeryLazy",
		opts = {
			cmdline = {
				format = {
						search_down = { kind = "search", pattern = "^/", icon = "", lang = "regex" },
						search_up = { kind = "search", pattern = "^%?", icon = "", lang = "regex" }
				}
			},
			presets = {
				long_message_to_split = true,
				lsp_doc_border = true,
			},
			views = {
				cmdline_popup = {
					position = { row = 5, col = "50%" },
					size = { width = 60, height = "auto" },
					border = {
						style = "none",
						padding = { 1, 2 },
					},
					filter_options = {},
					win_options = {
						winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
					},
				},
				popupmenu = {
					relative = "editor",
					position = { row = 8, col = "50%", },
					size = { width = 60, height = 10, },
					border = {
						style = "none",
						padding = { 1, 2 },
					},
				},
			},
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			routes = {
				{
					view = "mini",
					filter = { event = "msg_showmode" },
				}
			},
		},
	},
	-- dashboard
	{
		"nvimdev/dashboard-nvim",
		lazy = false,
		opts = function()
			local logo = {
				"                                   ",
				"                                   ",
				"   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          ",
				"    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ",
				"          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     ",
				"           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ",
				"          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ",
				"   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ",
				"  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ",
				" ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ",
				" ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ ",
				"      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ",
				"       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ",
				"                                   "
			}

			local opts = {
				theme = "doom",
				config = {
					header = logo,
					center = {
						{ key = "f", action = "Telescope find_files", desc = "Find file",   },
						{ key = "n", action = "ene | startinsert",    desc = "New file",    },
						{ key = "r", action = "Telescope oldfiles",   desc = "Recent files",},
						{ key = "p", action = "Telescope marks",      desc = "Projects",    },
						{ key = "q", action = "qa",                   desc = "Quit",        }
					},
					footer = function()
						local stats = require("lazy").stats()
						local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
						return { "Loaded " .. stats.loaded .. " plugins in " .. ms .. "ms!" }
					end
				}
			}

			for _, button in ipairs(opts.config.center) do
				button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
				button.key_format = "  %s"
			end

			return opts
		end
	},
	-- git signs
	{
		"echasnovski/mini.diff",
		event = "VeryLazy",
		keys = {
			{
				"<leader>od",
				function() require("mini.diff").toggle_overlay(0) end,
				desc = "[O]ption [D]iff",
			},
		},
		opts = {
			view = {
				style = "sign",
				signs = { add = "│", change = "│", delete = "" }
			}
		},
	},
	-- icons
	{
		"echasnovski/mini.icons",
		lazy = true,
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},
	{
		"mvllow/modes.nvim",
		event = "InsertEnter",
		opts = {
			line_opacity = 0.25,
		}
	}
	-- {
	-- 	"mvllow/modes.nvim",
	-- 	event = "VeryLazy",
	-- 	opts = {
	-- 		colors = {
	-- 			copy = "#dca561",
	-- 			delete = "#c4746e",
	-- 			insert = "#949fb5",
	-- 			visual = "#957fb8",
	-- 		},
	-- 		set_signcolumn = false
	-- 	}
	-- }
}
