local function tag(tg)
	return s(tg, { t("<" .. tg .. ">"), i(1), t("</" .. tg .. ">") })
end

return {
	s("!",
		{
			t("<!DOCTYPE html>"),
			t({"", "<html>"}),
			t({"", "<head>"}),
			t({"\t", "<title>"}), i(1), t("</title"),
			t({"\t", "<meta charset=\"utf-8\"/>"}),
			t({"", "</head>"}),
			t({"", "<body>", "\t"}),
			i(0),
			t({"", "</body>"}),
			t({"", "</html>"})
		}
	),

	s("a", { t("<a href="), i(1), t(">"), i(2), t("</a>") }),
	s("img", { t("<img src="), i(1), t(">"), i(2), t("</img>") }),

	tag("button"),

	tag("h1"),
	tag("h2"),
	tag("h3"),
	tag("h4"),
	tag("h5"),
	tag("h6")
}
