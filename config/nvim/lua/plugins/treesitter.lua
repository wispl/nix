return {
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		build = ":TSUpdate",
		event = "VeryLazy" ,
		lazy = vim.fn.argc(-1) == 0,
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		opts = {
			highlight = {
				enable = true,
				disable = { "latex" }
			},
			indent = { enable = true },
			ensure_installed = {
				"bash",
				"c",
				"cmake",
				"cpp",
				"css",
				"glsl",
				"html",
				"javascript",
				"json",
				"jsonc",
				"lua",
				"markdown",
				"markdown_inline",
				"nix",
				"python",
				"regex",
				"rust",
				"vim",
				"yuck",
				"zig"
			}
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end
	},
	-- latex
	{
		"lervag/vimtex",
		lazy = false,
		version = "v2.16",
		keys = {
			{ "<leader>lf", '<cmd>silent execute "!inkfig " . b:vimtex.root . "/figures/<cword>.svg"<cr>',  silent = true },
		},
		config = function()
			vim.g.vimtex_view_method = "sioyek"
			vim.g.vimtex_format_enabled = 1
		end,
	}
}
