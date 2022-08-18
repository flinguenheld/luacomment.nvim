local G = require('luacomment.general')
local A = vim.api

ML = {}


--------------------------------------------------------------------------------------------------

-- [[ For visual mode, only char movement ]]
function ML.add_or_remove(type)
    local start = A.nvim_buf_get_mark(0, '[')
    local finish = A.nvim_buf_get_mark(0, ']')

    if type == 'char' then
        ML.add_or_remove_multiline(start, finish, "-- [[", "]]")
    end
end
--------------------------------------------------------------------------------------------------

function ML.by_line(from, to)

    -- REMOVE THIS ??
    G.get_infos()
    if G.infos.exist == true then

        -- Get all lines
        local lines = A.nvim_buf_get_lines(0, from, to, false)

        -- Are they all alredy commented ?
        -- First line with open
        for _, line in pairs(lines) do
            if _is_commented(line) then

                print("YEP")

            end
            
        end

        -- Last line with close


    end

    
end


-- [[ Check if the given text begins with comment characters ]]
local function _is_commented(text, characters)

    if #text == 0 or string.match(text, "%g") == nil then
        return nil
    elseif string.find(text, "^%s*[" .. characters .. "]") ~= nil then
        return true
    elseif string.find(text, "$[" .. characters .. "]") ~= nil then
        return true
    else
        return false
    end
end





function ML.add_or_remove_multiline(from, to, characters_open, characters_close)

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
return ML