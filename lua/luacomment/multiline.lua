local G = require('luacomment.general')
local A = vim.api

ML = {}

--------------------------------------------------------------------------------------------------
-- Action from the current line
--      nb : number of lines
--      action : add or delete
--------------------------------------------------------------------------------------------------
function ML.from_current(nb, action)
        local current_row = A.nvim_win_get_cursor(0)[1] - 1
        ML._apply_action(current_row, current_row + nb - 1, action)
end

--------------------------------------------------------------------------------------------------
-- Get lines and loop
--      action : add or delete
--------------------------------------------------------------------------------------------------
function ML._apply_action(from, to, action)

    G.get_infos()
    if G.infos.exist == true then

        if action == 'add' then
            ML._add(from, to, G.characters[G.infos.file_extension][2], G.characters[G.infos.file_extension][3])
        elseif action == 'delete' then
            ML._delete(from, G.characters[G.infos.file_extension][2], G.characters[G.infos.file_extension][3])

        end

    end
end

--------------------------------------------------------------------------------------------------
-- Add Multiline comments by lines
--------------------------------------------------------------------------------------------------
function ML._add(from, to, characters_open, characters_close)

    -- The index -1 doesn't work :(
    -- end
    local line = A.nvim_buf_get_lines(0, to, to + 1, {})[1]
    local space = " "

    if G.is_empty_or_space(line) then
        space = ""
    end

    A.nvim_buf_set_text(0, to, #line, to, #line, {space .. characters_close})

    -- start
    line = A.nvim_buf_get_lines(0, from, from + 1, {})[1]
    space = " "
    if G.is_empty_or_space(line) then
        space = ""
    end

    A.nvim_buf_set_text(0, from, 0, from, 0, {characters_open .. space})
end


function ML._delete(from, characters_open, characters_close)


    -- First open characters
    lines = A.nvim_buf_get_lines(0, 0, from + 1, {})

    for i = #lines, 1, -1 do

        local s, e = string.find(lines[i], characters_open, 0, true)
        if s ~= nil then

            -- Space ?
            if lines[i]:sub(e + 1, e + 1) == " " then
                e = e + 1
            end

            if ML._delete_end(from, characters_close) then
                A.nvim_buf_set_text(0, i - 1, s - 1, i - 1, e, {})
                return
            end
        end
    end
    print("Nothing to delete")
end

function ML._delete_end(from, characters_close)

    lines = A.nvim_buf_get_lines(0, from, -1, {})

    for index, line in ipairs(lines) do

        local s, e = string.find(line, characters_close, 0, true)

        if s ~= nil then

             -- Space ?
            print(line:sub(s - 1, s - 1))
            if line:sub(s - 1, s - 1) == " " then
                s = s - 1
            end

            A.nvim_buf_set_text(0, from + index - 1, s - 1, from + index - 1, e, {})
            return true
        end
    end


    
end




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
            if L._is_commented(line) then

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
