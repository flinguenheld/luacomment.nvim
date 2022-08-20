local G = require('luacomment.general')
local A = vim.api

ML = {}


--------------------------------------------------------------------------------------------------
-- Action in a range (between marks)
--      type : directly given by opfunc
--------------------------------------------------------------------------------------------------
function ML.add_from_selection(type)

    local start = A.nvim_buf_get_mark(0, '[')
    local finish = A.nvim_buf_get_mark(0, ']')

    if type == 'char' then
        ML._apply_action(start, finish, 'add_char')

    -- Simplify the action by lines
    elseif type == 'line' then
        ML._apply_action(start[1] - 1, finish[1] - 1, 'add')
    end
end

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
        elseif action == 'add_char' then
            ML.add_multiline_char(from, to, G.characters[G.infos.file_extension][2], G.characters[G.infos.file_extension][3])
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


--------------------------------------------------------------------------------------------------
-- Take the lines before the cursor.
-- Find the first characters_open
-- Then take and loop in the lines after the cursor
-- If there is a characters_close, delete it and the characters_open
--------------------------------------------------------------------------------------------------
function ML._delete(from, characters_open, characters_close)

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
-- Add multiline comment in the given boundaries
-- Specific to selection by char
--------------------------------------------------------------------------------------------------
function ML.add_multiline_char(from, to, characters_open, characters_close)

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
--------------------------------------------------------------------------------------------------
return ML
