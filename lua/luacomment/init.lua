local L = require('luacomment.line')
local ML = require('luacomment.multiline')
local W = require('luacomment.write')
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

-- Standard (line)
map('n', '<leader>ca', ':<C-u>lua L.from_current(vim.v.count1, "add")<cr>', map_opt)
map('n', '<leader>cd', ':<C-u>lua L.from_current(vim.v.count1, "delete")<cr>', map_opt)
map('n', '<leader>ci', ':<C-u>lua L.from_current(vim.v.count1, "invert")<cr>', map_opt)

map('n', '<leader>cA', '<cmd>set opfunc=v:lua.L.add_from_selection<CR>g@', map_opt)
map('n', '<leader>cD', '<cmd>set opfunc=v:lua.L.delete_from_selection<CR>g@', map_opt)
map('n', '<leader>cI', '<cmd>set opfunc=v:lua.L.invert_from_selection<CR>g@', map_opt)

map('v', '<leader>ca', '<cmd>set opfunc=v:lua.L.add_from_selection<CR>g@', map_opt)
map('v', '<leader>cd', '<cmd>set opfunc=v:lua.L.delete_from_selection<CR>g@', map_opt)
map('v', '<leader>ci', '<cmd>set opfunc=v:lua.L.invert_from_selection<CR>g@', map_opt)

-- Multiline
map('n', '<leader>Ca', ':<C-u>lua ML.from_current(vim.v.count1, "add")<cr>', map_opt)
map('n', '<leader>Cd', ':<C-u>lua ML.from_current(vim.v.count1, "delete")<cr>', map_opt)

map('n', '<leader>CA', '<cmd>set opfunc=v:lua.ML.add_from_selection<CR>g@', map_opt)

map('v', '<leader>Ca', '<cmd>set opfunc=v:lua.ML.add_from_selection<CR>g@', map_opt)

-- Write
map('n', '<leader>cO', ':lua W.above(false)<CR>', map_opt)
map('n', '<leader>CO', ':lua W.above(true)<CR>', map_opt)

map('n', '<leader>co', ':lua W.under(false)<CR>', map_opt)
map('n', '<leader>Co', ':lua W.under(true)<CR>', map_opt)

-- Write (clean)
map('n', '<leader>ce', ':lua W.right()<CR>', map_opt)
map('n', '<leader>cc', ':<C-u>lua W.clean_from_current(vim.v.count1)<CR>', map_opt)
map('v', '<leader>cC', '<cmd>set opfunc=v:lua.W.clean_from_selection<CR>g@', map_opt)
map('n', '<leader>cC', '<cmd>set opfunc=v:lua.W.clean_from_selection<CR>g@', map_opt)
