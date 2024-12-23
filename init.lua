vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

-- Options

vim.opt.showmode = false
vim.opt.mouse = "a"

vim.opt.nu = true
vim.opt.relativenumber = true
-- vim.opt.colorcolumn = "72"

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.ignorecase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.smartcase = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.inccommand = 'split' -- Preview substitutions live, as you type!

vim.opt.cursorline = true    -- Show which line your cursor is on

vim.opt.termguicolors = true

vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50


-- Remaps
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Explore" })

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>", { desc = "Move to the next quickfix item" })
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>", { desc = "Move to the previous quickfix item" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Go [d]own half a page and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Go [u]p half a page and center" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Find next, open fold and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Find previous, open fold and center" })

vim.keymap.set("v", "<leader>p", "\"_dhp", { desc = "Paste without overriding yank buffer" })

vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d", { desc = "Delete without overriding yank buffer" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank selected to clipboard register" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank until the end of the line to clipboard register" })

vim.keymap.set("n", "Q", "<nop>", { desc = "Don't go there" })

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace all occurrences" })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = "Clear highlights" })


vim.keymap.set("n", "<leader>st", function()
    vim.cmd.vnew()
    vim.cmd.term()
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0, 15)
end, { desc = "Open a [S]mall [T]erminal" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit to normal mode in terminal" })

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})


-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)


-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- add your plugins here
        {
            'nvim-telescope/telescope.nvim',
            event = 'VimEnter',
            branch = '0.1.x',
            dependencies = { 'nvim-lua/plenary.nvim',
                {
                    'nvim-telescope/telescope-fzf-native.nvim',
                    build = 'make',
                    -- `cond` is a condition used to determine whether this plugin should be
                    -- installed and loaded.
                    cond = function()
                        return vim.fn.executable 'make' == 1
                    end,
                },
                { 'nvim-telescope/telescope-ui-select.nvim' },
            }
        },
        { "nvim-treesitter/nvim-treesitter",  build = ":TSUpdate" },
        { "mbbill/undotree" },
        { "tpope/vim-fugitive" },
        { 'williamboman/mason.nvim' },
        { 'williamboman/mason-lspconfig.nvim' },
        { 'neovim/nvim-lspconfig' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/nvim-cmp' },
        { "edgedb/edgedb-vim" },
        {
            "rose-pine/neovim",
            name = "rose-pine",
            priority = 1000,
            opts = {
                styles = {
                    bold = true,
                    italic = false,
                    transparency = true,
                },
            },
            init = function()
                vim.cmd.colorscheme('rose-pine')
            end
        },
        -- {
        -- 	"catppuccin/nvim",
        -- 	name = "catppuccin",
        -- 	priority = 1000,
        --     init = function ()
        --         vim.cmd.colorscheme('catppuccin-mocha')
        --     end
        -- },
        -- {
        --     "folke/tokyonight.nvim",
        --     name = "tokyonight",
        --     lazy = false,
        --     priority = 1000,
        --     init = function()
        --         vim.cmd.colorscheme("tokyonight-night")
        --     end
        -- },
    },
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
})
