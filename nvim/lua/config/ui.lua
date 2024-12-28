local modes = {
	["n"] = "NO",
	["niI"] = "NO",
	["niR"] = "NO",
	["niV"] = "NO",
	["no"] = "**",
	["nov"] = "**",
	["noV"] = "**",
	["no"] = "**",
	["v"] = "VIS",
	["vs"] = "VIS",
	["V"] = "VIS",
	["Vs"] = "VIS",
	[""] = "VIS",
	["s"] = "SEL",
	["s"] = "SEL",
	["S"] = "SEL",
	["i"] = "INS",
	["ic"] = "INS",
	["ix"] = "INS",
	["R"] = "RE",
	["Rc"] = "RE",
	["Rv"] = "RE",
	["Rx"] = "RE",
	["c"] = "EX",
	["cv"] = "EX",
	["ce"] = "EX",
	["r"] = "MORE",
	["rm"] = "CONFIRM",
	["r?"] = "NEXT",
	["!"] = "SHELL",
	["t"] = "TERM",
	["nt"] = "TERM",
	["null"] = "??"
}

-- This should work for most colorschemes
local function set_tabsep_hl()
		-- setup highlights for the separators
		local TabLine_bg = vim.api.nvim_get_hl(0, { name = "TabLine" }).bg
		local TabLineSel_bg = vim.api.nvim_get_hl(0, { name = "TabLineSel" }).bg
		local TabLineFill_bg = vim.api.nvim_get_hl(0, { name = "TabLineFill" }).bg
		vim.api.nvim_set_hl(0, "TabSep", { fg = TabLine_bg, bg = TabLineFill_bg })
		vim.api.nvim_set_hl(0, "TabSelSep", { fg = TabLineSel_bg, bg = TabLineFill_bg })
end

local function mode()
	local mode = modes[vim.api.nvim_get_mode().mode] or "??"
	local color = "%#Normal#"

	if mode == "NO" then
    color = "%#StatusNormal#"
	elseif mode == "INS" then
		color = "%#StatusInsert#"
	elseif mode == "VIS" then
		color = "%#StatusVisual#"
	elseif mode == "RE" then
		color = "%#StatusReplace#"
	elseif mode == "EX" then
    color = "%#StatusCommand#"
	elseif mode == "TERM" then
		color = "%#StatusTerminal#"
	else
    color = "%#StatusNormal#"
	end
	return string.format("%s %s ", color, mode)
end

local function git()
	if vim.b.minigit_summary and vim.b.minigit_summary.head_name  then
		return string.format("(#%s)", vim.b.minigit_summary.head_name)
	end
	return ""
end

local function gitdiff()
	local str = " "
	local summary = vim.b.minidiff_summary
	if summary == nil then return "" end
	if summary.add > 0 then str = str .. "%#GitSignsAdd#" .. '+' .. summary.add .. ' ' end
	if summary.change > 0 then str = str .. "%#GitSignsChange#" .. '~' .. summary.change  .. ' 'end
	if summary.delete > 0 then str = str .. "%#GitSignsDelete#" .. '-' .. summary.delete .. ' ' end
	return str
end

local function file()
	local filename = vim.fn.expand("%:t")
	if filename == "" then
		filename = "No Name"
	end
	return string.format("%s %s", "%#Normal#", filename)
end

local function filestate()
	return string.format("%s %s", "%#Comment#", "%m")
end

local function lsp()
	local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
	local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })

	return string.format(" %s%s %s%s ",
		"%#DiagnosticError#",
		errors,
		"%#DiagnosticWarn#",
		warnings)
end

local function filetype()
	return string.format("%s %s ", "%#NormalNC#", vim.bo.filetype)
end

local function filepos()
	return string.format("%s %s:%s ", "%#ColorColumn#", "%l", "%c")
end

-- inspired by nanozuki/tabby.nvim
function _G.custom_tabline()
	local tabs = "%#TabLine# Tabs: %#TabSep#"
	local curr = vim.fn.tabpagenr()

	for i = 1, vim.fn.tabpagenr("$") do
		local winnum = vim.fn.tabpagewinnr(i)
		local buflist = vim.fn.tabpagebuflist(i)
		local bufname = vim.fn.bufname(buflist[winnum])
		local sep_hl = (i == curr and "%#TabSelSep#" or "%#TabSep#")
		local buf_hl = (i == curr and "%#TabLineSel#" or "%#TabLine#")
		local file = vim.fn.fnamemodify(bufname, ":t")
		if file == "" then
			file = "[No Name]"
		end

		tabs = string.format("%s%s%s %s %s", tabs, sep_hl, buf_hl, file, sep_hl)
	end

	return tabs .. "%= %#TabSep#%#TabLine#" .. string.rep(" ", 10)
end

function _G.custom_statusline()
	return table.concat({
		mode(),
		file(),
		filestate(),
		git(),
		gitdiff(),
		"%=",
		lsp(),
		filetype(),
		filepos()
	})
end

vim.api.nvim_create_autocmd("Colorscheme", {
	group = vim.api.nvim_create_augroup("TabLineSep", {}),
	desc = "Refresh TabLine Separator colors on colorscheme change",
	callback = function(opts) set_tabsep_hl() end
})

set_tabsep_hl()
vim.o.statusline = "%!v:lua.custom_statusline()"
vim.o.tabline = "%!v:lua.custom_tabline()"
