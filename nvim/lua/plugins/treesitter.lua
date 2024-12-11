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
				"zig"
			}
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end
	}
}
