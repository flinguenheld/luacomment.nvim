local G = require('luacomment.general')
local ML = require('luacomment.multiline')
local A = vim.api

L = {}

--------------------------------------------------------------------------------------------------
-- Action in a range (between marks)
--      type : directly given by opfunc
--------------------------------------------------------------------------------------------------
function L.add_from_selection(type)
    L._go_from_selection(type, 'add')
end

function L.delete_from_selection(type)
    L._go_from_selection(type, 'delete')
end

function L.invert_from_selection(type)
    L._go_from_selection(type, 'invert')
end

function L._go_from_selection(type, action)

    if type == 'line' or type == 'char' then
        local start = A.nvim_buf_get_mark(0, '[')
        local finish = A.nvim_buf_get_mark(0, ']')

        L.apply_action(start[1] - 1, finish[1], action)
    end
end

--------------------------------------------------------------------------------------------------
-- Get lines and loop
--      action : add, delete or invert
--------------------------------------------------------------------------------------------------
L.apply_action = function (from, to, action)

    G.get_infos()

    -- Get all lines
    local lines = A.nvim_buf_get_lines(0, from, to, false)

        for index, text in ipairs(lines) do
            if action == 'add' then
                L._add(text, from + index - 1, G.infos)
            elseif action == 'delete' then
                L._delete(text, from + index - 1, G.infos)
            elseif action == 'invert' then
                L._invert(text, from + index - 1, G.infos)
            end
        end
end

--------------------------------------------------------------------------------------------------
-- Invert the comment
--------------------------------------------------------------------------------------------------
function L._invert(text, index_row, infos)

    if L._is_commented(text, infos) then
        L._delete(text, index_row, infos)
    else
        L._add(text, index_row, infos)
    end
end

-- Check if the given text begins with characters
function L._is_commented(text, infos)

    -- Multiline only for this extension ?
    if infos.characters_line == "" then
        if string.find(text, "^%s*" .. G.pattern_to_plain(infos.characters_open) .. "") ~= nil then
            if string.find(text, "%s*$" .. G.pattern_to_plain(infos.characters_close) .. "") ~= nil then
                return true
            end
        end
    else
        if string.find(text, "^%s*" .. G.pattern_to_plain(infos.characters_line) .. "") ~= nil then
            return true
        end
    end

    return false
end

--------------------------------------------------------------------------------------------------
-- Delete the first comment characters on the line
--------------------------------------------------------------------------------------------------
function L._delete(text, index_row, infos)

    if G.is_empty_or_space(text) == false then

        -- Multiline only for this extension ?
        if infos.characters_line == "" then
            ML.delete_multiline_char_for_the_line(index_row, infos.characters_open, infos.characters_close)

        else
            local column_start, column_stop = string.find(text, infos.characters_line, 0, true)

            if column_start then
                if text:sub(column_stop+1, column_stop+1) == " " then
                    column_stop = column_stop + 1
                end

                A.nvim_buf_set_text(0, index_row, column_start-1, index_row, column_stop, {})

                return true
            end
        end
    end
end

--------------------------------------------------------------------------------------------------
-- Add comment characters on the line
-- Avoid empty lines
-- No check, just add
--------------------------------------------------------------------------------------------------
function L._add(text, index_row, infos)

    if G.is_empty_or_space(text) == false then

        -- Multiline only for this extension ?
        if infos.characters_line == "" then
            ML.add_multiline_char_for_the_line(index_row, infos.characters_open, infos.characters_close)

        else
            local indent = G.get_indent(text)
            A.nvim_buf_set_text(0,
                                index_row,
                                indent,
                                index_row,
                                indent,
                                {infos.characters_line .. " "})
        end
    end
end


--------------------------------------------------------------------------------------------------
return L
