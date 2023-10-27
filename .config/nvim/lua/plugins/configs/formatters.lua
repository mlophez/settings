return {
	-- jsonnnet --
	jsonnetfmt = {
		command = "jsonnetfmt",
		args = { "-" },
		stdin = true,
		inherit = true,
		exit_codes = { 0 },
	},
}
