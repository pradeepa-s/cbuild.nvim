local M = {}

M._terminal_win = nil
M._last_cmd = nil

M._get_errors = function()
            -- Process the buffer line by line and look for errors
    local lines = vim.api.nvim_buf_get_lines(M._terminal_win, 0, -1, false)
    local errors = {}

    for _, line in ipairs(lines) do
        if string.match(line, ":%d+:%d+:.+error:") then
            table.insert(errors, line)
        elseif string.match(line, "%(%d+%):.+error") then
            table.insert(errors, line)
        elseif string.match(line, "%(%d+%):.+note:") then
            table.insert(errors, line)
        end
    end
    return errors
end

M._populate_quickfix = function(errors)
    -- Add the errors to the quickfix list
    if #errors > 0 then
        vim.fn.setqflist({}, 'r', {title = 'Compile errors ' .. M._last_cmd, lines = errors})
        vim.cmd('copen')
    end
end

M._execute_cmd = function(cwd, cmd, curr_win)
    M._last_cmd = cmd
    vim.fn.jobstart(cmd, {cwd = cwd, term=true,
        on_exit = function()
            local errors = M._get_errors()
            M._populate_quickfix(errors)
        end})
    vim.api.nvim_set_current_win(curr_win)
end

function M.run_command(cwd, command)
    local curr_win = vim.api.nvim_get_current_win()
    if M._terminal_win and vim.api.nvim_buf_is_valid(M._terminal_win) then
        vim.api.nvim_buf_delete(M._terminal_win, {force = true})
    end

    vim.cmd("cclose")
    vim.cmd("new")
    vim.defer_fn(function()
        M._terminal_win = vim.api.nvim_get_current_buf()
        vim.cmd.wincmd("J")
        vim.cmd('resize 20')
        vim.cmd("normal! G")
        M._execute_cmd(cwd, command, curr_win)
    end, 100)
end

M.get_test_name = function()
    -- Search backwards for a line starting with the word "class" and ending with "(BDDTest):"
    -- ncbW: do [n]ot move cursor, accept match at [c]ursor, search [b]ackwards, no [W]rap around
    local val = vim.fn.search('^class .*(BDDTest):$', 'ncbW')
    -- Extract the class name from the line
    if val > 0 then
        local line = vim.fn.getline(val)
        local class_name = line:match('^class (.*)%(BDDTest%):$')
        if class_name then
            return class_name
        end
    end
    print("Test case not found.")
    return nil
end

M.generate_test_command = function(test_name)
    if test_name then
        local command = "python fgtest.py -s " .. test_name
        return command
    end
end

return M
