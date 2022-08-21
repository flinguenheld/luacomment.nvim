G = {}
local A = vim.api


--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

G.characters = {lua={"--", "-- [[", "]]"},
                py={"#", '"""', '"""'},}

G.infos = {file_extension="",
           exist=false,
           characters_line = "",
           characters_open = "",
           characters_close = ""}

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

function G.get_infos()

    -- TODO : Simple or block ?
    local mode = 1

    G.infos.file_extension = string.match(A.nvim_buf_get_name(0), "^.+%.(.+)$")

    if G.characters[G.infos.file_extension] then

        G.infos.characters_line = G.characters[G.infos.file_extension][1]
        G.infos.characters_open = G.characters[G.infos.file_extension][2]
        G.infos.characters_close = G.characters[G.infos.file_extension][3]

        G.infos.exist = true
    else
        print(G.infos.file_extension .. " doesn't exist :(")
    end
end

--------------------------------------------------------------------------------------------------
-- Convert pattern to plain text
--------------------------------------------------------------------------------------------------
function G.pattern_to_plain(str)
    return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c) return "%" .. c end)
end
--------------------------------------------------------------------------------------------------
function G.is_empty_or_space(text)
    return #text == 0 or string.match(text, "%g") == nil
end


return G
