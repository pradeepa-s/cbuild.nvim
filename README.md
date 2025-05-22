# cbuild.nvim

Neovim plugin to execute cbuild.py commands.

## Installation

### Lazy

```lua
require {
    "pradeepa-s/cbuild.nvim",
    config = function()
        require('builder')
    end
}
```

Or, with complete setup.

```lua
local opts = {
    quiet = false,
    targets = {
        ['A'] = 'config-app',
        ['a'] = 'build-app',
        ['U'] = 'config-unittest',
        ['u'] = 'build-unittest',
        ['B'] = 'config-bootstage1',
        ['b'] = 'build-bootstage1',
        ['C'] = 'config-bootstage2',
        ['c'] = 'build-bootstage2',
        ['D'] = 'config-bootstage2-unittest',
        ['d'] = 'build-bootstage2-unittest',
        ['S'] = 'config-app-sim',
        ['s'] = 'build-app-sim',
        ['R'] = 'config-appinram',
        ['r'] = 'build-appinram',
        ['s'] = 'run-stylecheck-cpp'
    },
	keys = {
		{'n', '<leader>rA', function() require("builder").run({ target = 'A' }) end, { desc = 'Run config-app' }},
		{'n', '<leader>ra', function() require("builder").run({ target = 'a' }) end, { desc = 'Run build-app' }},
		{'n', '<leader>rU', function() require("builder").run({ target = 'U' }) end, { desc = 'Run config-unittest' }},
		{'n', '<leader>ru', function() require("builder").run({ target = 'u' }) end, { desc = 'Run build-unittest' }},
		{'n', '<leader>rB', function() require("builder").run({ target = 'B' }) end, { desc = 'Run config-bootstage1' }},
		{'n', '<leader>rb', function() require("builder").run({ target = 'b' }) end, { desc = 'Run build-bootstage1' }},
		{'n', '<leader>rC', function() require("builder").run({ target = 'C' }) end, { desc = 'Run config-bootstage2' }},
		{'n', '<leader>rc', function() require("builder").run({ target = 'c' }) end, { desc = 'Run build-bootstage2' }},
		{'n', '<leader>rD', function() require("builder").run({ target = 'D' }) end, { desc = 'Run config-bootstage2-unittest' }},
		{'n', '<leader>rd', function() require("builder").run({ target = 'd' }) end, { desc = 'Run build-bootstage2-unittest' }},
		{'n', '<leader>rS', function() require("builder").run({ target = 'S' }) end, { desc = 'Run config-app-sim' }},
		{'n', '<leader>rs', function() require("builder").run({ target = 's' }) end, { desc = 'Run build-app-sim' }},
		{'n', '<leader>rR', function() require("builder").run({ target = 'R' }) end, { desc = 'Run config-appinram' }},
		{'n', '<leader>rr', function() require("builder").run({ target = 'r' }) end, { desc = 'Run build-appinram' }},
		{'n', '<leader>rs', function() require("builder").run({ target = 's' }) end, { desc = 'Run run-stylecheck-cpp' }}
	}
}

return {
	"pradeepa-s/cbuild.nvim",
	config = function()
		require("builder").setup(opts)
	end
}
```
