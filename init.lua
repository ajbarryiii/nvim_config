-- Set leader key to space
vim.g.mapleader = " "

require("options")

require("keymaps")

require("lazy-bootstrap")

require("lazy-plugins")

vim.lsp.set_log_level("OFF")
