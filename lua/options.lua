-- options
vim.opt.nu = true
vim.opt.rnu = true

vim.opt.wrap = false

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = false

vim.opt.virtualedit = "block"
vim.opt.updatetime = 50

vim.opt.ignorecase = true
vim.opt.termguicolors = true

vim.opt.clipboard = "unnamedplus"

-- key maps
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open explorer" })

