-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Key remappings for normal and visual modes (swap 'j', 'k', 'l' with 't', 'n', 's')
vim.api.nvim_set_keymap('n', 'n', 'k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 't', 'j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 's', 'l', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'n', 'k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 't', 'j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 's', 'l', { noremap = true, silent = true })

-- Performance and appearance settings
vim.opt.relativenumber = true
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.redrawtime = 1500
vim.opt.hidden = true
vim.o.completeopt = 'menuone,noselect'

-- Install and configure plugins using lazy.nvim
require("lazy").setup({
    -- LSP Configurations for Neovim
    { "neovim/nvim-lspconfig" },
    
    -- Autocompletion plugins
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-vsnip",
            "hrsh7th/vim-vsnip"
        },
        config = function()
            require('cmp').setup({
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'buffer' },
                    { name = 'path' },
                },
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                mapping = {
                    ['<C-Space>'] = require('cmp').mapping.complete(),
                    ['<CR>'] = require('cmp').mapping.confirm({ select = true }),
                    ['<Tab>'] = require('cmp').mapping(function(fallback)
                        if require('cmp').visible() then
                            require('cmp').select_next_item()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                },
                window = {
                    completion = { border = 'rounded', max_height = 20, max_width = 50 }
                }
            })
        end,
    },
    
    -- Nvim-tree file explorer with file icons
    {
        "kyazdani42/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require'nvim-tree'.setup {}
            vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
        end,
    },
    
    -- Treesitter for syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            require'nvim-treesitter.configs'.setup {
                ensure_installed = { "cpp", "python", "lua" },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            }
        end,
    },
    
    -- Lspsaga for LSP UI enhancements
    {
        "glepnir/lspsaga.nvim",
        branch = "main",
        config = function()
            require('lspsaga').setup {}
        end,
    },
    
    -- Linting plugin
    {
        "mfussenegger/nvim-lint",
        config = function()
            require('lint').linters_by_ft = {
                rust = { 'cargo' },
                typescript = { 'eslint' },
                python = { 'pylint' },
            }
        end,
    },

    {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    config = function()
            vim.cmd("colorscheme catppuccin")
	    vim.opt.termguicolors = true
        end,
    }
})

-- C++ language server setup with clangd
require('lspconfig').clangd.setup({
    on_attach = function(_, bufnr)
        local opts = { noremap = true, silent = true }
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    end,
    flags = {
        debounce_text_changes = 150,
    }
})
