G = {}
local A = vim.api


--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
G.characters = {lua={"--", "--[[", "]]"},
                py={"#", '"""', '"""'},
                h={"//", "/*", "*/"},
                c={"//", "/*", "*/"},
                cpp={"//", "/*", "*/"},
                mk={"#", "", ""},
                sh={"#", "'", "'"},
}

G.infos = {file_extension="",
           exist=false,
           characters_line = "",
           characters_open = "",
           characters_close = ""
}

--------------------------------------------------------------------------------------------------
-- Get the file extension and fill the infos table
-- This table is used by all functions
--------------------------------------------------------------------------------------------------
function G.get_infos()

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
-- Laucher from the current line to nb lines
--      nb : number of lines
--      f : function lauched
--      ... : optional arguments like action's name
--------------------------------------------------------------------------------------------------
G.from_current = function(nb, f, ...)
    local current_row = A.nvim_win_get_cursor(0)[1] - 1
    f(current_row, current_row + nb, ...)
end

--------------------------------------------------------------------------------------------------
-- Get the position of the first letter
-- 0 if empty text
--------------------------------------------------------------------------------------------------
function G.get_indent(text)
    local _, e = text:find("^%s*")
    if e == nil then
        e = 0
    end
    return e
end

--------------------------------------------------------------------------------------------------
-- Convert pattern to plain text
--------------------------------------------------------------------------------------------------
function G.pattern_to_plain(str)
    return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c) return "%" .. c end)
end

--------------------------------------------------------------------------------------------------
-- Check if text is empty or contains only spaces
--------------------------------------------------------------------------------------------------
function G.is_empty_or_space(text)
    return #text == 0 or string.match(text, "%g") == nil
end


--------------------------------------------------------------------------------------------------
return G
