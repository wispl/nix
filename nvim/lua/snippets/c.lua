return {
	s("fn",
		fmta([[
			<> <>(<>) {
				<>
			}
		]], { i(1, "void"), i(2, "name"), i(3, "args"), i(0) })
	),

	s("if",
		fmta([[
			if (<>) {
				<>
			}
		]], { i(1, "true"), i(0) })
	),

	s("else if",
		fmta([[
			else if (<>) {
				<>
			}
		]], { i(1, "true"), i(0) })
	),

	s("else",
		fmta([[
			else {
				<>
			}
		]], i(0))
	),

	s("for",
		fmta([[
			for (<>) {
				<>
			}
		]], { i(1), i(0) })
	),

	s("fora",
		fmt([[
			for (int {} = {}; {} < {} ++{}) {{
				{}
			}}
		]], { i(1, "i"), i(2, "0"), rep(1), i(3, "len"), rep(1), i(0) })
	),

	s("while",
		fmta([[
			while (<>) {
				<>
			}
		]], { i(1, "true"), i(0) })
	),

	s("switch",
		fmta([[
			switch (<>) {
			<>
			}
		]], { i(1, "var"), i(0) })
	),

	s("struct",
		fmta([[
			struct <> {
				<>
			};
		]], { i(1, "var"), i(0) })
	),
}
