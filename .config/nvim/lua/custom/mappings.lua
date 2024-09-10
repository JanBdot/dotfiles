local M = {}

M.setup = function()
        -- Define the keymappings
        local set_keymap = vim.api.nvim_set_keymap
        local opts = { noremap = true, silent = true }

        -- Existing keymaps
        set_keymap('n', '<C-h>', '<cmd>TmuxNavigateLeft<CR>', opts)
        set_keymap('n', '<C-l>', '<cmd>TmuxNavigateRight<CR>', opts)
        set_keymap('n', '<C-j>', '<cmd>TmuxNavigateDown<CR>', opts)
        set_keymap('n', '<C-k>', '<cmd>TmuxNavigateUp<CR>', opts)

        -- Normal mode toggle comment
        set_keymap('n', '<leader>#', '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', opts)

        -- Visual mode toggle comment
        set_keymap('v', '<leader>#', ':<C-U>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', opts)

        -- vertical split
        set_keymap('n', '<leader>pv', '<cmd>Vex<CR>', opts)

        -- grep
        set_keymap('n', '<leader>cn', '<cmd>cnext<CR>', opts)
        set_keymap('n', '<leader>cp', '<cmd>cprev<CR>', opts)
        set_keymap('n', '<leader>co', '<cmd>copen<CR>', opts)

        -- terminal mode
        set_keymap('t', '<Esc>', '<C-\\><C-n>', opts)
        set_keymap('n', '<leader>tw', '<cmd>terminal<CR>', opts)
        set_keymap('n', '<leader>tv', '<cmd>vertical :terminal<CR>', opts)

        -- cpp bindings
        -- Generate make files
        set_keymap('n', '<leader>mc', '<cmd>!cd ./build && cmake ..<CR>', opts)

        -- Build using CMake
        set_keymap('n', '<leader>mb', '<cmd>!cd ./build && make<CR>', opts)

        -- Run the executable (assuming it's named TodoManager)
        set_keymap('n', '<leader>mr', '<cmd>!cd ./build && ./TodoManager<CR>', opts)

        -- MD Preview
        set_keymap('n', '<leader>md', '<cmd>MarkdownPreview<CR>', opts)

        -- Basic Keymaps
        set_keymap('n', '<Space>', '<Nop>', opts)
        set_keymap('v', '<Space>', '<Nop>', opts)

        -- Remap for dealing with word wrap
        set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, silent = true, expr = true })
        set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, silent = true, expr = true })

        -- Highlight on yank
        local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
        vim.api.nvim_create_autocmd('TextYankPost', {
                callback = function()
                        vim.highlight.on_yank()
                end,
                group = highlight_group,
                pattern = '*',
        })

        -- Diagnostic keymaps
        set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>',
                { noremap = true, silent = true, desc = 'Go to previous diagnostic message' })
        set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>',
                { noremap = true, silent = true, desc = 'Go to next diagnostic message' })
        set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>',
                { noremap = true, silent = true, desc = 'Open floating diagnostic message' })
        set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>',
                { noremap = true, silent = true, desc = 'Open diagnostics list' })
end

return M
