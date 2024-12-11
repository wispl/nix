local modes = {
	["n"] = "Normal",
	["no"] = "Operator",
	["nov"] = "Operator",
	["noV"] = "Operator",
	["no"] = "Operator",
	["niI"] = "Normal",
	["niR"] = "Normal",
	["niV"] = "Normal",
	["v"] = "Visual",
	["vs"] = "Visual",
	["V"] = "Visual",
	["Vs"] = "Visual",
	[""] = "Visual",
	["s"] = "Select",
	["s"] = "Select",
	["S"] = "Select",
	["i"] = "Insert",
	["ic"] = "Insert",
	["ix"] = "Insert",
	["R"] = "Replace",
	["Rc"] = "Replace",
	["Rv"] = "Replace",
	["Rx"] = "Replace",
	["c"] = "Command",
	["cv"] = "Command",
	["ce"] = "Command",
	["r"] = "More",
	["rm"] = "Confirm",
	["r?"] = "Next",
	["!"] = "Shell",
	["t"] = "Terminal",
	["nt"] = "Terminal",
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

	if mode == "Normal" then
    color = "%#StatusNormal#"
	elseif mode == "Insert" then
		color = "%#StatusInsert#"
	elseif mode == "Visual" then
		color = "%#StatusVisual#"
	elseif mode == "Replace" then
		color = "%#StatusReplace#"
	elseif mode == "Command" then
    color = "%#StatusCommand#"
	elseif mode == "Terminal" then
		color = "%#StatusTerminal#"
	end
	return string.format("%s %s ", color, mode)
end

local function git()
	return (vim.b.minigit_summary_string or "") .. " " .. (vim.b.minidiff_summary_string or "")
end

local function file()
	local filename = vim.fn.expand("%:t")
	if filename == "" then
		filename = "No Name"
	end
	return string.format("%s %s ", "%#Normal#", filename)
end

local function filestate()
	return string.format("%s %s %s", "%#Comment#", "%m", "%r")
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
