local loader = require("plugins.loader").load
return loader("herline", {
	"rebelot/heirline.nvim",

	event = "BufEnter",

	opts = {},
})
