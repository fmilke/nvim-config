
local telescope_builtin = require("telescope.builtin")

vim.keymap.set("n", "<C-L>", ":noh<CR>", {})
vim.keymap.set("n", "<leader>pf", telescope_builtin.find_files, {})
vim.keymap.set("n", "<leader>ps", function()
    telescope_builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, {})

