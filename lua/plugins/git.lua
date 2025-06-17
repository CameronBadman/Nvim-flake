local keymap = vim.keymap.set

-- Helper function to check if we're in any git repository
local function is_git_repo()
    local git_dir = vim.fn.systemlist('git rev-parse --git-dir 2>/dev/null')[1]
    return git_dir ~= nil and git_dir ~= '' and vim.v.shell_error == 0
end

-- Helper function to check git repository permissions (for write operations only)
local function check_git_write_perms()
    if not is_git_repo() then
        return false, "Not a git repository"
    end
    
    -- Try a simple git command that requires write access
    local result = vim.fn.systemlist('git status --porcelain 2>/dev/null')
    if vim.v.shell_error ~= 0 then
        return false, "No write permissions or ownership issues"
    end
    
    return true, "OK"
end

-- Safe git command wrapper - tries read-only operations regardless of permissions
local function safe_git_cmd(cmd, fallback_cmd)
    return function()
        if not is_git_repo() then
            vim.notify('Not in a git repository', vim.log.levels.WARN)
            return
        end
        
        -- Try the main command first
        local success = pcall(vim.cmd, cmd)
        if not success and fallback_cmd then
            -- If it fails and we have a fallback, try that
            vim.notify('Trying fallback command...', vim.log.levels.INFO)
            pcall(vim.cmd, fallback_cmd)
        end
    end
end

-- Git commands that work in any repo (with fallbacks)
keymap('n', '<leader>gs', safe_git_cmd('Git'), { desc = 'Git status' })
keymap('n', '<leader>gb', safe_git_cmd('Git blame'), { desc = 'Git blame' })
keymap('n', '<leader>gl', safe_git_cmd('Git log --oneline -20'), { desc = 'Git log' })

-- Git diff with multiple fallback strategies
keymap('n', '<leader>gd', function()
    if not is_git_repo() then
        vim.notify('Not in a git repository', vim.log.levels.WARN)
        return
    end
    
    -- Try fugitive first
    local success = pcall(vim.cmd, 'Gdiff')
    if success then
        return
    end
    
    -- Fallback to system git diff in a new buffer
    local file_path = vim.fn.expand('%:p')
    local result = vim.fn.systemlist('git diff HEAD -- "' .. file_path .. '" 2>/dev/null')
    
    if vim.v.shell_error == 0 and #result > 0 then
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, result)
        vim.api.nvim_buf_set_option(buf, 'filetype', 'diff')
        vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
        vim.api.nvim_buf_set_name(buf, 'Git Diff: ' .. vim.fn.expand('%:t'))
        vim.cmd('split')
        vim.api.nvim_win_set_buf(0, buf)
    else
        vim.notify('No changes to show or unable to get diff', vim.log.levels.INFO)
    end
end, { desc = 'Git diff (with fallback)' })

-- Alternative system-only diff
keymap('n', '<leader>gD', function()
    if not is_git_repo() then
        vim.notify('Not in a git repository', vim.log.levels.WARN)
        return
    end
    
    local file_path = vim.fn.expand('%:p')
    local result = vim.fn.systemlist('git diff HEAD -- "' .. file_path .. '" 2>/dev/null')
    
    if vim.v.shell_error == 0 and #result > 0 then
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, result)
        vim.api.nvim_buf_set_option(buf, 'filetype', 'diff')
        vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
        vim.api.nvim_buf_set_name(buf, 'System Git Diff: ' .. vim.fn.expand('%:t'))
        vim.cmd('split')
        vim.api.nvim_win_set_buf(0, buf)
    else
        vim.notify('No changes to show', vim.log.levels.INFO)
    end
end, { desc = 'Git diff (system command)' })

-- Write operations (check permissions first)
keymap('n', '<leader>gc', function()
    local ok, msg = check_git_write_perms()
    if not ok then
        vim.notify('Cannot commit: ' .. msg, vim.log.levels.ERROR)
        vim.notify('Try: git commit (in terminal)', vim.log.levels.INFO)
        return
    end
    vim.cmd('Git commit')
end, { desc = 'Git commit' })

-- GitHub browsing (should work in any repo)
keymap('n', '<leader>gh', function()
    if not is_git_repo() then
        vim.notify('Not in a git repository', vim.log.levels.WARN)
        return
    end
    
    local origin = vim.fn.systemlist('git remote get-url origin 2>/dev/null')[1]
    if not origin or origin == '' then
        vim.notify('No origin remote found', vim.log.levels.WARN)
        return
    end
    
    local success = pcall(vim.cmd, 'GBrowse')
    if not success then
        vim.notify('GBrowse failed - check if vim-rhubarb is installed', vim.log.levels.ERROR)
    end
end, { desc = 'Open in GitHub' })

keymap('v', '<leader>gh', function()
    if not is_git_repo() then
        vim.notify('Not in a git repository', vim.log.levels.WARN)
        return
    end
    vim.cmd('GBrowse')
end, { desc = 'Open in GitHub' })

-- Safe commands with better error handling
vim.api.nvim_create_user_command('Gpush', function()
    local ok, msg = check_git_write_perms()
    if not ok then
        vim.notify('Cannot push: ' .. msg, vim.log.levels.ERROR)
        vim.notify('Try: git push (in terminal)', vim.log.levels.INFO)
        return
    end
    
    local success = pcall(vim.cmd, 'Git push')
    if not success then
        vim.notify('Push failed - try: git push (in terminal)', vim.log.levels.ERROR)
    end
end, {})

vim.api.nvim_create_user_command('Gpull', function()
    if not is_git_repo() then
        vim.notify('Not in a git repository', vim.log.levels.ERROR)
        return
    end
    
    -- Pull is usually a read operation that might work even without write perms
    local success = pcall(vim.cmd, 'Git pull')
    if not success then
        vim.notify('Pull failed - try: git pull (in terminal)', vim.log.levels.ERROR)
    end
end, {})

-- Command to fix common permission issues
vim.api.nvim_create_user_command('GitFixPerms', function()
    if not is_git_repo() then
        vim.notify('Not in a git repository', vim.log.levels.ERROR)
        return
    end
    
    local commands = {
        'git config --global --add safe.directory "' .. vim.fn.getcwd() .. '"',
        '# Alternative if above doesn\'t work:',
        'sudo chown -R $USER:$USER .git',
        'chmod -R u+rwX .git'
    }
    
    vim.notify('To fix git permissions, try these commands in terminal:', vim.log.levels.INFO)
    for _, cmd in ipairs(commands) do
        vim.notify('  ' .. cmd, vim.log.levels.INFO)
    end
end, { desc = 'Show commands to fix git permissions' })

-- Quick status check command
vim.api.nvim_create_user_command('GitStatus', function()
    if is_git_repo() then
        local ok, msg = check_git_write_perms()
        vim.notify('Git repo: ✓ | Write perms: ' .. (ok and '✓' or '✗ (' .. msg .. ')'), vim.log.levels.INFO)
    else
        vim.notify('Not in a git repository', vim.log.levels.WARN)
    end
end, { desc = 'Check git repository status' })

-- Configure Rhubarb
vim.g.github_enterprise_urls = {}
