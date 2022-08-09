local api = vim.api


function p()
    print('Mange ton chien')

    local file_extension = string.match(api.nvim_buf_get_name(0), "^.+(%..+)$")

    local current_line = api.nvim_win_get_cursor(0)[1] - 1
    local starting_text = api.nvim_buf_get_text(0, current_line, 0, current_line, 2, {})
    P(starting_text)


    print(api.nvim_buf_get_name(0))

    --vim.api.nvim_buf_set_text(0, 0, 0, 0, 0, {"#"})
end


-- TODO : Function to add at the beginning
-- TODO : Function to invert !
-- TODO : Table with simple and with complex comment
-- TODO : Command to change pattern (simple -> complex)
-- TODO : add with O or A


vim.api.nvim_set_keymap('n', '<leader>a', ':lua p() <cr>', {})
