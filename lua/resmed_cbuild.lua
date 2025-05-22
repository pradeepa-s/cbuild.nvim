local M = {}

M._quiet = false
M._targets = {}

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
end

-- Function to run the build command
-- @param opt: Options is a table with the following keys:
-- --   - target: As per the target name injected using Setup
function M.run(opt)
    -- Clear quickfix list
    vim.fn.setqflist({}, 'r')

    local line_n = 1

    local on_exit = function(_)
        line_n = 1
    end

    local on_stdout = function(_, data)
        vim.schedule(function()
            if data == nil then
                return
            end

            -- Replace \n\r with \n
            data = string.gsub(data, "\r\n", "\n") 

            -- Split text into lines and add lines to the qf_list
            local lines = vim.split(data, '\n')
            local qf_list = {}
            for _, line in ipairs(lines) do
                if line ~= "" then
                    table.insert(qf_list, {
                        text = line
                    })
                    line_n = line_n + 1
                end
            end

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

    -- Check whether opt.target is in registered targets
    if opt.target == nil or M._targets[opt.target] == nil then
        vim.notify("Invalid target: " .. tostring(opt.target), vim.log.levels.ERROR)
        return
    end

    vim.system({'python', 'cbuild.py', M._targets[opt.target]}, { text = true, stdout = on_stdout, cwd = vim.fn.getcwd()}, on_exit)
end

return M
