-- Key mappings
-- Open file explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

--set :W to also be save
vim.cmd("command! W w")

-- Move selected text down or up in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Join lines without moving the cursor
vim.keymap.set("n", "J", "mzJ`z")

-- Center the cursor after scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Center after searching next or previous match
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste without overwriting register
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Delete without overwriting register
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Map <C-c> as an escape alternative
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Disable Ex mode
vim.keymap.set("n", "Q", "<nop>")

-- Open tmux sessionizer
--vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux new tmux-sessionizer<CR>")

-- Navigate quickfix and location lists with centering
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Replace word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Key remappings for normal and visual modes (swap 'j', 'k', 'l' with 't', 'n', 's')
vim.api.nvim_set_keymap("n", "n", "k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "t", "j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "s", "l", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "n", "k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "t", "j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "s", "l", { noremap = true, silent = true })

--wrap text with grouping symbol in visual mode;

local function wrap_char_expr()
	-- Capture the next typed character
	local open_char = vim.fn.nr2char(vim.fn.getchar())

	-- Map opening characters to their corresponding closing characters
	local pairs = {
		["("] = ")",
		["["] = "]",
		["{"] = "}",
		["<"] = ">",
		['"'] = '"',
		["`"] = "`",
		["'"] = "'",
	}

	local close_char = pairs[open_char]
	if close_char then
		-- If recognized, perform: c <open_char><close_char> <esc> P
		return "c" .. open_char .. close_char .. "<esc>P"
	else
		-- Otherwise, just fall back to literally pressing 'l' + typed character
		-- (meaning we do not handle wrapping)
		return "l" .. open_char
	end
end

vim.keymap.set("x", "l", wrap_char_expr, { expr = true, noremap = true })

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- vim: ts=2 sts=2 sw=2 et
