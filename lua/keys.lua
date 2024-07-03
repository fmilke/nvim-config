
local telescope_builtin = require("telescope.builtin")

vim.keymap.set("n", "<C-L>", ":noh<CR>", {})
vim.keymap.set("n", "<leader>pf", telescope_builtin.find_files, {})
vim.keymap.set("n", "<leader>ps", function()
    local needle = vim.fn.input("Grep > ")
    if not(needle == nil or needle == "") then
        telescope_builtin.grep_string({ search = needle })
    end
end, {})

