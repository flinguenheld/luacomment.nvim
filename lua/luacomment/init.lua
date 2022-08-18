local L = require('luacomment.line')
local ML = require('luacomment.multiline')
local A = vim.api
local map = A.nvim_set_keymap


-- TODO : characters list ? where read it ?
-- TODO : file names ?
-- TODO : add with O or A
-- TODO : Block ??
-- TODO : repeat ??




--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
-- local map_opt = { noremap = true, silent = true }
-- local map_opt = { noremap = true}
local map_opt = {}

-- A.nvim_set_keymap('n', '<leader>ua', ':<C-U>echo"the cOunt is" .. v:count1<cr>', map_opt)

map('n', '<leader>ca', ':<C-u>lua L.from_current(vim.v.count1, "add")<cr>', map_opt)
map('n', '<leader>cd', ':<C-u>lua L.from_current(vim.v.count1, "delete")<cr>', map_opt)
map('n', '<leader>ci', ':<C-u>lua L.from_current(vim.v.count1, "invert")<cr>', map_opt)

map('n', '<leader>cA', '<cmd>set opfunc=v:lua.L.add_from_selection<CR>g@', map_opt)
map('n', '<leader>cD', '<cmd>set opfunc=v:lua.L.delete_from_selection<CR>g@', map_opt)
map('n', '<leader>cI', '<cmd>set opfunc=v:lua.L.invert_from_selection<CR>g@', map_opt)

map('v', '<leader>ca', '<cmd>set opfunc=v:lua.L.add_from_selection<CR>g@', map_opt)
map('v', '<leader>cd', '<cmd>set opfunc=v:lua.L.delete_from_selection<CR>g@', map_opt)
map('v', '<leader>ci', '<cmd>set opfunc=v:lua.L.invert_from_selection<CR>g@', map_opt)


map('n', '<leader>cC', ':<C-u>lua ML.by_line(vim.v.count1)<cr>', map_opt)

map('n', '<leader>C', '<cmd>set opfunc=v:lua.ML.add_or_remove<CR>g@', map_opt)
map('v', '<leader>C', '<cmd>set opfunc=v:lua.ML.add_or_remove<CR>g@', map_opt)

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
function test(type)

    local start = A.nvim_buf_get_mark(0, '[')
    local finish = A.nvim_buf_get_mark(0, ']')

    if type == 'line' then
        print("start : " .. start[1] .. "  -  " .. finish[1])


    elseif type == 'char' then

    elseif type == 'block' then
        print("ok mon block")
    end
end
