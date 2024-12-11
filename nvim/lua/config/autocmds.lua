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

-- from LazyVim, tries to render a file as quickly as possible when first
-- opening from cmdline, colors may flicker but it is better than flickering
-- from the text
vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.api.nvim_create_augroup("fast_render", { clear = true} ),
	once = true,
	callback = function(event)
		-- Skip if we already entered vim
		if vim.v.vim_did_enter == 1 then
			return
		end

		-- Try to guess the filetype (may change later on during Neovim startup)
		local ft = vim.filetype.match({ buf = event.buf })
		if ft then
			-- Add treesitter highlights and fallback to syntax
			local lang = vim.treesitter.language.get_lang(ft)
			if not (lang and pcall(vim.treesitter.start, event.buf, lang)) then
				vim.bo[event.buf].syntax = ft
			end

			-- Trigger early redraw
			vim.cmd.redraw()
		end
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
