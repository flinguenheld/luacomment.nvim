local G = require('luacomment.general')
local A = vim.api

W = {}

--------------------------------------------------------------------------------------------------
-- 
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


function W.right()

    G.get_infos()
    if G.infos.exist == true then

        local line = A.nvim_get_current_line()
        line = line .. " " .. G.infos.characters_line .. " "
        A.nvim_set_current_line(line)
        A.nvim_exec(":startinsert!", {})
    end
end


--------------------------------------------------------------------------------------------------
return W
