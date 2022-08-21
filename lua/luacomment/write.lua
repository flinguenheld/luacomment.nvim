local G = require('luacomment.general')
local A = vim.api

W = {}

--------------------------------------------------------------------------------------------------
-- Add a new line with comments characters
-- multiline : bool to use simple or multi comments
--------------------------------------------------------------------------------------------------
function W.above(multiline)
    W._add_comment(multiline, true)
end

function W.under(multiline)
    
    W._add_comment(multiline, false)
end

function W._add_comment(multiline, above)

    G.get_infos()
    if G.infos.exist == true then

        local txt = ""
        local position_col = 0
        local command_insert = ':startinsert'

        if multiline then
            txt = G.infos.characters_open .. "  " .. G.infos.characters_close
            position_col = #G.infos.characters_open + 1
        else
            txt = G.infos.characters_line .. " "
            command_insert = command_insert .. '!'
        end

        local cursor = A.nvim_win_get_cursor(0)

        -- Far fetched but necessary to deal with indexes
        if above then
            A.nvim_buf_set_lines(0, cursor[1] - 1, cursor[1] - 1, 0, {txt})
            A.nvim_win_set_cursor(0, {cursor[1], position_col})
        else
            A.nvim_buf_set_lines(0, cursor[1], cursor[1], 0, {txt})
            A.nvim_win_set_cursor(0, {cursor[1] + 1, position_col})
        end

        A.nvim_exec(command_insert, {})
    end
end

--------------------------------------------------------------------------------------------------
-- Add a comment on the right
-- multiline : bool to use simple or multi comments
--------------------------------------------------------------------------------------------------
function W.right()

    G.get_infos()
    if G.infos.exist == true then

        local line = A.nvim_get_current_line()

        if G.is_empty_or_space(line) then
            line = G.infos.characters_line .. " "
        else
            line = line .. " " .. G.infos.characters_line .. " "
        end

        A.nvim_set_current_line(line)
        A.nvim_exec(":startinsert!", {})
    end
end

--------------------------------------------------------------------------------------------------
-- Clean right comments (on fact, clean standard comments)
-- Here lines in between marks, there from current to nb lines
--------------------------------------------------------------------------------------------------
function W.clean_from_selection(type)

    if type == 'line' or type == 'char' then
        local start = A.nvim_buf_get_mark(0, '[')
        local finish = A.nvim_buf_get_mark(0, ']')

        W._clean_right(start[1] - 1, finish[1])
    end
end

function W.clean_from_current(nb)
    local current_row = A.nvim_win_get_cursor(0)[1] - 1
    W._clean_right(current_row, current_row + nb)
end

function W._clean_right(from, to)

    G.get_infos()
    if G.infos.exist == true then

        -- Get all lines
        local lines = A.nvim_buf_get_lines(0, from, to, false)

        for index, line in ipairs(lines) do

            -- local s, _ = string.find(line, G.infos.characters_line, 0, true)
            local reverse_line = string.reverse(line)
            local s, e = string.find(reverse_line, G.infos.characters_line, 0, true)

            if s ~= nil then
                reverse_line = string.sub(reverse_line, e + 1)
                reverse_line = string.gsub(reverse_line, "^%s+", "")

                A.nvim_buf_set_lines(0, from + index - 1, from + index, false, {reverse_line:reverse()})
            end
        end
    end

end

--------------------------------------------------------------------------------------------------
return W
