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
        if multiline then
            txt = G.infos.characters_open .. "  " .. G.infos.characters_close
        else
            txt = G.infos.characters_line .. " "
        end

        -- Use exec to automatically indent (better solution ?)
        -- And add a space to create the line (erased at the next step)
        if above then
            A.nvim_exec('normal O ', {})
        else
            A.nvim_exec('normal o ', {})
        end

        -- Add characters
        local cursor = A.nvim_win_get_cursor(0)
        local line = A.nvim_get_current_line()
        A.nvim_buf_set_text(0, cursor[1] - 1, #line - 1, cursor[1] - 1, #line, {txt})

        -- Replace the cursor
        if multiline then
            line = A.nvim_get_current_line()
            A.nvim_win_set_cursor(0, {cursor[1], #line - #G.infos.characters_close - 1})
            A.nvim_exec('startinsert', {})
        else
            A.nvim_exec('startinsert!', {})
        end
    end
end

--------------------------------------------------------------------------------------------------
-- Add a comment on the right
--------------------------------------------------------------------------------------------------
function W.right()

    G.get_infos()
    if G.infos.exist == true then

        local cursor = A.nvim_win_get_cursor(0)
        local line = A.nvim_get_current_line()

        local txt = G.infos.characters_line .. " "
        if G.is_empty_or_space(line) == false and line:sub(#line) ~= " " then
            txt = " " .. txt
        end

        A.nvim_buf_set_text(0, cursor[1] - 1, #line, cursor[1] - 1, #line, {txt})
        A.nvim_exec(":startinsert!", {})
    end
end

--------------------------------------------------------------------------------------------------
-- Delete the comment on right (if exists) and create a new one
--------------------------------------------------------------------------------------------------
function W.replace_right()
    G.from_current(1, W.delete_right)
    W.right()
end

--------------------------------------------------------------------------------------------------
-- Launch 'delete_right' with a ligne selection
--------------------------------------------------------------------------------------------------
function W.delete_right_from_selection(type)

    if type == 'line' or type == 'char' then
        local start = A.nvim_buf_get_mark(0, '[')
        local finish = A.nvim_buf_get_mark(0, ']')

        W.delete_right(start[1] - 1, finish[1])
    end
end

--------------------------------------------------------------------------------------------------
-- Delete right comments (text and comments characters) in the range given
-- Also delete the line if the line is empty after cleaning
--------------------------------------------------------------------------------------------------
W.delete_right = function(from, to)

    G.get_infos()
    if G.infos.exist == true then

        -- Get all lines
        local lines = A.nvim_buf_get_lines(0, from, to, false)
        local done = false

        local index = 1
        for _, line in pairs(lines) do

            -- local s, _ = string.find(line, G.infos.characters_line, 0, true)
            local reverse_line = string.reverse(line)
            local s, e = string.find(reverse_line, G.infos.characters_line, 0, true)

            if s ~= nil then
                reverse_line = string.sub(reverse_line, e + 1)
                reverse_line = string.gsub(reverse_line, "^%s+", "")

                -- Remove line if empty
                if G.is_empty_or_space(reverse_line) then
                    A.nvim_buf_set_lines(0, from + index - 1, from + index, false, {})
                    index = index - 1
                else
                    A.nvim_buf_set_lines(0, from + index - 1, from + index, false, {reverse_line:reverse()})
                end

                done = true
            end

            index = index + 1
        end

        if done ~= true then
            print("Nothing to clean")
        end
    end

end

--------------------------------------------------------------------------------------------------
return W
