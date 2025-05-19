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
	if summary.add and summary.add > 0 then
		str = str .. "%#GitSignsAdd#" .. "+" .. summary.add .. " "
	end
	if summary.change and summary.change > 0 then 
		str = str .. "%#GitSignsChange#" .. "~" .. summary.change  .. " "
	end
	if summary.delete and summary.delete > 0 then
		str = str .. "%#GitSignsDelete#" .. "-" .. summary.delete .. " "
	end
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

	return string.format(" %s%s %s%s",
		"%#DiagnosticError#",
		errors,
		"%#DiagnosticWarn#",
		warnings)
end

local function filetype()
	return string.format("%s %s", "%#NormalNC#", vim.bo.filetype)
end

local function filepos()
	return string.format("%s %s:%s ", "%#Normal#", "%l", "%c")
end

function _G.tabline()
	local icons = require("mini.icons")
	local tabs = ""
	local curr = vim.fn.tabpagenr()

	for i = 1, vim.fn.tabpagenr("$") do
		local winnum = vim.fn.tabpagewinnr(i)
		local buflist = vim.fn.tabpagebuflist(i)

		local bufname = vim.fn.bufname(buflist[winnum])
		local bufname = vim.fn.fnamemodify(bufname, ":t")
		if bufname == "" then
			bufname = "No Name"
		end

		local buf_hl = (i == curr and "%#Normal#" or "%#NonText#")
		local icon, _, _ = icons.get("file", bufname)

		tabs = string.format("%s %s %s %s ", tabs, buf_hl, icon, bufname)
	end
	return "%#Normal#" .. tabs .. "%#Normal#"
end

function _G.statusline()
	return table.concat({
		"%#Statusline#",
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

vim.o.statusline = "%!v:lua.statusline()"
vim.o.tabline = "%!v:lua.tabline()"
