G = {}
local A = vim.api


--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

G.characters = {lua={"--", "-- [[", "]]"},
                py={"#", '"""', '"""'},}

G.infos = {file_extension="",
           exist=false,
           current_line=0}

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

function G.get_infos()

    -- TODO : Simple or block ?
    local mode = 1

    G.infos.file_extension = string.match(A.nvim_buf_get_name(0), "^.+%.(.+)$")

    if G.characters[G.infos.file_extension] then
        G.infos.exist = true
        -- infos.current_line = api.nvim_win_get_cursor(0)[1] - 1
    else
        print(G.infos.file_extension .. " n'existe pas :(")
    end
end

--------------------------------------------------------------------------------------------------
return G
