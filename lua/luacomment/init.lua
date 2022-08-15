local L = require('luacomment.line')
local A = vim.api


-- TODO : Table with simple and with complex comment
-- TODO : Command to change pattern (simple -> complex)
-- TODO : add with O or A
-- TODO : Block ??

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
-- local map_opt = { noremap = true, silent = true }
-- local map_opt = { noremap = true}
local map_opt = {}

-- A.nvim_set_keymap('n', '<leader>ua', ':<C-U>echo"the cOunt is" .. v:count1<cr>', map_opt)

A.nvim_set_keymap('n', '<leader>cc', ':<C-u>lua L.add_or_remove_from_current(vim.v.count1)<cr>', map_opt)
A.nvim_set_keymap('n', '<leader>ci', ':<C-u>lua L.invert(vim.v.count1)<cr>', map_opt)

A.nvim_set_keymap("n", "<leader>c", "<cmd>set opfunc=v:lua.L.add_or_remove<CR>g@", map_opt)

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
