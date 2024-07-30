local get_text = function(s_start, s_end)
    local n_lines = vim.fn.abs(s_end[2] - s_start[2]) + 1
    local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)

    lines[1] = string.sub(lines[1], s_start[3], -1)
    if n_lines == 1 then
        lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
    else
        lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
    end

    return table.concat(lines, '\n')
end

local get_vrange = function ()
    local s_start = vim.fn.getpos('v')
    local s_end = vim.fn.getpos('.')

    if s_start[2] > s_end[2] then
        return s_end, s_start
    end

    if s_start[2] == s_end[2] and s_start[3] > s_end[3] then
        return s_end, s_start
    end

    return s_start, s_end
end

local bufnr = 13

local change_casing_int = function(flag)
    vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, { '-1' })
    local s_start, s_end = get_vrange()
    vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, { '0' })
    local sel = get_text(s_start, s_end)

    Vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, { tostring(#(vim.fn.split(sel, '\n'))) })
    vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, { '1' })
    local out = vim.system({'recase', flag, '-t', sel}, { stderr = false, text = true }):wait();
    vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, { 'code', tostring(out.code) })
    vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, { '2' })
    local lines = vim.fn.split(out.stdout, '\n')

    vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, { tostring(#lines) })

    vim.api.nvim_buf_set_text(s_start[1], s_start[2] - 1, s_start[3] - 1, s_end[2] - 1, s_end[3], lines)
end

local flags = {
    '-u',
    '-l',
    '-s',
    '-k',
}

local change_casing = function ()
    vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, { 'jooohoho' })
    local i = vim.fn.inputlist({ 'Select casing:', '1. UpperCamelCase', '2. lowerCamelCase', '3. snake_case',  '4. kebab-case' })

    local flag = flags[i]

    if flag == nil then
        return
    end

    change_casing_int(flag)
end

return {
    change_casing = change_casing,
}
