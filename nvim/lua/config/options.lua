local o, opt = vim.o, vim.opt

-- leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- general
o.timeoutlen = 500
o.mouse = "a"
o.hidden = true
o.smoothscroll = true

o.scrolloff = 4
o.splitbelow = true
o.splitright = true
o.splitkeep = "screen"

o.wrap = false
o.smartindent = true
o.breakindent = true

o.undofile = true
opt.shortmess:append("WIcC")

o.completeopt = "menuone,noinsert,noselect"

-- searching
o.ignorecase = true
o.smartcase = true
o.infercase = true
o.grepformat = "%f:%l:%c:%m"
o.grepprg = "rg --vimgrep"

-- ui
o.laststatus = 3
o.cmdheight = 0
o.showcmd = false
o.showmode = false

o.conceallevel = 2
o.signcolumn = "yes:1"
o.cursorline = true
o.list = true
opt.fillchars = {
  fold = " ",
  diff = "╱",
  eob = " ",
	vert = " ",
}
opt.listchars = {
	tab = "  ",
	trail = "·",
	nbsp = "␣",
	precedes = "«",
	extends = "»",
}

-- folds
o.foldenable = true
o.foldlevel = 99
o.foldlevelstart = 99

vim.g.markdown_folding = 1

vim.filetype.add({
	extension = {
		vert = "glsl",
		frag = "glsl",
	},
	pattern = {
		[".*/waybar/config"] = "jsonc",
		[".*/mako/config"] = "dosini"
	}
})

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		}
	},
	severity_sort = true
})
