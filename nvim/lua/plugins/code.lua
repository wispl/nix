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
		event = "InsertEnter",
		-- build = "nix run .#build-plugin",
		opts = {
			completion = {
				menu = {
					draw = {
						treesitter = { "lsp" },
						columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
						components = {
							source_name = {
								text = function(ctx) return "  (" .. ctx.source_name .. ")" end,
							},
						}
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500,
				},
				ghost_text = { enabled = true },
			},
			snippets = {
				expand = function(snippet) require("luasnip").lsp_expand(snippet) end,
				active = function(filter)
					if filter and filter.direction then
						return require("luasnip").jumpable(filter.direction)
					end
					return require("luasnip").in_snippet()
				end,
				jump = function(direction) require("luasnip").jump(direction) end,
			},
			keymap = { preset = "enter" },
			-- TODO: change this to sources = { default = {...} } on blink.cmp 0.7.6 is used
			sources = {
				completion = {
					enabled_providers = { "lsp", "path", "luasnip", "buffer" },
				}
			},
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
