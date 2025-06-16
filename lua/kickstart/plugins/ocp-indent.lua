return {
	"ocaml-ocp-indent", -- A unique name for your local plugin
	dir = "/Users/ajbarry/.opam/default/share/ocp-indent/vim",
	ft = "ocaml", -- Only load this plugin for OCaml filetypes
	config = function()
		vim.cmd([[filetype plugin indent on]]) -- Ensure these are on
		--   -- Any other ocp-indent specific setup here
	end,
}
