return {
	-- snippets
	{
		"L3MON4D3/LuaSnip",
		version = "*",
		event = "InsertEnter",
		keys = {
			{ "<tab>",
				function()
					return require("luasnip").expand_or_jumpable()
						and "<Plug>luasnip-expand-or-jump"
						or "<tab>"
				end,
				expr = true, silent = true, mode = "i",
			},
			{ "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
			{ "<S-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
			{ "<C-e>",
				function() return require("luasnip").change_choice(1) end,
				silent = true, mode = { "i", "s" },
			}
		},
		config = function()
			require("luasnip.loaders.from_lua").lazy_load({ paths = "./lua/snippets/" })
			ls = require("luasnip")
			ls.filetype_extend("glsl", { "c" })
			ls.filetype_extend("cpp",  { "c" })
			ls.setup({
				enable_autosnippets = true,
				region_check_events = { "InsertEnter" },
				delete_check_events = "TextChanged, InsertEnter",
			})
		end
	},
	-- autocompletion
	{
		"saghen/blink.cmp",
		version = "*",
		event = "VeryLazy",
		-- build = "nix run .#build-plugin",
		dependencies = {
			  -- With the dev option, you can easily switch between the local and installed version of a plugin
			-- { "wispl/blink-src", dev = true },
		},
		opts = {
			completion = {
				menu = {
					border = "solid",
					draw = {
						treesitter = { "lsp" },
						gap = 3,
						columns = { { "label", "label_description", gap = 2 }, { "kind", "kind_icon", gap = 1 } },
					},
				},
				documentation = {
					window = { border = "solid" },
					auto_show = true,
					auto_show_delay_ms = 500,
				},
				ghost_text = { enabled = true },
			},
			keymap = { preset = "enter" },
			snippets = { preset = "luasnip" },
			cmdline = { enabled = false },
			sources = { default = { "lsp", "path", "snippets", "buffer" } },
		}
	},
	-- git
	{
		"echasnovski/mini-git",
		main = "mini.git",
		event = "VeryLazy",
		opts = {},
	},
	-- commentstring
	{
		"folke/ts-comments.nvim",
		event = "VeryLazy",
		opts = {},
	},
	-- linting
	{
		"mfussenegger/nvim-lint",
		keys = {
			{ "<leader>cl", function() require("lint").try_lint() end, desc = "[C]ode [L]int" },
		},
		config = function()
			require("lint").linters_by_ft = {
				sh = { "shellcheck" },
				c = { "clangtidy" },
				cpp = { "clangtidy" },
				rust = { "clippy" }
			}
			local clippy = require('lint').linters.clippy
			table.insert(clippy.args, "--")
			table.insert(clippy.args, "-W")
			table.insert(clippy.args, "clippy::pedantic")
		end
	},
}
