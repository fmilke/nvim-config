local M = {}

local get_int_fn_name = function(fn)
    for k, v in pairs(M) do
        if v == fn then
            return k
        end
    end

    return nil
end

local get_text = function(s_start, s_end)
    local n_lines = vim.fn.abs(s_end[2] - s_start[2]) + 1
    local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)

    lines[1] = string.sub(lines[1], s_start[3], -1)
    if n_lines == 1 then
        lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
    else
        lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
    end

    return lines
end

local get_vrange = function()
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

local to_interspersed_case = function(lines, delim)
    local result = {}

    local state = {
        within_word = false,
    }

    for _, line in ipairs(lines) do
        local chars = {}

        for c in line:gmatch(".") do
            if string.match(c, "%a") then
                if c:upper() == c and state.within_word then
                    table.insert(chars, delim)
                    state.within_word = false
                else
                    state.within_word = true
                end
                table.insert(chars, c:lower())
            elseif c == "_" or c == "-" then
                state.within_word = false
                table.insert(chars, delim)
            else
                state.within_word = false
                table.insert(chars, c)
            end
        end

        table.insert(result, table.concat(chars))
    end

    return result
end

local to_camel_case = function(lines, lowercase)
    local result = {}

    local state = {
        recase = true,
        first_in_word = true,
    }

    for _, v in ipairs(lines) do
        local chars = {}
        for c in v:gmatch(".") do
            if c == "_" or c == "-" then
                state.recase = true
                goto continue
            end

            if string.match(c, "%a") then
                if state.recase then
                    if state.first_in_word and lowercase then
                        table.insert(chars, c:lower())
                    else
                        table.insert(chars, c:upper())
                    end

                    state.first_in_word = false
                    state.recase = false
                    goto continue
                end
            else
                state.recase = true
                state.first_in_word = true
            end

            table.insert(chars, c)
            ::continue::
        end

        state.recase = true
        state.first_in_word = true

        table.insert(result, table.concat(chars))
    end

    return result
end

M.to_lower_camel_case = function(lines)
    return to_camel_case(lines, true)
end

M.to_upper_camel_case = function(lines)
    return to_camel_case(lines, false)
end

M.to_snake_case = function(lines)
    return to_interspersed_case(lines, '_')
end

M.to_kebab_case = function(lines)
    return to_interspersed_case(lines, '-')
end

M.change_casing = function()
    local i = vim.fn.inputlist({
        'Select casing:',
        '1. UpperCamelCase',
        '2. lowerCamelCase',
        '3. snake_case',
        '4. kebab-case'
    })

    local transformation = nil
    if i == 1 then
        transformation = M.to_upper_camel_case
    elseif i == 2 then
        transformation = M.to_lower_camel_case
    elseif i == 3 then
        transformation = M.to_snake_case
    elseif i == 4 then
        transformation = M.to_kebab_case
    else
        return
    end

    local s_start, s_end = get_vrange()
    local sel = get_text(s_start, s_end)

    local lines = transformation(sel)

    vim.api.nvim_buf_set_text(
        s_start[1],
        s_start[2] - 1,
        s_start[3] - 1,
        s_end[2] - 1,
        s_end[3] - 1,
        lines
    )
end


local assert_test = function(fn, input_lines, expected_lines)
    local fn_name = get_int_fn_name(fn) or 'unknown'

    for i, expected in ipairs(expected_lines) do
        local input = input_lines[i]
        local r = fn({ input })[1] or '<nil>'
        if r ~= expected then
            return "Failed " ..
                fn_name ..
                " line (" .. tostring(i) .. ") - expected " .. input .. " to be " .. expected .. " but was " .. r
        end
    end

    return nil
end

M.assert_tests = function()
    local lines = {
        "   kebab-case",
        "kebab-case  kebab-case",
        "   snake_case",
        "snake_case  snake_case",
        "   lowerCamelCase",
        "lowerCamelCase  lowerCamelCase",
        "   UpperCamelCase",
        "UpperCamelCase  UpperCamelCase",
    }

    return assert_test(
            M.to_upper_camel_case,
            lines,
            {
                "   KebabCase",
                "KebabCase  KebabCase",
                "   SnakeCase",
                "SnakeCase  SnakeCase",
                "   LowerCamelCase",
                "LowerCamelCase  LowerCamelCase",
                "   UpperCamelCase",
                "UpperCamelCase  UpperCamelCase",
            }
        )
        or
        assert_test(
            M.to_lower_camel_case,
            lines,
            {
                "   kebabCase",
                "kebabCase  kebabCase",
                "   snakeCase",
                "snakeCase  snakeCase",
                "   lowerCamelCase",
                "lowerCamelCase  lowerCamelCase",
                "   upperCamelCase",
                "upperCamelCase  upperCamelCase",
            }
        )
        or
        assert_test(
            M.to_kebab_case,
            lines,
            {
                "   kebab-case",
                "kebab-case  kebab-case",
                "   snake-case",
                "snake-case  snake-case",
                "   lower-camel-case",
                "lower-camel-case  lower-camel-case",
                "   upper-camel-case",
                "upper-camel-case  upper-camel-case",
            }
        )
        or
        assert_test(
            M.to_snake_case,
            lines,
            {
                "   kebab_case",
                "kebab_case  kebab_case",
                "   snake_case",
                "snake_case  snake_case",
                "   lower_camel_case",
                "lower_camel_case  lower_camel_case",
                "   upper_camel_case",
                "upper_camel_case  upper_camel_case",
            }
        )
        or
        "All tests passed"
end

return M
