return {
	{
		"rebelot/kanagawa.nvim",
		lazy = true,
		opts = {
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
					FloatBorder = { bg = "none" },
					FloatTitle = { bg = "none" },
					WinSeparator = { fg = theme.ui.bg_p2 },

					Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
					PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
					PmenuSbar = { bg = theme.ui.bg_m1 },
					PmenuThumb = { bg = theme.ui.bg_p2 },

					StatusNormal = { bg = theme.syn.fun, fg = theme.ui.bg_m3 },
					StatusInsert = { bg = theme.diag.ok, fg = theme.ui.bg },
					StatusVisual = { bg = theme.syn.keyword, fg = theme.ui.bg },
					StatusReplace = { bg = theme.syn.constant, fg = theme.ui.bg },
					StatusCommand = { bg = theme.syn.operator, fg = theme.ui.bg },
					StatusTerminal = { bg = theme.syn.fun, fg = theme.ui.bg_m3 },

					DashboardHeader = { fg = theme.syn.comment },

					TelescopePromptTitle = { fg = theme.ui.bg_dim, bg = theme.syn.keyword, bold = true },
					TelescopePromptNormal = { bg = theme.ui.bg_m1 },
					TelescopePromptBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
					TelescopeResultsNormal = { fg = theme.ui.fg, bg = theme.ui.bg_dim },
					TelescopeResultsBorder = { fg = theme.ui.bg_dim, bg = theme.ui.bg_dim },
					TelescopePreviewTitle = { fg = theme.ui.bg_dim, bg = theme.syn.constant, bold = true },
					TelescopePreviewNormal = { bg = theme.ui.bg_dim },
					TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },

					NoiceMini = { bg = theme.ui.bg },

					-- ModesCopy =	{ bg = colors.palette.dragonOrange },
					-- ModesDelete =	{ bg = colors.palette.dragonRed },
					-- ModesInsert =	{ bg = colors.palette.dragonTeal },
					-- ModesVisual =	{ bg = colors.palette.dragonPink },
				}
			end
		},
	},
}
