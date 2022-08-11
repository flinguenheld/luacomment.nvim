local api = vim.api

local characters = {lua={"--", "-- [[", "]] --"},
                    py={"#", '"""', '"""'},}

local infos = {file_extension="",
               exist=false,
               current_line=0,
               starting_text=""}


local function get_infos()

    -- TODO : Simple or block ?
    local mode = 1

    infos.file_extension = string.match(api.nvim_buf_get_name(0), "^.+%.(.+)$")
    
    if characters[infos.file_extension] then
        infos.exist = true

        local length = #characters[infos.file_extension][mode]
        infos.current_line = api.nvim_win_get_cursor(0)[1] - 1

        infos.starting_text = api.nvim_buf_get_text(0, infos.current_line, 0, infos.current_line, length, {})

    else
        print(infos.file_extension .. " n'existe pas :(")
    end
end

function invert()

    get_infos()

    if infos.exist == true then

        local text = api.nvim_get_current_line()

        if not _remove(text) then
            _add(text)
        end
    end
end

function _remove(text)

    if #text > 0 then

        local start, stop = string.find(text, characters[infos.file_extension][1], 0, true)

        if start then
            if text:sub(stop+1, stop+1) == " " then
                stop = stop + 1
            end

            vim.api.nvim_buf_set_text(0, infos.current_line, start-1, infos.current_line, stop, {})

            return true
        end
    end
end

function _add(text)

    if #text > 0 then

        -- Find the first character (! lua is base 1 and vim base 0)
        local _, first = string.find(text, "^%s+%g")
        if not first then
            first = 1
        end

        vim.api.nvim_buf_set_text(0,
                                  infos.current_line,
                                  first-1,
                                  infos.current_line,
                                  first-1,
                                  {characters[infos.file_extension][1] .. " "})
    end
end


-- TODO : Table with simple and with complex comment
-- TODO : Command to change pattern (simple -> complex)
-- TODO : add with O or A


vim.api.nvim_set_keymap('n', '<leader>aa', ':lua add() <cr>', {})
vim.api.nvim_set_keymap('n', '<leader>ar', ':lua invert() <cr>', {})
