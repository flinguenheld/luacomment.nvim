local G = require('luacomment.general')
local A = vim.api

L = {}

--------------------------------------------------------------------------------------------------
-- Action in a range (between marks)
--      type : directly given by opfunc
--------------------------------------------------------------------------------------------------
function L.add_from_selection(type)
    _go_from_selection(type, 'add')
end

function L.delete_from_selection(type)
    _go_from_selection(type, 'delete')
end

function L.invert_from_selection(type)
    _go_from_selection(type, 'invert')
end

function _go_from_selection(type, action)

    if type == 'line' or type == 'char' then
        local start = A.nvim_buf_get_mark(0, '[')
        local finish = A.nvim_buf_get_mark(0, ']')

        L._apply_action(start[1] - 1, finish[1], action)
    end
end

--------------------------------------------------------------------------------------------------
-- Action from the current line
--      nb : number of lines
--      action : add or delete
--------------------------------------------------------------------------------------------------
function L.from_current(nb, action)
        local current_row = A.nvim_win_get_cursor(0)[1] - 1
        L._apply_action(current_row, current_row + nb, action)
end

--------------------------------------------------------------------------------------------------
-- Get lines and loop
--      action : add or delete
--------------------------------------------------------------------------------------------------
function L._apply_action(from, to, action)

    G.get_infos()
    if G.infos.exist == true then

        -- Get all lines
        local lines = A.nvim_buf_get_lines(0, from, to, false)

            for index, text in ipairs(lines) do
                if action == 'add' then
                    L._add(text, from + index - 1, G.characters[G.infos.file_extension][1])
                elseif action == 'delete' then
                    L._delete(text, from + index - 1, G.characters[G.infos.file_extension][1])
                elseif action == 'invert' then
                    L._invert(text, from + index - 1, G.characters[G.infos.file_extension][1])
                end
            end
    end
end

--------------------------------------------------------------------------------------------------
-- Invert the comment
--------------------------------------------------------------------------------------------------
function L._invert(text, index_row, characters)

    if L._is_commented(text, characters) then
        L._delete(text, index_row, characters)
    else
        L._add(text, index_row, characters)
    end
end

-- Check if the given text begins with characters
function L._is_commented(text, characters)

    if string.find(text, "^%s*" .. G.pattern_to_plain(characters) .. "") ~= nil then
        return true
    else
        return false
    end
end

--------------------------------------------------------------------------------------------------
-- delete the first comment characters on the line
--------------------------------------------------------------------------------------------------
function L._delete(text, index_row, characters)

    if #text > 0 then

        local column_start, column_stop = string.find(text, characters, 0, true)

        if column_start then
            if text:sub(column_stop+1, column_stop+1) == " " then
                column_stop = column_stop + 1
            end

            A.nvim_buf_set_text(0, index_row, column_start-1, index_row, column_stop, {})

            return true
        end
    end
end

--------------------------------------------------------------------------------------------------
-- Add comment characters on the line
-- Avoid empty lines
-- No check, just add
--------------------------------------------------------------------------------------------------
function L._add(text, index_row, characters)

    -- Avoid empty and only space lines
    if #text > 0 and string.match(text, "%g") ~= nil then

        -- Find the first character (! lua is base 1 and vim base 0)
        local _, first = string.find(text, "^%s+%g")
        if not first then
            first = 1
        end

        A.nvim_buf_set_text(0,
                            index_row,
                            first-1,
                            index_row,
                            first-1,
                            {characters .. " "})
    end
end

--------------------------------------------------------------------------------------------------
return L
