local G = require('luacomment.general')
local A = vim.api

C = {}


--------------------------------------------------------------------------------------------------

-- [[ For motions after command, only char movement ]]
function C.add_or_remove(type)
    local start = A.nvim_buf_get_mark(0, '[')
    local finish = A.nvim_buf_get_mark(0, ']')

    if type == 'char' then

        C.add_pouet(start, finish, "-- [[", "]]")

    end
end
--------------------------------------------------------------------------------------------------

function pattern_to_plain(str)
    return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c) return "%" .. c end)
end

function C.add_pouet(from, to, characters_open, characters_close)

    local text = A.nvim_buf_get_text(0, from[1] - 1, from[2], to[1] - 1, to[2] + 1, {})
    local removed = false

    -- Check the end
    if string.sub(text[#text], - #characters_close) == characters_close then

        if string.sub(text[#text], - #characters_close - 1) == " " .. characters_close then
            A.nvim_buf_set_text(0, to[1] - 1, to[2] - #characters_close, to[1] - 1, to[2] + 1, {})
        else
            A.nvim_buf_set_text(0, to[1] - 1, to[2] - #characters_close + 1, to[1] - 1, to[2] + 1, {})
        end
        removed = true
    end

    -- Check the beginning
    if string.sub(text[1], 0, #characters_open) == characters_open then

        if string.sub(text[1], 0, #characters_open) == characters_open .. " " then
            A.nvim_buf_set_text(0, from[1] - 1, from[2], from[1] - 1, from[2] + #characters_open + 1, {})
        else
            A.nvim_buf_set_text(0, from[1] - 1, from[2], from[1] - 1, from[2] + #characters_open, {})
        end
        removed = true
    end



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




return C
