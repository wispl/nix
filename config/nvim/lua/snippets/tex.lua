local b = require("luasnip.extras.expand_conditions").line_begin
local m = function() return vim.fn['vimtex#syntax#in_mathzone']() == 1 end

-- table snippet from luasnip wiki
local function column_count_from_string(descr)
	return #(descr:gsub("[^clm]", ""))
end

local tab = function(args, snip)
	local cols = column_count_from_string(args[1][1])
	if not snip.rows then
		snip.rows = 1
	end
	local nodes = {}
	local ins_indx = 1
	for j = 1, snip.rows do
		table.insert(nodes, r(ins_indx, tostring(j).."x1", i(1)))
		ins_indx = ins_indx+1
		for k = 2, cols do
			table.insert(nodes, t" & ")
			table.insert(nodes, r(ins_indx, tostring(j).."x"..tostring(k), i(1)))
			ins_indx = ins_indx+1
		end
		table.insert(nodes, t{"\\\\", "\t\t"})
	end
	nodes[#nodes] = t""
	return sn(nil, nodes)
end

-- enumerate and itemize snippet adapted from table
local reclist = function(args, snip)
	if not snip.rows then
		snip.rows = 1
	end
	local nodes = {}
	local ins_indx = 1
	for j = 1, snip.rows do
		table.insert(nodes, t("\\item "))
		table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
		table.insert(nodes, t({"", "\t"}))
		ins_indx = ins_indx + 1
	end
	nodes[#nodes] = t""
	return sn(nil, nodes)
end

-- mat snippet adapted from dynamic markdown table on luasnip wiki
local mat = function(args, snip)
	-- silences errors
	local rows = tonumber(snip.captures[1]) or 0
	local cols = tonumber(snip.captures[2]) or 0
	local nodes = {}
	local ins_indx = 1
	for j = 1, rows do
		table.insert(nodes, r(ins_indx, tostring(j).."x1", i(1)))
		ins_indx = ins_indx+1
		for k = 2, cols do
			table.insert(nodes, t" & ")
			table.insert(nodes, r(ins_indx, tostring(j).."x"..tostring(k), i(1)))
			ins_indx = ins_indx+1
		end
		table.insert(nodes, t{"\\\\", "\t"})
	end
	nodes[#nodes] = t""
	return sn(nil, nodes)
end

--------------------------
--   General Snippets   --
--------------------------

parse_auto({trig = "beg", condition = b }, "\\begin{$1}\n\t${2:$LS_SELECT_DEDENT}\n\\end{$1}")
parse_auto("qty", "\\qty{$1}{$2}$0")

add_snip("fig",
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
	)
)

add_snip("table",
	fmta(
		[[
				\begin{table}[h]
					\centering
					\caption{<>}
					\label{<>}
					\begin{tabular}{<>}
						<>
					\end{tabular}
				\end{table}
			]],
		{ i(1, "caption"), i(2, "label"), i(3, "c"),
			d(4, tab, {3}, {
				user_args = {
					function(snip) snip.rows = snip.rows + 1 end,
					function(snip) snip.rows = math.max(snip.rows - 1, 1) end
				}
			})
		}
	)
)

add_auto({ trig = "enum", condition = b },
	fmta(
		[[
			\begin{enumerate}
				<>
			\end{enumerate}
		]],
		{ d(1, reclist, {}, {
			user_args = {
					function(snip) snip.rows = snip.rows + 1 end,
					function(snip) snip.rows = math.max(snip.rows - 1, 1) end
			}
		})}
	)
)

add_auto({ trig = "item", condition = b },
	fmta(
		[[
			\begin{itemize}
				<>
			\end{itemize}
		]],
		{ d(1, reclist, {}, {
			user_args = {
					function(snip) snip.rows = snip.rows + 1 end,
					function(snip) snip.rows = math.max(snip.rows - 1, 1) end
			}
		})}
	)
)

--------------------------
--     Math Snippets    --
--------------------------

parse_auto("mk", "\\$$1\\$$0")
parse_auto({ trig = "dm", condition = b }, "\\[\n\t$0\n\\]")
parse_auto({ trig = "ali", condition = b }, "\\begin{align}\n\t$0\n\\end{align}")

parse_auto({ trig = "mcal", condition = m }, "\\mathcal{$1}$0")
parse_auto({ trig = "tt", condition = m }, "\\text{$1}$0")

parse_auto({ trig = "case", condition = m }, "\\begin{cases}\n\t$0\n\\end{cases}")
parse_auto({ trig = "cvec", condition = m }, "\\begin{pmatrix} ${1:x} \\\\\\ \\vdots \\\\\\ ${2:x_{n}} \\end{pmatrix}$0")
parse_auto({ trig = "pmat", condition = m }, "\\begin{pmatrix}\n\t$1\n\\end{pmatrix}$0")

add_snip({ trig="mat(%d+)x(%d+)", condition = m, regTrig = true },
	fmta(
		[[
			\begin{<>}
				<>
			\end{<>}
		]],
		{ c(1, { t("pmatrix"), t("bmatrix") }), d(2, mat), rep(1) }
	)
)

--------------------------
--    Math Operators		--
--------------------------

parse_auto({ trig = "~~", condition = m }, "\\sim")
parse_auto({ trig = ">>", condition = m }, "\\gg")
parse_auto({ trig = "<<", condition = m }, "\\ll")
parse_auto({ trig = ">=", condition = m }, "\\ge")
parse_auto({ trig = "<=", condition = m }, "\\le")
parse_auto({ trig = "=>", condition = m }, "\\implies")
parse_auto({ trig = "=<", condition = m }, "\\impliedby")
parse_auto({ trig = "iff", condition = m }, "\\iff")
parse_auto({ trig = "==", condition = m }, "&=")
parse_auto({ trig = "!=", condition = m }, "\\neq")
parse_auto({ trig = "ceil", condition = m }, "\\left\\lceil $1 \\right\\rceil$0")
parse_auto({ trig = "floor", condition = m }, "\\left\\lfloor $1 \\right\\rfloor$0")

parse_auto({ trig = "dint", condition = m }, "\\int_{${1:0}}^{${2:x}} ${3:f(x)} \\,d${4:x}")
parse_auto({ trig = "sum", condition = m }, "\\sum_{${1:k = 0}}^{${2:\\infty}} $0")
parse_auto({ trig = "lim", condition = m }, "\\lim_{${1:k = 0}}^{${2:\\infty}} $0")

parse_auto({ trig = "part", condition = m }, "\\frac{\\partial ${1:x}}{\\partial ${2:y}}")

parse_auto({ trig = "sq", condition = m }, "\\sqrt{${1:x}} $0")

parse_auto({ trig = "invs", wordTrig = false, condition = m }, "^{-1}")
parse_auto({ trig = "sr", wordTrig = false, condition = m }, "^{2}")
parse_auto({ trig = "cb", wordTrig = false, condition = m }, "^{3}")
parse_auto({ trig = "td", wordTrig = false, condition = m }, "^{$1}$0")
parse_auto({ trig = "_", wordTrig = false, condition = m }, "_{$1}$0")
-- a0 -> a_{0}
parse_auto({ trig = "(%a)(%d)", regTrig = true, condition = m }, "${LS_CAPTURE_1}_{${LS_CAPTURE_2}}")

parse_auto({ trig = "EE", condition = m }, "\\exists")
parse_auto({ trig = "AA", condition = m }, "\\forall")

parse_auto({ trig = "xx", condition = m }, "\\times")
parse_auto({ trig = "**", condition = m }, "\\cdot")

parse_auto({ trig = "->", condition = m }, "\\rightarrow")
parse_auto({ trig = "<->", condition = m }, "\\leftrightarrow")

parse_auto({ trig = "cc", condition = m }, "\\subset")
parse_auto({ trig = "c=", condition = m }, "\\subseteq")
parse_auto({ trig = "inn", condition = m }, "\\in")
parse_auto({ trig = "notin", condition = m }, "\\not\\in")
parse_auto({ trig = "nn", condition = m }, "\\cap")
parse_auto({ trig = "uu", condition = m }, "\\cup")
parse_auto({ trig = "NN", condition = m }, "\\bigcap_{$1} $0")
parse_auto({ trig = "UU", condition = m }, "\\bigcup_{$1} $0")

local ops = { "sin", "cos", "tan", "csc", "sec", "cot", "arccot", "arcsin", "arccos", "ln", "exp", "log", "mid" }
for _, op in ipairs(ops) do
	parse_auto({ trig = op, condition = m }, "\\" .. op)
end

--------------------------
--     Math Symbols     --
--------------------------

parse_auto({ trig = "...", condition = m }, "\\hdots")
parse_auto({ trig = "oo", condition = m }, "\\infty")
parse_auto({ trig = "pi", wordTrig = false, condition = m }, "\\pi")
parse_auto({ trig = "epsi", condition = m }, "\\epsilon")
parse_auto({ trig = "nabl", condition = m }, "\\nabla")

parse_auto({ trig = "RR", condition = m }, "\\R")
parse_auto({ trig = "OO", condition = m }, "\\emptyset")
parse_auto({ trig = "QQ", condition = m }, "\\Q")
parse_auto({ trig = "PP", condition = m }, "\\P")

--------------------------
--    Math Delimiters	  --
--------------------------

parse_auto({ trig = "lrp", condition = m }, "\\left( $1 \\right) $0")
parse_auto({ trig = "lrb", condition = m }, "\\left\\{ $1 \\right\\\\} $0")
parse_auto({ trig = "lra", condition = m }, "\\left\\langle $1 \\right\\rangle $0")
parse_auto({ trig = "lrl", condition = m }, "\\left| $1 \\right| $0")

--------------------------
--    Math Postfixes 	  --
--------------------------

add_post({ trig = "hat", condition = m }, parse(nil, "\\hat{$POSTFIX_MATCH}"))
add_post({ trig = "bar", condition = m }, parse(nil, "\\overline{$POSTFIX_MATCH}"))
add_post({ trig = "tld", condition = m }, parse(nil, "\\widetilde{$POSTFIX_MATCH}"))
add_post({ trig = "vec", condition = m }, parse(nil, "\\vec{$POSTFIX_MATCH}"))

parse_auto({ trig = "hat", condition = m }, "\\hat{$1}$0")
parse_auto({ trig = "bar", condition = m }, "\\overline{$1}$0")
parse_auto({ trig = "tld", condition = m }, "\\widetilde{$1}$0")
parse_auto({ trig = "vec", condition = m }, "\\vec{$1}$0")

--------------------------
--      Fractions       --
--------------------------

parse_auto({ trig = "//", condition = m }, "\\frac{$1}{$2}$0")
-- (a + b + (f*3)) -> \frac{a + b + (f*3)}{}
add_auto({ trig = "(%b())/", regTrig = true, condition = m },
	fmta(
		"\\frac{<>}{<>}<>",
		{
			-- remove the parenthesis
			f(function (_, snip) return string.sub(snip.captures[1], 2, -2) end),
			i(1),
			i(0)
		}
	)
)
-- Lua patterns do not support "|" or even "?" on a capture group so we need to
-- make a new snippet for each possible combination, patterns taken from Gilles
-- Castel's site using the awesome regex diagram.
local frac_patterns = {
	"(%d+)/",										-- all digits
	"(%d*\\?%a+)/",							-- 90\pi or 90asdc
	"(%d*\\?%a+_{%w+})/",				-- 90\pi_{2}
	"(%d*\\?%a+^{%w+})/",				-- 90\pi^{2}
	"(%d*\\?%a+_{%w+}^{%w+})/", -- 90\pi_{2}^{134}
	"(%d*\\?%a+^{%w+}_{%w+})/", -- 90\pi^{2}_{13}
}
for _, pattern in ipairs(frac_patterns) do
	parse_auto({ trig = pattern, wordTrig = false, regTrig = true, condition = m }, "\\frac{${LS_CAPTURE_1}}{$1}$0")
end
