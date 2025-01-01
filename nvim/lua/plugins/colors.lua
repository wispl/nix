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
					FoldColumn = { fg = theme.ui.bg_p1 },

					Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
					PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
					PmenuSbar = { bg = theme.ui.bg_m1 },
					PmenuThumb = { bg = theme.ui.bg_p2 },

					BlinkCmpMenu =  { link = "Pmenu" },
					BlinkCmpMenuSelection = {  link = "PmenuSel" },
					BlinkCmpLabelMatch = { fg = theme.syn.fun },

					StatusNormal = { bg = theme.syn.fun, fg = theme.ui.bg_m3 },
					StatusInsert = { bg = theme.diag.ok, fg = theme.ui.bg },
					StatusVisual = { bg = theme.syn.keyword, fg = theme.ui.bg },
					StatusReplace = { bg = theme.syn.constant, fg = theme.ui.bg },
					StatusCommand = { bg = theme.syn.operator, fg = theme.ui.bg },
					StatusTerminal = { bg = theme.syn.fun, fg = theme.ui.bg_m3 },

					DashboardHeader = { fg = theme.syn.comment },

					NoiceMini = { bg = theme.ui.bg },

					ModesInsert =	{ bg = colors.palette.oniViolet },
					ModesVisual =	{ bg = colors.palette.dragonBlue },
					ModesDelete =	{ bg = colors.palette.dragonRed },
					ModesCopy		=	{ bg = colors.palette.dragonGreen },
				}
			end
		},
	},
}
