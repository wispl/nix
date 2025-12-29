return {
    {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
	    local ts = require("nvim-treesitter")
	    vim.api.nvim_create_autocmd("User", {
		group = vim.api.nvim_create_augroup("install_treesitter", { clear = true} ),
		pattern = "LazySync",
		once = true,
		callback = function()
		    ts.install({
			"bash", "c", "cmake", "cpp", "css", "glsl",
			"html", "javascript", "json", "jsonc", "lua", "markdown",
			"markdown_inline", "nix", "python", "regex", "rust", "vim",
			"yuck", "zig"
		    })
		end
	    })
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
