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
				"matchit",
				"netrwPlugin"
			},
		}
	},
})

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
