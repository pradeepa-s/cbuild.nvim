local M = {}

M._terminal_win = nil

M._execute_cmd = function(cwd, cmd, curr_win)
    vim.fn.jobstart(cmd, {cwd = cwd, term=true})
    vim.api.nvim_set_current_win(curr_win)
end

function M.run_command(cwd, command)
    local curr_win = vim.api.nvim_get_current_win()
    if M._terminal_win and vim.api.nvim_buf_is_valid(M._terminal_win) then
        vim.api.nvim_buf_delete(M._terminal_win, {force = true})
    end

    vim.defer_fn(function()
        vim.cmd("new")
        M._terminal_win = vim.api.nvim_get_current_buf()
        vim.cmd('resize 20')
        vim.cmd.wincmd("J")
        M._execute_cmd(cwd, command, curr_win)
    end, 100)
end

return M
