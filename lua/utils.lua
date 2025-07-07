local M = {}

M._terminal_win = nil
M._terminal_chan_id = nil

function M.run_command(cwd, command)
    local curr_win = vim.api.nvim_get_current_win()
    if M._terminal_win and vim.api.nvim_win_is_valid(M._terminal_win) then
        -- If the terminal window is valid, send the command to it
        if M._terminal_chan_id then
            vim.fn.chansend(M._terminal_chan_id, {"cd " .. cwd, ""})
            vim.fn.chansend(M._terminal_chan_id, {command, ""})
            vim.api.nvim_set_current_win(M._terminal_win)
            vim.cmd("normal! G")
            vim.api.nvim_set_current_win(curr_win)
        else
            print("Terminal channel is not open.")
        end
    else
        -- Open a new terminal split
        vim.cmd("split | terminal")
        M._terminal_win = vim.api.nvim_get_current_win()
        M._terminal_chan_id = vim.b.terminal_job_id
        -- Send the cd and command to the terminal
        vim.cmd.wincmd("J")
        vim.cmd('resize 20')
        vim.fn.chansend(M._terminal_chan_id, {"cd " .. cwd, ""})
        vim.fn.chansend(M._terminal_chan_id, {command, ""})
        vim.cmd("normal! G")
        -- Reselect the previous buffer
        vim.api.nvim_set_current_win(curr_win)
    end
end

return M
