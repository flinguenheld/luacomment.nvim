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
        infos.current_line = api.nvim_win_get_cursor(0)[1] - 1
    else
        print(infos.file_extension .. " n'existe pas :(")
    end
end

function invert(nb)

    get_infos()
    if infos.exist == true then

        local lines = api.nvim_buf_get_lines(0, infos.current_line, infos.current_line + nb, {})

        for index, text in pairs(lines) do

            if not _remove(text, infos.current_line + index - 1) then
                _add(text, infos.current_line + index - 1)
            end
        end
    end
end

function _remove(text, index_line)

    if #text > 0 then

        local start, stop = string.find(text, characters[infos.file_extension][1], 0, true)

        if start then
            if text:sub(stop+1, stop+1) == " " then
                stop = stop + 1
            end

            vim.api.nvim_buf_set_text(0, index_line, start-1, index_line, stop, {})

            return true
        end
    end
end

function _add(text, index_line)

    if #text > 0 then

        -- Find the first character (! lua is base 1 and vim base 0)
        local _, first = string.find(text, "^%s+%g")
        if not first then
            first = 1
        end

        vim.api.nvim_buf_set_text(0,
                                  index_line,
                                  first-1,
                                  index_line,
                                  first-1,
                                  {characters[infos.file_extension][1] .. " "})
    end
end


-- TODO : Table with simple and with complex comment
-- TODO : Command to change pattern (simple -> complex)
-- TODO : add with O or A

--vim.api.nvim_set_keymap('n', '<leader>aa', ':lua add() <cr>', {})
--vim.api.nvim_set_keymap('n', '<leader>ar', ':lua invert() <cr>', {})

vim.api.nvim_set_keymap('n', '<leader>ua', ':<C-U>echo"the cOunt is" .. v:count1<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>aa', ':<C-u>lua invert(vim.v.count1)<cr>', {})
