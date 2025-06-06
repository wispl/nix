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
o.foldcolumn = "1"
opt.fillchars = {
  fold = " ",
	foldclose = "",
	foldopen = "",
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
})

vim.diagnostic.handlers.loclist = {
	show = function(_, _, _, opts)
		local winid = vim.api.nvim_get_current_win()
		vim.diagnostic.setloclist({ open = false })
		vim.api.nvim_set_current_win(winid)
	end
}

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

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 20
vim.g.termdebug_wide = 1
vim.g.termdebug_variables_window = 1
