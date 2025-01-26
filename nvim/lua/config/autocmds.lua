vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("set_treesitter", { clear = true} ),
	callback = function(args)
		-- if not pcall(vim.treesitter.start, args.buf) then
		-- 	return
		-- end
		--
		if vim.api.nvim_buf_line_count(args.buf) < 40000 then
			vim.api.nvim_buf_call(args.buf, function()
				vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.wo[0][0].foldmethod = "expr"
			end)
		end
	end,
})

-- start in insert mode when entering a terminal
vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("terminal_insert", { clear = true} ),
	pattern = "term://*",
	callback = function()
		vim.cmd.startinsert()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("close_with_q", { clear = true} ),
	pattern = {
		"help",
		"notify",
		"qf",
		"checkhealth",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", {
			buffer = event.buf,
			silent = true,
			desc = "Quit buffer",
		})
	end,
})

-- quit if the last windows are quickfix or terminal windows
vim.api.nvim_create_autocmd("QuitPre", {
	group = vim.api.nvim_create_augroup("autoquit", { clear = true} ),
  callback = function()
    local invalid_win = {}
    local wins = vim.api.nvim_list_wins()
		local count = #wins
    for i, w in ipairs(wins) do
      local buf = vim.api.nvim_win_get_buf(w)
			local bufname = vim.api.nvim_buf_get_name(buf)
			local ft = vim.bo[buf].filetype
			if ft == "noice" then
				count = count - 1
			end
      if ft == "qf" or bufname:find("term://", 1, true) == 1 then
        table.insert(invalid_win, w)
      end
    end
    if #invalid_win == count - 1 then
      for _, w in ipairs(invalid_win) do vim.api.nvim_win_close(w, true) end
    end
  end
})

-- From LazyVim, check if file has to be reloaded
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = vim.api.nvim_create_augroup("reload_file", { clear = true} ),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("wrap_spell", { clear = true} ),
  pattern = { "text", "plaintex", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
  end,
})

-- Good enough
local root_names = { "main.tex", ".git", "Makefile" }
local root_cache = {}

vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("auto_root", {}),
	callback = function()
		local path = vim.api.nvim_buf_get_name(0)
		if path == "" then return end
		path = vim.fs.dirname(path)

		local root = root_cache[path]
		if root == nil then
			local root_file = vim.fs.find(root_names, { path = path, upward = true })[1]
			if root_file == nil then return end
			root = vim.fs.dirname(root_file)
			root_cache[path] = root
		end

		vim.fn.chdir(root)
	end
})
