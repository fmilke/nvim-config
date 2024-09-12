local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function() vim.cmd.colorscheme("catppuccin") end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "vim", "lua", "vimdoc" },
                auto_install = true,
                highilight = {
                    enable = true,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<leader>ss",
                        node_incremental = "<leader>si",
                        scope_incremental = "<leader>sc",
                        node_decremental = "<leader>sd",
                    },
                },
                textobjects = {
                select = {
                  enable = true,

                  -- Automatically jump forward to textobj, similar to targets.vim
                  lookahead = true,

                  keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    -- You can optionally set descriptions to the mappings (used in the desc parameter of
                    -- nvim_buf_set_keymap) which plugins like which-key display
                    ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                    -- You can also use captures from other query groups like `locals.scm`
                    ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
                  },
                  -- You can choose the select mode (default is charwise 'v')
                  --
                  -- Can also be a function which gets passed a table with the keys
                  -- * query_string: eg '@function.inner'
                  -- * method: eg 'v' or 'o'
                  -- and should return the mode ('v', 'V', or '<c-v>') or a table
                  -- mapping query_strings to modes.
                  selection_modes = {
                    ['@parameter.outer'] = 'v', -- charwise
                    ['@function.outer'] = 'v', -- linewise
                    ['@class.outer'] = '<c-v>', -- blockwise
                  },
                  -- If you set this to `true` (default is `false`) then any textobject is
                  -- extended to include preceding or succeeding whitespace. Succeeding
                  -- whitespace has priority in order to act similarly to eg the built-in
                  -- `ap`.
                  --
                  -- Can also be a function which gets passed a table with the keys
                  -- * query_string: eg '@function.inner'
                  -- * selection_mode: eg 'v'
                  -- and should return true of false
                  include_surrounding_whitespace = true,
                },
              },
            })
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = { {'nvim-lua/plenary.nvim'} },
    },
    { "nvim-treesitter/nvim-treesitter-textobjects", },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        dependencies = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        },
        config = function()
            local lsp = require('lsp-zero')
            lsp.preset('recommended')
            lsp.ensure_installed({ 'lua_ls'})

            lsp.on_attach(function(client, buffer)
                vim.api.nvim_buf_set_option(buffer, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
                vim.keymap.set('n', '<leader>vrn', function() vim.lsp.buf.rename() end, { desc = 'Rename symbol' })
                vim.keymap.set('n', '<leader>vrr', function() vim.lsp.buf.references() end, { desc = 'Show references' })
                vim.keymap.set('n', '<leader>vca', function() vim.lsp.buf.code_action() end, { desc = 'Code Actions' })
                vim.keymap.set('n', '<leader>gd', function() vim.lsp.buf.definition() end, { desc = 'Go To Definition' })
                vim.keymap.set('n', '<leader>K', function() vim.lsp.buf.hover() end, { desc = 'Hover' })
                vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, { desc = 'Show signature' })
            end)

            lsp.setup()
        end,
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")

            harpoon:setup()

            vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end, { desc = "Append to harpoon list" })
            vim.keymap.set("n", "<C-e>", function () harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Open harpoon" })

            vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Open first harpooned buffer" })
            vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Open second harpooned buffer" })
            vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Open third harpooned buffer" })
            vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Open fourth harpooned buffer" })

            vim.keymap.set("n", "<leader>bp", function() harpoon:list():prev() end, { desc = "Go to previous harpooned buffer" })
            vim.keymap.set("n", "<leader>bn", function() harpoon:list():next() end, { desc = "Go to next harpooned buffer" })

        end,
    },
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup {
                columns = { "icon", "size" },
            }

            vim.keymap.set('n', '-', "<CMD>Oil<CR>", { desc = 'Open parent directory ' })
        end,
    },
    -- debug adapter protocol
    {
        "mfussenegger/nvim-dap",
        config = function()
            vim.keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", { desc = "Set breakpoint with condition" })
            vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>", { desc = "Toggle breapoint" })
            vim.keymap.set("n", "<leader>dr", function() require'dap'.repl.open() end, { desc = "Open dap menu" })
        end,
    },
    { "rcarriga/nvim-dap-ui" },
    {
        "NicholasMata/nvim-dap-cs",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            require('dap-cs').setup()
        end,
    },
    -- git plugin
    { "tpope/vim-fugitive" },
    -- advanced substitute
    { "tpope/vim-abolish" },
    -- open text in other applications
    { "chrishrb/gx.nvim" },
})

