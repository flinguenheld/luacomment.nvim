local api = vim.api

local characters = {lua={"--", "-- [[", "]] --"},
                    py={"#", '"""', '"""'},}

local infos = {file_extension="",
               exist=false,
               current_line=0}


local function get_infos()

    -- TODO : Simple or block ?
    local mode = 1

    infos.file_extension = string.match(api.nvim_buf_get_name(0), "^.+%.(.+)$")

    if characters[infos.file_extension] then
        infos.exist = true
        -- infos.current_line = api.nvim_win_get_cursor(0)[1] - 1
    else
        print(infos.file_extension .. " n'existe pas :(")
    end
end

-- [[ For motions after command, only line movement ]]
function add_or_remove(type)

    if type == 'line' then
        local start = api.nvim_buf_get_mark(0, '[')
        local finish = api.nvim_buf_get_mark(0, ']')

        _add_or_remove(start[1] - 1, finish[1])
    end
end

-- [[ For motions before command ]]
function add_or_remove_from_current(nb)

        local current_row = api.nvim_win_get_cursor(0)[1] - 1
        _add_or_remove(current_row, current_row + nb)
end

-- [[ Comment or uncomment all lines between from and to ]]
function _add_or_remove(from, to)

    get_infos()
    if infos.exist == true then

        -- Get all lines
        local lines = api.nvim_buf_get_lines(0, from, to, false)

        -- Are they all already commented ?
        local comment_them_all = false
        for _, text in pairs(lines) do

            if is_commented(text, characters[infos.file_extension][1]) == false then
                comment_them_all = true
                break
            end
        end

        -- Uncomment only if all lines are comment
        if comment_them_all then
            for index, text in ipairs(lines) do
                _add_on_line(text, from + index - 1, characters[infos.file_extension][1])
            end
        else
            for index, text in ipairs(lines) do
                _remove_on_line(text, from + index - 1, characters[infos.file_extension][1])
            end
        end
    end
end

-- [[ Check if the given text begins with comment characters ]]
function is_commented(text, characters)

    if #text == 0 or string.match(text, "%g") == nil then
        return nil
    elseif string.find(text, "^%s*[" .. characters .. "]") ~= nil then
        return true
    else
        return false
    end
end

function invert_from_current(nb)

    get_infos()
    if infos.exist == true then
        local current_line = api.nvim_win_get_cursor(0)[1] - 1

        _invert_on_lines(current_line, current_line + nb, characters[infos.file_extension][1])
    end
end

function _invert_on_lines(start, stop, characters)

    local lines = api.nvim_buf_get_lines(0, start, stop, {})

    for index, text in pairs(lines) do

        if not _remove_on_line(text, start + index, characters) then
            _add_on_line(text, start + index, characters)
        end
    end

end



-- [[ Remove the first characters on the given row ]]
function _remove_on_line(text, index_row, characters)

    if #text > 0 then

        local column_start, column_stop = string.find(text, characters, 0, true)

        if column_start then
            if text:sub(column_stop+1, column_stop+1) == " " then
                column_stop = column_stop + 1
            end

            vim.api.nvim_buf_set_text(0, index_row, column_start-1, index_row, column_stop, {})

            return true
        end
    end
end

-- [[ Add characters on the given row ]]
function _add_on_line(text, index_row, characters)

    -- Avoid empty and only space lines
    if #text > 0 and string.match(text, "%g") ~= nil then

        -- Find the first character (! lua is base 1 and vim base 0)
        local _, first = string.find(text, "^%s+%g")
        if not first then
            first = 1
        end

        vim.api.nvim_buf_set_text(0,
                                  index_row,
                                  first-1,
                                  index_row,
                                  first-1,
                                  {characters .. " "})
    end
end

-- TODO : Table with simple and with complex comment
-- TODO : Command to change pattern (simple -> complex)
-- TODO : add with O or A

-- local map_opt = { noremap = true, silent = true }
-- local map_opt = { noremap = true}
local map_opt = {}

-- api.nvim_set_keymap('n', '<leader>ua', ':<C-U>echo"the cOunt is" .. v:count1<cr>', map_opt)
api.nvim_set_keymap('n', '<leader>cc', ':<C-u>lua add_or_remove_from_current(vim.v.count1)<cr>', map_opt)
api.nvim_set_keymap('n', '<leader>ci', ':<C-u>lua invert(vim.v.count1)<cr>', map_opt)


api.nvim_set_keymap("n", "<leader>c", "<cmd>set opfunc=v:lua.add_or_remove<CR>g@", map_opt)

-- 
function test(type)

    local start = api.nvim_buf_get_mark(0, '[')
    local finish = api.nvim_buf_get_mark(0, ']')

    if type == 'line' then
        print("start : " .. start[1] .. "  -  " .. finish[1])


    elseif type == 'char' then

    elseif type == 'block' then
        print("ok mon block")
    end
end
