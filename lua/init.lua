local resmed_build = require("cbuild.resmed_cbuild")

resmed_build.setup({
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
    }
})

-- Key mappings for each target <leader>r followed by mapping
vim.keymap.set('n', '<leader>rA', function() resmed_build.run({ target = 'A' }) end, { desc = 'Run config-app' })
vim.keymap.set('n', '<leader>ra', function() resmed_build.run({ target = 'a' }) end, { desc = 'Run build-app' })
vim.keymap.set('n', '<leader>rU', function() resmed_build.run({ target = 'U' }) end, { desc = 'Run config-unittest' })
vim.keymap.set('n', '<leader>ru', function() resmed_build.run({ target = 'u' }) end, { desc = 'Run build-unittest' })
vim.keymap.set('n', '<leader>rB', function() resmed_build.run({ target = 'B' }) end, { desc = 'Run config-bootstage1' })
vim.keymap.set('n', '<leader>rb', function() resmed_build.run({ target = 'b' }) end, { desc = 'Run build-bootstage1' })
vim.keymap.set('n', '<leader>rC', function() resmed_build.run({ target = 'C' }) end, { desc = 'Run config-bootstage2' })
vim.keymap.set('n', '<leader>rc', function() resmed_build.run({ target = 'c' }) end, { desc = 'Run build-bootstage2' })
vim.keymap.set('n', '<leader>rD', function() resmed_build.run({ target = 'D' }) end, { desc = 'Run config-bootstage2-unittest' })
vim.keymap.set('n', '<leader>rd', function() resmed_build.run({ target = 'd' }) end, { desc = 'Run build-bootstage2-unittest' })
vim.keymap.set('n', '<leader>rS', function() resmed_build.run({ target = 'S' }) end, { desc = 'Run config-app-sim' })
vim.keymap.set('n', '<leader>rs', function() resmed_build.run({ target = 's' }) end, { desc = 'Run build-app-sim' })
vim.keymap.set('n', '<leader>rR', function() resmed_build.run({ target = 'R' }) end, { desc = 'Run config-appinram' })
vim.keymap.set('n', '<leader>rr', function() resmed_build.run({ target = 'r' }) end, { desc = 'Run build-appinram' })
vim.keymap.set('n', '<leader>rs', function() resmed_build.run({ target = 's' }) end, { desc = 'Run run-stylecheck-cpp' })


