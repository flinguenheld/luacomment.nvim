local L = require('luacomment.line')
local ML = require('luacomment.multiline')
local EX = require('luacomment.extra')
local T = require('luacomment.test')

local A = vim.api
local map = A.nvim_set_keymap


-- TODO : repeat ??
-- TODO : embedded languages ?


--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
-- local map_opt = { noremap = true, silent = true }
-- local map_opt = { noremap = true}
local map_opt = {}

-- A.nvim_set_keymap('n', '<leader>ua', ':<C-U>echo"the cOunt is" .. v:count1<cr>', map_opt)

-- Standard (line)
map('n', '<leader>ca', ':<C-u>lua G.from_current(vim.v.count1, L.apply_action, "add")<cr>', map_opt)
map('n', '<leader>cd', ':<C-u>lua G.from_current(vim.v.count1, L.apply_action, "delete")<cr>', map_opt)
map('n', '<leader>ci', ':<C-u>lua G.from_current(vim.v.count1, L.apply_action, "invert")<cr>', map_opt)

map('n', '<leader>cA', '<cmd>set opfunc=v:lua.L.add_from_selection<CR>g@', map_opt)
map('n', '<leader>cD', '<cmd>set opfunc=v:lua.L.delete_from_selection<CR>g@', map_opt)
map('n', '<leader>cI', '<cmd>set opfunc=v:lua.L.invert_from_selection<CR>g@', map_opt)

map('v', '<leader>ca', '<cmd>set opfunc=v:lua.L.add_from_selection<CR>g@', map_opt)
map('v', '<leader>cd', '<cmd>set opfunc=v:lua.L.delete_from_selection<CR>g@', map_opt)
map('v', '<leader>ci', '<cmd>set opfunc=v:lua.L.invert_from_selection<CR>g@', map_opt)

-- Multiline
map('n', '<leader>Ca', ':<C-u>lua G.from_current(vim.v.count1, ML.apply_action, "add")<cr>', map_opt)
map('n', '<leader>Cd', ':<C-u>lua G.from_current(vim.v.count1, ML.apply_action, "delete")<cr>', map_opt)

map('n', '<leader>CA', '<cmd>set opfunc=v:lua.ML.add_from_selection<CR>g@', map_opt)

map('v', '<leader>Ca', '<cmd>set opfunc=v:lua.ML.add_from_selection<CR>g@', map_opt)

-- Extra
map('n', '<leader>cO', ':lua EX.above(false)<CR>', map_opt)
map('n', '<leader>CO', ':lua EX.above(true)<CR>', map_opt)

map('n', '<leader>co', ':lua EX.under(false)<CR>', map_opt)
map('n', '<leader>Co', ':lua EX.under(true)<CR>', map_opt)

map('n', '<leader>cea', ':lua EX.right()<CR>', map_opt)

map('n', '<leader>cer', ':lua EX.replace_right()<CR>', map_opt)
map('n', '<leader>Cer', ':lua EX.replace_multiline()<CR>', map_opt)

map('n', '<leader>ced', ':<C-u>lua G.from_current(vim.v.count1, EX.delete_right, true)<CR>', map_opt)
map('v', '<leader>ced', '<cmd>set opfunc=v:lua.EX.clean_from_selection<CR>g@', map_opt)
map('n', '<leader>ceD', '<cmd>set opfunc=v:lua.EX.clean_from_selection<CR>g@', map_opt)

-- Test
map('n', '<leader>ct', ':lua T.test()<CR>', map_opt)
