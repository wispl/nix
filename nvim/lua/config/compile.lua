local M = {}

-- Module compilers_by_ft
--	Maps common compilers to filetype, the config should be a table containing:
--
--		compiler, which corresponds to a {compiler}.vim file in runtime
--		makeprg, (optional) to override or a set the makeprg
--
--	The compilers are called with :compiler {compiler} which sets the
--	errorformat and makeprg in the buffer. Some compilers like gcc do not set
--	the makeprg.
--
--	These are defaults/fallbacks and can be overriden.
M.compilers_by_ft = {
	c = { compiler = "gcc", makeprg = "make" },
	cpp = { compiler = "gcc", makeprg = "cmake --build /build" },
	zig = { compiler = "zig" },
	-- cargo also pulls in errorformats from rustc
	rust = { compiler = "cargo" },
}

function M.quickfixtext(opts)
	local type = {
		h = "hint: ",
		i = "info: ",
		w = "warning: ",
		e = "error: ",
	}
  if opts.quickfix == 0 then
    return nil
  end
  local qflist = vim.fn.getqflist({ id = opts.id, items = 0, title = 0, context = 0 })
  local result = {}
  for i, item in pairs(qflist.items) do
    if i >= opts.start_idx and i <= opts.end_idx then
			if item.lnum == 0 and item.col == 0 then
				table.insert(result, string.format("%s", item.text))
			else
				local text = type[item.type]
				table.insert(result, string.format("%s:%d:%d %s%s",
					vim.fn.bufname(item.bufnr),
					item.lnum,
					item.col,
					text and text or "",
					item.text
				))
			end
    end
  end
  return result
end

-- Runs makeprg and feeds the output to a quickfix list using the errorformat
-- specified by the compiler.
--
-- see M.make() for one which uses defaults specified by M.compilers_by_ft.
function M.compile(makeprg, compiler)
	-- TODO: reset the compiler after all the variables are gathered.
	if compiler then
		vim.api.nvim_command("compiler " .. compiler)
	end

	-- TODO: compiler seems to set errorformat globally as well?
	local efm = vim.o.errorformat
	local cmd = makeprg ~= "" and makeprg or vim.bo.makeprg
	if cmd then
		cmd = vim.fn.expandcmd(makeprg)
	else
		vim.notify("makeprg is empty, unable to continue!", vim.log.levels.ERROR)
		return
	end

	vim.notify("Running '" .. cmd .. "'...")

	-- Make a new qflist and open it, this allows for using :colder to get the
	-- previous compilation errors.
	vim.fn.setqflist({}, " ", { title = cmd, nr = "$", quickfixtextfunc = M.quickfixtext })
	vim.api.nvim_command("copen 10")
	-- Focus back to the current window since :copen takes focus.
	vim.api.nvim_command("wincmd p")

	-- Live update the compilation window otherwise it would just be blank.
	local collect = function(err, data)
		if data then
			vim.schedule(function()
				vim.fn.setqflist({}, "a", {
					nr = 0,
					title = cmd,
					lines = vim.split(data, "\n", { trimempty = true }),
					efm = efm,
				})
			end)
		end
	end

	local on_exit = function(obj)
		vim.notify("Compilation exited with status " .. obj.code)
		vim.schedule(function() vim.api.nvim_command("doautocmd QuickFixCmdPost") end)
	end

	vim.system(
		vim.split(cmd, " ", { trimempty = true }),
		{ stdout = collect, stderr = collect, text = true },
		on_exit
	)
end

-- Like M.compile, but this one is more similar to :make as it accounts for
-- currently defined makeprg and compiler. If those are empty, then it falls
-- back to M.compilers_by_ft.
function M.make()
	local config = M.compilers_by_ft[vim.bo.filetype]
	-- User defined values take priority
	local makeprg = vim.bo.makeprg
	local compiler = vim.b.current_compiler

	if config then
		if makeprg == "" and config.makeprg then
			makeprg = config.makeprg
		end
		-- TODO: check if makeprg can be nil as well...
		if compiler == nil then
			compiler = config.compiler
		end
	end

	if makeprg == "" then
		vim.notify("makeprg is empty and there is no fallback config for the filetype!", vim.log.levels.ERROR)
		return
	end

	M.compile(makeprg, compiler)
end

return M
