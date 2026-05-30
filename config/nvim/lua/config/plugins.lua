vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

local misc = require('mini.misc')
local now = function(f) misc.safely('now', f) end
local later = function(f) misc.safely('later', f) end
local on_event = function(ev, f) misc.safely('event:' .. ev, f) end
local on_filetype = function(ft, f) misc.safely('filetype:' .. ft, f) end
local now_if_args = vim.fn.argc(-1) > 0 and now or later

-- Disable builtin plugins
now(function()
    vim.g.loaded_gzip = 1
    vim.g.loaded_zip = 1
    vim.g.loaded_zipPlugin = 1
    vim.g.loaded_tar = 1
    vim.g.loaded_tarPlugin = 1

    vim.g.loaded_getscript = 1
    vim.g.loaded_getscriptPlugin = 1
    vim.g.loaded_vimball = 1
    vim.g.loaded_vimballPlugin = 1
    vim.g.loaded_2html_plugin = 1

    vim.g.loaded_matchit = 1
    -- vim.g.loaded_matchparen = 1
    vim.g.loaded_logiPat = 1
    vim.g.loaded_rrhelper = 1

    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.g.loaded_netrwSettings = 1
    vim.g.loaded_netrwFileHandlers = 1
end)

-- Helper Libraries
later(function() require('mini.extra').setup() end)
later(function()
    require('mini.icons').setup()
    later(MiniIcons.mock_nvim_web_devicons)
end)

-- == Editor ==
-- Editor stuff, or the stuff that allows to do stuff slower than the average
--
-- mini.ai: custom textobjects
-- mini.surround: you will be surrounded!
-- mini.diff: git signs in the gutter
-- blink.cmp: completions faster than you can blink
-- mini.pick: finders pickers
later(function()
  require('mini.ai').setup({
      search_method = 'cover',
      custom_textobjects = {
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          b = MiniExtra.gen_ai_spec.buffer()
	  -- f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
      },
  })
end)
later(function()
    require('mini.surround').setup({
	search_method = 'cover_or_next',
	mappings = {
	    add = 'ys',
	    delete = 'ds',
	    find = '',
	    find_left = '',
	    highlight = '',
	    replace = 'cs',
	},
    })
    vim.keymap.del('x', 'ys')
    vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
    vim.keymap.set('n', 'yss', 'ys_', { remap = true })
end)
later(function()
    require('mini.diff').setup({
	view = {
	    style = "sign",
	    signs = { add = "│", change = "│", delete = "" }
	}
    })
end)
later(function()
    vim.pack.add({
	'https://github.com/saghen/blink.lib',
	'https://github.com/saghen/blink.cmp'
    })

    local cmp = require('blink.cmp')
    cmp.build():pwait()
    cmp.setup({
	completion = {

	    menu = {
		border = "solid",
		draw = {
		    treesitter = { "lsp" },
		    gap = 3,
		    columns = { { "label", "label_description", gap = 2 }, { "kind", "kind_icon", gap = 1 } },
		},
	    },
	    documentation = {
		window = { border = "solid" },
		auto_show = true,
		auto_show_delay_ms = 500,
	    },
	    ghost_text = { enabled = true },
	},
	keymap = { preset = "enter" },
	snippets = { preset = "luasnip" },
	cmdline = { enabled = false },
	sources = { default = { "lsp", "path", "snippets", "buffer" } },
    })
end)
on_event('InsertEnter', function()
    vim.pack.add({ 'https://github.com/L3MON4D3/LuaSnip' })

    local ls = require("luasnip")
    local types = require("luasnip.util.types")
    ls.filetype_extend("glsl", { "c" })
    ls.filetype_extend("cpp",  { "c" })
    ls.setup({
	keep_roots = true,
	link_roots = true,
	link_children = true,
	exit_roots = false,
	enable_autosnippets = true,
	update_events = {"InsertLeave"},
	region_check_events = { "InsertLeave" },
	delete_check_events = "TextChanged, InsertEnter",
	ext_opts = {
	    [types.choiceNode] = {
		active = {
		    virt_text = {{"●", "Identifier"}},
		    priority = 0
		},
	    },
	},
	snip_env = {
	    parse_snip = function(...)
		local snip = ls.parser.parse_snippet(...)
		table.insert(getfenv(2).ls_file_snippets, snip)
	    end,
	    parse_auto = function(...)
		local snip = ls.parser.parse_snippet(...)
		table.insert(getfenv(2).ls_file_autosnippets, snip)
	    end,
	    add_snip = function(...)
		local snip = ls.s(...)
		table.insert(getfenv(2).ls_file_snippets, snip)
	    end,
	    add_auto = function(...)
		local snip = ls.s(...)
		table.insert(getfenv(2).ls_file_autosnippets, snip)
	    end,
	    add_post = function(...)
		local postfix = require("luasnip.extras.postfix").postfix
		local snip = postfix(...)
		table.insert(getfenv(2).ls_file_autosnippets, snip)
	    end
	}
    })
    require("luasnip.loaders.from_lua").lazy_load({ paths = "./lua/snippets/" })
end)
later(function()
    require('mini.pick').setup({
	window = {
	    config = {
		border = 'solid',
		width = vim.o.columns,
		height = math.floor(0.42 * vim.o.lines)
	    }
	}
    })
end)

-- == Colorscheme
-- Without color, we are merely a void
--
-- kanagawa.nvim: no explanation needed :)
now(function()
    vim.pack.add({ 'https://github.com/rebelot/kanagawa.nvim' })
    require('kanagawa').setup({
	transparent = true,
	colors = {
	    theme = {
		all = {
		    ui = { bg_gutter = "none" }
		}
	    }
	},
	background = { dark = "dragon", light = "lotus" },
	overrides = function(colors)
	    local theme = colors.theme
	    return {
		NormalFloat = { bg = theme.ui.bg_dim },
		FloatBorder = { bg = theme.ui.bg_dim },
		WinSeparator = { fg = theme.ui.bg_p2 },
		FoldColumn = { fg = theme.ui.bg_p1 },

		Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_m1 },
		PmenuSel = { fg = "none", bg = theme.ui.bg_p2 },
		PmenuSbar = { bg = theme.ui.bg_m1 },
		PmenuThumb = { bg = theme.ui.bg_m1 },
		PmenuExtra = { bg = theme.ui.bg_m1 },
		BlinkCmpMenuBorder = { link = "Pmenu" },
		BlinkCmpDoc = { bg = theme.ui.bg_p1 },
		BlinkCmpDocSeparator = { bg = theme.ui.bg_p1 },
		BlinkCmpDocBorder = { bg = theme.ui.bg_p1 },

		StatusLine = { bg = "none" },

		StatusNormal = { bg = theme.syn.fun, fg = theme.ui.bg_m3 },
		StatusInsert = { bg = theme.diag.ok, fg = theme.ui.bg },
		StatusVisual = { bg = theme.syn.keyword, fg = theme.ui.bg },
		StatusReplace = { bg = theme.syn.constant, fg = theme.ui.bg },
		StatusCommand = { bg = theme.syn.operator, fg = theme.ui.bg },
		StatusTerminal = { bg = theme.syn.fun, fg = theme.ui.bg_m3 },

		MiniStarterHeader = { fg = theme.syn.comment },

		ModesInsert = { bg = colors.palette.oniViolet },
		ModesVisual = { bg = colors.palette.dragonBlue },
		ModesDelete = { bg = colors.palette.dragonRed },
		ModesCopy   = { bg = colors.palette.dragonGreen },
	    }
	end
    })
    vim.cmd.colorscheme("kanagawa")
end)

-- == Builtin
-- Self-explanatory, builtin plugins of neovim 
--
-- diagnostics: prettier diagnostics for lsp and other stuff
later(function()
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
end)

-- == Languages
-- Configures settings for individual languages
--
-- treesitter: sitting on trees
-- vimtex: the venerable latex plugin for vim
now_if_args(function()
  vim.pack.add({
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  })

  -- local languages = {
  --     "bash", "c", "cmake", "cpp", "css", "glsl",
  --     "html", "javascript", "json", "jsonc", "lua", "markdown",
  --     "markdown_inline", "nix", "python", "regex", "rust", "vim",
  --     "yuck", "zig"
  -- }
  -- local isnt_installed = function(lang)
  --   return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0
  -- end
  -- local to_install = vim.tbl_filter(isnt_installed, languages)
  -- if #to_install > 0 then require('nvim-treesitter').install(to_install) end
end)
now(function()
    vim.pack.add({ 'https://github.com/lervag/vimtex' })
    vim.g.vimtex_view_method = "sioyek"
    vim.g.vimtex_format_enabled = 1
end)

-- == Utilities
-- Nice QOL plugins, not strictly necessary, but fun
--
-- mini.git: plugin to git good at git
-- nvim-lint: remove all the lint in your code
-- modes.nvim: colorful cursorline highlights
-- dashboard.nvim: dashboard, a dashing board
-- mini.starter: dashboard, a dashing board
-- nvim-tree: treeview on the side for emergency purposes
later(function() require('mini.git').setup() end)
later(function()
    vim.pack.add({ 'https://github.com/mfussenegger/nvim-lint' })
    local lint = require("lint")
    lint.linters_by_ft = {
	sh = { "shellcheck" },
	c = { "clangtidy" },
	cpp = { "clangtidy" },
	rust = { "clippy" },
	node = { "eslint" }
    }

    local clippy = lint.linters.clippy
    table.insert(clippy.args, "--")
    table.insert(clippy.args, "-W")
    table.insert(clippy.args, "clippy::pedantic")
end)
on_event('InsertEnter', function()
    vim.pack.add({ 'https://github.com/mvllow/modes.nvim' })
    require('modes').setup({ line_opacity = 0.25 })
end)
now(function()
    local logo = [[
  ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          
   ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       
         ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     
          ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    
         ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   
  ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  
 ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   
⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  
⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ 
     ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     
      ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     
    ]]
    local starter = require('mini.starter')
    starter.setup({
	evaluate_single = true,
	items = {
	    starter.sections.builtin_actions(),
	    starter.sections.pick(),
	    -- starter.sections.recent_files(3, false),
	    -- starter.sections.recent_files(3, true),
	},
	header = logo,
	footer = "Gabagool time",
	content_hooks = {
	    starter.gen_hook.adding_bullet(),
	    starter.gen_hook.indexing('all', { 'Builtin actions' }),
	    starter.gen_hook.aligning('center', 'center'),
	},
    })
end)
later(function()
	  vim.pack.add({ 'https://github.com/nvim-tree/nvim-tree.lua' })
	  require('nvim-tree').setup({
	      view = { width = 25 },
	      git = { enable = false },
	      renderer = {
		  root_folder_label = false,
		  indent_markers = { enable = false }
	      }
	  })
end)
-- search and replace, not sure if I actually want this
-- later(function()
--     vim.pack.add({ 'https://github.com/MagicDuck/grug-far.nvim' })
--     keys = {
-- 	{
-- 	    "<leader>s",
-- 	    function()
-- 		require("grug-far").open({ prefills = {
-- 		    search = vim.fn.expand("<cword>"),
-- 		    paths = vim.fn.expand("%")
-- 		} })
-- 	    end,
-- 	    mode = { "n", "v" },
-- 	    desc = "Search and Replace",
-- 	},
--     },
-- end)
