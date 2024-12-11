function get_visual(args, parent)
  if (#parent.snippet.env.LS_SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else
    return sn(nil, i(1, ""))
  end
end

local line_begin = require("luasnip.extras.expand_conditions").line_begin
local in_mathzone = function() return vim.fn['vimtex#syntax#in_mathzone']() == 1 end

return {

	--------------------------
	-- General Environments --
	--------------------------

	s({ trig = "beg", snippetType = "autosnippet" },
		fmta(
			[[
				\begin{<>}
					<>
				\end{<>}
			]],
			{ i(1), i(0), rep(1) }
		),
		{ condition = line_begin }
	),
	s("fig",
		fmta(
			[[
				\begin{figure}[<>]
					\centering
					<>{<>}
					\caption{<>}
					\label{<>}
				\end{figure}
			]],
			{ c(1, { t("h"), t("t"), t("p"), t("b") }),
				i(2, "\\includegraphics[width=\\textwidth]"),
				i(3),
				i(4, "caption"),
				i(5, "label")
			}
		),
		{ condition = line_begin }
	),
	s("table",
		fmta(
			[[
				\begin{table}[<>]
					\centering
					\caption{<>}
					\label{<>}
					\begin{tabular}
						<>
					\end{tabular}
				\end{table}
			]],
			{ c(1, { t("h"), t("t"), t("p"), t("b") }),
				i(2, "caption"),
				i(3, "label"),
				i(0)
			}
		),
		{ condition = line_begin }
	),
	s({ trig = "enum", snippetType = "autosnippet" },
		fmta(
			[[
				\begin{enumerate}
					\item <>
				\end{enumerate}
			]],
			{ i(0) }
		),
		{ condition = line_begin }
	),
	s({ trig = "item", snippetType = "autosnippet" },
		fmta(
			[[
				\begin{itemize}
					\item <>
				\end{itemize}
			]],
			{ i(0) }
		),
		{ condition = line_begin }
	),
	s({ trig = "mk", snippetType = "autosnippet" }, { t("$"), i(1), t("$"), i(0) }),
	s({ trig = "dm", snippetType = "autosnippet" },
		fmta(
			[[
				\[
					<>
				\]
			]],
			{ d(1, get_visual) }
		),
		{ condition = line_begin }
	),
	s({ trig = "ali", snippetType = "autosnippet" },
		fmta(
			[[
				\begin{align}
					<>
				\end{align}
			]],
			{ i(0) }
		),
		{ condition = line_begin }
	),

	s({ trig = "tt", snippetType = "autosnippet" },
		{ t("\\text{"), i(1), t("}") },
		{ condition = in_mathzone }
	),

	----------------------
	-- General Snippets --
	----------------------

	s({ trig = "SI", snippetType = "autosnippet" },
		fmta("\\SI{<>}{<>}", { i(1), i(2) })
	),

	-------------------
	-- Math Context --
	-------------------

	-- Symbols
	s({ trig = ">>", snippetType = "autosnippet" },
		{ t("\\gg") },
		{ condition = in_mathzone }
	),
	s({ trig = "<<", snippetType = "autosnippet" },
		{ t("\\ll") },
		{ condition = in_mathzone }
	),
	s({ trig = ">=", snippetType = "autosnippet" },
		{ t("\\ge") },
		{ condition = in_mathzone }
	),
	s({ trig = "<=", snippetType = "autosnippet" },
		{ t("\\le") },
		{ condition = in_mathzone }
	),
	s({ trig = "!=", snippetType = "autosnippet" },
		{ t("\\neq") },
		{ condition = in_mathzone }
	),
	s({ trig = "==", snippetType = "autosnippet" },
		{ t("&=") },
		{ condition = in_mathzone }
	),
	s({ trig = "=>", snippetType = "autosnippet" },
		{ t("\\implies") },
		{ condition = in_mathzone }
	),
	s({ trig = "...", snippetType = "autosnippet" },
		{ t("\\ldots") },
		{ condition = in_mathzone }
	),
	s({ trig = "oo", snippetType = "autosnippet" },
		{ t("\\infty") },
		{ condition = in_mathzone }
	),
	s({ trig = "(%w)hat", regTrig = true, snippetType = "autosnippet" },
		fmta("\\hat{<>}", { f(function(_, snip) return snip.captures[1] end) }),
		{ condition = in_mathzone }
	),
	s({ trig = "(%w)bar", regTrig = true, snippetType = "autosnippet" },
		fmta("\\overline{<>}", { f(function(_, snip) return snip.captures[1] end) }),
		{ condition = in_mathzone }
	),
	s({ trig = "(%a)%.,", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\vec{<>}", { f(function(_, snip) return snip.captures[1] end) }),
		{ condition = in_mathzone }
	),
	s({ trig = "(%a),%.", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\vec{<>}", { f(function(_, snip) return snip.captures[1] end) }),
		{ condition = in_mathzone }
	),
	s({ trig = "(%a)%.%.", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta("\\bm{<>}", { f(function(_, snip) return snip.captures[1] end) }),
		{ condition = in_mathzone }
	),
	s({ trig = "nabl", wordTrig = false, snippetType = "autosnippet" },
		{ t("\\nabla ") },
		{ condition = in_mathzone }
	),
	s({ trig = "OO", wordTrig = false, snippetType = "autosnippet" },
		{ t("\\mathbb{O} ") },
		{ condition = in_mathzone }
	),
	s({ trig = "RR", wordTrig = false, snippetType = "autosnippet" },
		{ t("\\mathbb{R} ") },
		{ condition = in_mathzone }
	),

	-- Operations
	s({ trig = "sq", wordTrig = false, snippetType = "autosnippet" },
		fmta("\\sqrt{<>}", { i(1) }),
		{ condition = in_mathzone }
	),
	s({ trig = "lim", snippetType = "autosnippet" },
		fmta("\\lim_{<> \\to <>}", { i(1, "n"), i(2, "\\infty") }),
		{ condition = in_mathzone }
	),
	s({ trig = "sum", wordTrig = false, snippetType = "autosnippet" },
		fmta("\\sum_{n = <>}^{<>}", { i(1, "1"), i(2, "\\infty") }),
		{ condition = in_mathzone }
	),
	s({ trig = "dddint", wordTrig = false, snippetType = "autosnippet" },
		fmta(
			"\\int_{<>}^{<>} \\int_{<>}^{<>} \\int_{<>}^{<>} <>\\ <>",
			{ i(1), i(2), i(3), i(4), i(5), i(6), i(7), i(8, "dxdydz") }
		),
		{ condition = in_mathzone }
	),
	s({ trig = "ddint", wordTrig = false, snippetType = "autosnippet" },
		fmta(
			"\\int_{<>}^{<>} \\int_{<>}^{<>} <>\\ <>",
			{ i(1), i(2), i(3), i(4), i(5), i(6, "dxdy") }
		),
		{ condition = in_mathzone }
	),
	s({ trig = "dint", wordTrig = false, snippetType = "autosnippet" },
		fmta("\\int_{<>}^{<>} <>\\ <>", { i(1), i(2), i(3), i(4, "dx")}),
		{ condition = in_mathzone }
	),
	s({ trig = "part", wordTrig = false, snippetType = "autosnippet" },
		fmta("\\frac{\\partial <>}{\\partial <>}", { i(1), i(2) }),
		{ condition = in_mathzone }
	),
	s({ trig = "xx", wordTrig = false, snippetType = "autosnippet" },
		{ t("\\times ") },
		{ condition = in_mathzone }
	),
	s({ trig = "**", wordTrig = false, snippetType = "autosnippet" },
		{ t("\\cdot ") },
		{ condition = in_mathzone }
	),
	s({ trig = "norm", wordTrig = false, snippetType = "autosnippet" },
		{ t("|"), i(1), t("|") },
		{ condition = in_mathzone }
	),
	s({ trig = "(%a)grad", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta(
			"\\langle <>_{x}, <>_{y}, <>_{z}\\rangle",
			{
				f(function(_, snip) return snip.captures[1] end),
				f(function(_, snip) return snip.captures[1] end),
				f(function(_, snip) return snip.captures[1] end)
			}
		),
		{ condition = in_mathzone }
	),

	-- Environments
	s({ trig = "pmat", snippetType = "autosnippet" },
		fmta(
			[[
				\begin{pmatrix}
					<>
				\end{pmatrix}
			]],
			{ i(1) }
		),
		{ condition = in_mathzone }
	),
	s({ trig = "bmat", snippetType = "autosnippet" },
		fmta(
			[[
				\begin{bmatrix}
					<>
				\end{bmatrix}
			]],
			{ i(1) }
		),
		{ condition = in_mathzone }
	),
	s({ trig = "case", snippetType = "autosnippet" },
		fmta(
			[[
				\begin{cases}
					<>
				\end{cases}
			]],
			{ i(1) }
		),
		{ condition = in_mathzone }
	),

	-- Subscripts and Superscripts
	s({ trig = "_", wordTrig = false, snippetType = "autosnippet" },
		fmta("_{<>}", { i(1) } ),
		{ condition = in_mathzone }
	),
	s({ trig = "td", wordTrig = false, snippetType = "autosnippet" },
		fmta("^{<>}", { i(1) }),
		{ condition = in_mathzone }
	),
	s({ trig = "rd", wordTrig = false, snippetType = "autosnippet" },
		fmta("^{(<>)}", { i(1) }),
		{ condition = in_mathzone }
	),
	-- a0 -> a_{0}
	s({ trig = "(%a)(%d)", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
		fmta(
			"<>_{<>}",
			{
				f(function(_, snip) return snip.captures[1] end),
				f(function(_, snip) return snip.captures[2] end),
			}
		),
		{ condition = in_mathzone }
	),
	s({ trig = "sr", wordTrig = false, snippetType = "autosnippet" },
		{ t("^{2}") },
		{ condition = in_mathzone }
	),
	s({ trig = "cb", wordTrig = false, snippetType = "autosnippet" },
		{ t("^{3}") },
		{ condition = in_mathzone }
	),

	-- Fractions
	s({ trig = "//", snippetType = "autosnippet" },
		fmta("\\frac{<>}{<>}<>", { i(1), i(2), i(0) }),
		{ condition = in_mathzone }
	),
	-- (a + b + (f*3)) -> \frac{a + b + (f*3)}{}
	s({ trig = "(%b())/", regTrig = true, snippetType = "autosnippet" },
		fmta(
			"\\frac{<>}{<>}<>",
			{
				-- remove the parenthesis
				f(function (_, snip) return string.sub(snip.captures[1], 2, -2) end),
				i(1),
				i(0)
			}
		),
		{ condition = in_mathzone }
	),
	-- TODO: this does not work for expressions with {}
	-- expression -> \frac{expression}{}
	s({ trig = "([%w%.%-_\\]+)/", regTrig = true, snippetType = "autosnippet" },
		fmta(
			"\\frac{<>}{<>}<>",
			{
				f(function (_, snip) return snip.captures[1] end),
				i(1),
				i(0)
			}
		),
		{ condition = in_mathzone }
	),
	-- nested fractions
	s({ trig = "(\\frac%{%w*%}%{%w*%})/", regTrig = true, snippetType = "autosnippet" },
		fmta(
			"\\frac{<>}{<>}<>",
			{
				f(function (_, snip) return snip.captures[1] end),
				i(1),
				i(0)
			}
		),
		{ condition = in_mathzone }
	)
}
