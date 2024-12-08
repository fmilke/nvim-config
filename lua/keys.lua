local telescope_builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>x", ":source %<CR>", { desc = "Source current file" })
vim.keymap.set("n", "<C-L>", ":noh<CR>", { desc = "Clear search" })
vim.keymap.set("n", "<leader>pf", telescope_builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>ps", function()
    local needle = vim.fn.input("Grep > ")
    if not (needle == nil or needle == "") then
        telescope_builtin.grep_string({ search = needle })
    end
end, { desc = "Search for files containing keyword" })

vim.keymap.set("n", "<C-d>", function()
    vim.diagnostic.open_float()
end, { desc = "Show line diagnostics" })

-- change casing
vim.keymap.set('x', "<leader>cc", require 'change_case'.change_casing, { desc = "Change casing" })

-- organize imports
vim.keymap.set('n', "<leader>oi", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local lsps = vim.lsp.get_clients({
        bufnr = bufnr,
    })

    for _, lsp in ipairs(lsps) do
        if lsp.name == 'ts_ls' then
            lsp:exec_cmd({
                title = "Organize Imports",
                command = "_typescript.organizeImports",
                bufnr = bufnr,
                arguments = { vim.fn.expand("%:p") },
            })
        end
    end
end, { desc = "Organize typescript imports" })
