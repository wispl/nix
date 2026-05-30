vim.loader.enable()

-- local config_path = vim.fn.stdpath("config") .. "/lua/config/"
local config_path = "./lua/config/"
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
-- install plugins
config("plugins.lua")
--- source rest of configs
local misc = require('mini.misc')
local later = function(f) misc.safely('later', f) end
later(function()
    config("keymaps.lua")
    config("autocmds.lua")

    vim.o.shada = shada
    pcall(vim.cmd.rshada, { bang = true })

    vim.opt.clipboard = clipboard
    vim.cmd.packadd("matchit")
end)
