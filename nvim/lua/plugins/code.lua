return {
	-- snippets
	{
		"L3MON4D3/LuaSnip",
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
		"hrsh7th/nvim-cmp",
		version = false,
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
		},
		opts = function()
			local cmp = require("cmp")
			return {
				window = {
					completion = {
						winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
					}
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				formatting = {
					format = function(entry, vim_item)
						vim_item.kind = string.format("     (%s) ", vim_item.kind)
						return vim_item
					end,
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "path" },
					{ name = "buffer" },
				}),
				experimental = { ghost_text = true }
			}
		end,
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
