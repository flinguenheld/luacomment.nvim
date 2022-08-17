local G = require('luacomment.general')
local A = vim.api

C = {}


--------------------------------------------------------------------------------------------------

-- [[ For visual mode, only char movement ]]
function C.add_or_remove(type)
    local start = A.nvim_buf_get_mark(0, '[')
    local finish = A.nvim_buf_get_mark(0, ']')

    if type == 'char' then
        C.add_or_remove_multiline(start, finish, "-- [[", "]]")
    end
end
--------------------------------------------------------------------------------------------------


function C.add_or_remove_multiline(from, to, characters_open, characters_close)

    local text = A.nvim_buf_get_text(0, from[1] - 1, from[2], to[1] - 1, to[2] + 1, {})
    local removed = false
    local with_space = 1

    ------------------------------------------------------------
    -- Remove --------------------------------------------------

    -- Check the end
    if string.sub(text[#text], - #characters_close) == characters_close then

        if string.sub(text[#text], - #characters_close - 1) == " " .. characters_close then
            with_space = 0
        end

        A.nvim_buf_set_text(0, to[1] - 1, to[2] - #characters_close + with_space, to[1] - 1, to[2] + 1, {})
        removed = true
    end

    -- Check the beginning
    with_space = 1
    if string.sub(text[1], 0, #characters_open) == characters_open then

        if string.sub(text[1], 0, #characters_open) == characters_open .. " " then
            with_space = 0
        end

        A.nvim_buf_set_text(0, from[1] - 1, from[2], from[1] - 1, from[2] + #characters_open + with_space, {})
        removed = true
    end

    ------------------------------------------------------------
    -- Add -----------------------------------------------------

    if removed == false then

        A.nvim_buf_set_text(0,
                            to[1] - 1,
                            to[2] + 1,
                            to[1] - 1,
                            to[2] + 1,
                            {" " .. characters_close})

        A.nvim_buf_set_text(0,
                            from[1] - 1,
                            from[2],
                            from[1] - 1,
                            from[2],
                            {characters_open .. " "})
    end
end

--------------------------------------------------------------------------------------------------
return C
