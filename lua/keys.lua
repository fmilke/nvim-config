local telescope_builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>x", ":source %<CR>", {})
vim.keymap.set("n", "<C-L>", ":noh<CR>", {})
vim.keymap.set("n", "<leader>pf", telescope_builtin.find_files, {})
vim.keymap.set("n", "<leader>ps", function()
    local needle = vim.fn.input("Grep > ")
    if not(needle == nil or needle == "") then
        telescope_builtin.grep_string({ search = needle })
    end
end, {})

vim.keymap.set("n", "<C-d>", function()
    vim.diagnostic.open_float()
end, { desc = "show line diagnostics" })

--vim.keymap.set('x', "<leader>cc", require'change_case'.change_casing, { desc = "change casing" })
vim.keymap.set('x', "<leader>cc",
    function ()
        require'change_case'.change_casing()
    end, { desc = "change casing" })

