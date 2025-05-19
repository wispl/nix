return {
	s("fn",
		fmt([[
			function {}({})
				{}
			end
		]], { i(1, "name"), i(2, "args"), i(0) })
	),

	s("if",
		fmt([[
			if {} then
				{}
			end
		]], { i(1, "true"), i(0) })
	),

	s("elseif",
		fmt([[
			elseif {} then
				{}
		]], { i(1, "true"), i(0) })
	),

	s("for",
		fmt([[
			for {} do
				{}
			end
		]], { i(1), i(0) })
	),

	-- TODO ipairs and pairs
	s("fora",
		fmt([[
			for {},{} in ipairs({}) do
				{}
			end
		]], { i(1, "_"), i(2, "j"), i(3, "arr"), i(0) })
	),

	s("while",
		fmt([[
			while {} do
				{}
			end
		]], { i(1, "true"), i(0) })
	),
}
