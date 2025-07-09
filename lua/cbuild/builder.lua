utils = require('cbuild.utils')

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
    utils.run_command(vim.fn.getcwd(), "python cbuild.py " .. M._targets[opt.target])
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
