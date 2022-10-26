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
        ML.apply_action(start, finish, 'add_char')

    -- Simplify the action by lines
    elseif type == 'line' then
        ML.apply_action(start[1] - 1, finish[1], 'add')
    end
end

--------------------------------------------------------------------------------------------------
-- Get lines and loop
--      action : add or delete
--------------------------------------------------------------------------------------------------
ML.apply_action = function(from, to, action)

    G.get_infos()
    if G.infos.exist == true then

        if action == 'add' then
            ML._add(from, to - 1, G.infos.characters_open, G.infos.characters_close)
        elseif action == 'add_char' then
            ML._add_multiline_char(from, to, G.infos.characters_open, G.infos.characters_close)
        elseif action == 'delete' then
            ML._delete(from, G.infos.characters_open, G.infos.characters_close)
        end
    end
end

--------------------------------------------------------------------------------------------------
-- Add a multiline comments for a group of lines
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
    space = " "

    -- start
    line = A.nvim_buf_get_lines(0, from, from + 1, {})[1]
    local indent = G.get_indent(line)

    A.nvim_buf_set_text(0, from, indent, from, indent, {characters_open .. space})
end

--------------------------------------------------------------------------------------------------
-- Take the lines before the cursor.
-- Find the first characters_open and delete it.
-- Then take and loop in the lines after the cursor to find and delete it.
-- No check, simple.
--------------------------------------------------------------------------------------------------
function ML._delete(from, characters_open, characters_close)

    local lines = A.nvim_buf_get_lines(0, 0, from + 1, {})

    for i = #lines, 1, -1 do

        local s, e = string.find(lines[i], characters_open, 0, true)
        if s ~= nil then

            -- Space ?
            if lines[i]:sub(e + 1, e + 1) == " " then
                e = e + 1
            end

            -- Delete now to prevent conflict with characters_close
            A.nvim_buf_set_text(0, i - 1, s - 1, i - 1, e, {})

            ML._delete_end(from, characters_close)
        end
    end
end

function ML._delete_end(from, characters_close)

    local lines = A.nvim_buf_get_lines(0, from, -1, {})

    for index, line in ipairs(lines) do

        local s, e = string.find(line, characters_close, 0, true)

        if s ~= nil then

             -- Space ?
            if line:sub(s - 1, s - 1) == " " then
                s = s - 1
            end

            A.nvim_buf_set_text(0, from + index - 1, s - 1, from + index - 1, e, {})
        end
    end
end

--------------------------------------------------------------------------------------------------
-- Add multiline comment in the given boundaries
-- Specific to selection by char
--------------------------------------------------------------------------------------------------
function ML._add_multiline_char(from, to, characters_open, characters_close)

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
-- MULTILINE AS LINE
-- Useful for type files which only support multiline comments like html
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
-- Add multiline comment around the given row
--------------------------------------------------------------------------------------------------
function ML.add_multiline_char_for_the_line(index_row, characters_open, characters_close)

    local line = A.nvim_buf_get_lines(0, index_row, index_row + 1, {})[1]

    local from = {index_row + 1 , G.get_indent(line)}
    local to = {index_row + 1, #line -1}

    ML._add_multiline_char(from, to, characters_open, characters_close)
end

--------------------------------------------------------------------------------------------------
-- Delete multiline around the given row
--------------------------------------------------------------------------------------------------
function ML.delete_multiline_char_for_the_line(index_row, characters_open, characters_close)
    local line = A.nvim_buf_get_lines(0, index_row, index_row + 1, {})[1]


        local s_open, e_open = string.find(line, characters_open, 0, true)
        if s_open ~= nil then

            -- Space ?
            if line:sub(e_open + 1, e_open + 1) == " " then
                e_open = e_open + 1
            end

            local s_close, e_close = string.find(line, characters_close, 0, true)
            if s_close ~= nil then

                 -- Space ?
                if line:sub(s_close - 1, s_close - 1) == " " then
                    s_close = s_close - 1
                end

                A.nvim_buf_set_text(0, index_row, s_close - 1, index_row, e_close, {})
                A.nvim_buf_set_text(0, index_row, s_open - 1, index_row, e_open, {})
            end
        end
end


--------------------------------------------------------------------------------------------------
return ML
