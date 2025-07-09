local M = {}

M._quiet = false
M._targets = {}
M._concat_errors = true

local set_default_targets = function()
    M._targets = {
        ['A'] = 'config-app',
        ['a'] = 'build-app',
        ['U'] = 'config-unittest',
        ['u'] = 'build-unittest',
    }
end

-- Function to setup the module
-- @param opt: Options is a table with the following keys:
-- -- --   - quiet: If true, suppresses output to the command lines
-- -- --   - targets: Mapping of run target to their cbuild name.
-- -- -- --     Ex: { '1' = 'config-app', '2' = 'build-app', 'b' = 'build-unittest' ... }
function M.setup(opt)
    if opt == nil then
        set_default_targets()
        return
    end

    if opt.quiet ~= nil then
        M._quiet = opt.quiet
    end

    if opt.targets ~= nil then
        M._targets = {}
        for k, v in pairs(opt.targets) do
            M._targets[k] = v
        end
    else
        set_default_targets()
    end

	if opt.keys ~= nil then
		for _, map in pairs(opt.keys) do
			vim.keymap.set(map[1], map[2], map[3], map[4])
		end
	end
end

-- Function to run the build command
-- @param opt: Options is a table with the following keys:
-- --   - target: As per the target name injected using Setup
function M.run(opt)
    if M._busy then
        return
    end

    -- Clear quickfix list
    vim.fn.setqflist({}, 'r')

    local stdout_lines = {}
    local stdout_errors = {}
    local stdout_all_errors = {}

    local exit = function(_, _, _)
        if #stdout_all_errors > 0 then
            vim.schedule(function()
                local qf_list = {}
                for _, line in ipairs(stdout_all_errors) do
                    table.insert(qf_list, {
                        text = line
                    })
                end

                stdout_all_errors = {}

                -- TODO: Set title
                vim.fn.setqflist(qf_list, 'a');

                if M._quiet == false then
                    -- Get current focus window
                    local win = vim.api.nvim_get_current_win()
                    vim.cmd('copen')
                    vim.cmd('clast')
                    -- Restore focus to the original window
                    vim.api.nvim_set_current_win(win)
                end
            end)
        end
        M._busy = false
    end

    local stdout_err = ''
    local stderr = function(_, error, _)
        for _, e in pairs(error) do
            -- Split lines
            if e == '' then
                local lines = vim.split(stdout_err, '\r')
                for _, l in pairs(lines) do
                    if l ~= '' then
                        if M._concat_errors then
                            table.insert(stdout_all_errors, l)
                        end
                        table.insert(stdout_errors, l)
                    end
                end
                stdout_err = ''
            else
                stdout_err = stdout_err .. e
            end
        end
    end

    local stdout_line = ''
    local stdout = function(_, data, _)
        for _, d in pairs(data) do
            -- Split lines
            if d == '' then
                local lines = vim.split(stdout_line, '\r')
                for _, l in pairs(lines) do
                    if l ~= '' then
                        table.insert(stdout_lines, l)
                    end
                end
                stdout_line = ''
            else
                stdout_line = stdout_line .. d
            end
        end

        if #stdout_lines > 0 then
            vim.schedule(function()
                local qf_list = {}
                for _, line in ipairs(stdout_lines) do
                    table.insert(qf_list, {
                        text = line
                    })
                end

                stdout_lines = {}

                -- TODO: Set title
                vim.fn.setqflist(qf_list, 'a');

                if M._quiet == false then
                    -- Get current focus window
                    local win = vim.api.nvim_get_current_win()
                    vim.cmd('copen')
                    vim.cmd('clast')
                    -- Restore focus to the original window
                    vim.api.nvim_set_current_win(win)
                end
            end)
        end
    end

    -- Check whether opt.target is in registered targets
    if opt.target == nil or M._targets[opt.target] == nil then
        vim.notify("Invalid target: " .. tostring(opt.target), vim.log.levels.ERROR)
        return
    end

    vim.fn.jobstart({'python', 'cbuild.py', M._targets[opt.target]},
        {
            on_stdout = stdout,
            on_stderr = stderr,
            on_exit = exit,
            cwd = vim.fn.getcwd()
        }
    )

    M._busy = true
end

-- local opt = {
--     quiet = false,
--     targets = {
--         ['1'] = 'build'
--     }
-- }

-- M.setup(opt)
-- M.run({target = '1'})

return M
