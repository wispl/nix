vim.loader.enable()

local config_path = vim.fn.stdpath("config") .. "/lua/config/"
local config = function(path) dofile(config_path .. path) end

-- initialization
config("options.lua")
config("ui.lua")
-- lazy load shada
local shada = vim.o.shada
vim.o.shada = ""
-- lazy load clipboard
local clipboard = vim.opt.clipboard
vim.opt.clipboard = ""
--
-- bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- install plugins
require("lazy").setup("plugins", {
	performance = {
		cache = { enabled = true },
		rtp = {
			disabled_plugins = {
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"rplugin",
				"zipPlugin",
				"matchit"
			},
		}
	},
})

-- from LazyVim, tries to render a file as quickly as possible when first
-- opening from cmdline, colors may flicker a little, but the text shows up
-- much faster show the overall flickering is not as jarring.
if vim.v.vim_did_enter ~= 1 and vim.fn.argc(-1) ~= 0 then
	local buf = vim.api.nvim_get_current_buf()
	-- Try to guess the filetype (may change later on during Neovim startup)
	local ft = vim.filetype.match({ buf = buf })
	if ft then
		-- Add treesitter highlights and fallback to syntax
		local lang = vim.treesitter.language.get_lang(ft)
		if not (lang and pcall(vim.treesitter.start, buf, lang)) then
			vim.bo[buf].syntax = ft
		end

		-- Trigger early redraw
		vim.cmd.redraw()
	end
end

--- source rest of configs
vim.api.nvim_create_autocmd("User", {
	group = vim.api.nvim_create_augroup("SourceConfig", { clear = true }),
	pattern = "VeryLazy",
	callback = function()
		config("keymaps.lua")
		config("autocmds.lua")

		vim.o.shada = shada
		pcall(vim.cmd.rshada, { bang = true })

		vim.opt.clipboard = clipboard
		-- TODO: Not too sure about this, going to try it out a little
		vim.cmd.packadd("matchit")
	end
})
vim.cmd.colorscheme("kanagawa")
