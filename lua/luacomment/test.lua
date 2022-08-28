local L = require('luacomment.line')
local ML = require('luacomment.multiline')
local EX = require('luacomment.extra')


local A = vim.api
local map = A.nvim_set_keymap

T = {}

function T.test()

    local TS = require('nvim-treesitter')
    local ts_utils = require("nvim-treesitter.ts_utils")
    local aaa = require('vim.treesitter.languagetree')
    -- print(aaa.lang())

    -- local cursor = A.nvim_win_get_cursor(0)
    -- local node = ts_utils.get_node_for_cursor(cursor)

    local node = ts_utils.get_node_at_cursor(0)

    print(type(node))
    print(ts_utils.node_length(node))
    print(aaa.lang(node))

    P(node)
end

return T
