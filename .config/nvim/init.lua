do
    vim.loader.enable()

    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '

    vim.g.have_nerd_font = false

    vim.o.number = true
    vim.o.relativenumber = true

    vim.o.mouse = 'a'

    vim.o.showmode = false

    vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

    vim.o.breakindent = true

    vim.o.undofile = true

    vim.o.ignorecase = true
    vim.o.smartcase = true

    vim.o.signcolumn = 'yes'

    vim.o.updatetime = 50

    vim.o.timeoutlen = 300

    vim.o.splitright = true
    vim.o.splitbelow = true

    vim.o.list = true
    vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

    vim.o.inccommand = 'split'

    -- Show which line your cursor is on
    vim.o.cursorline = true

    vim.o.scrolloff = 8

    vim.o.confirm = false

    vim.o.termguicolors = true
    vim.o.guicursor = ""
    vim.o.tabstop = 4
    vim.o.softtabstop = 4
    vim.o.shiftwidth = 4
    vim.o.expandtab = true

    vim.o.smartindent = true
    vim.o.wrap = false
    vim.o.swapfile = false
    vim.o.backup = false
    vim.o.hlsearch = false
    vim.o.incsearch = true

end

do
    vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
    vim.keymap.set('i', '<C-c>', '<Esc>')
    vim.keymap.set('n', '<PageDown>', '<PageDown>zz')
    vim.keymap.set('n', '<PageUp>', '<PageUp>zz')

    vim.diagnostic.config {
        update_in_insert = false,
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = { min = vim.diagnostic.severity.WARN } },

        -- Can switch between these as you prefer
        virtual_text = true, -- Text shows up at the end of the line
        virtual_lines = false, -- Text shows up underneath the line, with virtual lines

        -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
        jump = {
            on_jump = function(_, bufnr)
                vim.diagnostic.open_float {
                    bufnr = bufnr,
                    scope = 'cursor',
                    focus = false,
                }
            end,
        },
    }

    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

    vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

    vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
    vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
    vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
    vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

    vim.api.nvim_create_autocmd('TextYankPost', {
        desc = 'Highlight when yanking (copying) text',
        group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
        callback = function() vim.hl.on_yank() end,
    })
end

do
    local function run_build(name, cmd, cwd)
        local result = vim.system(cmd, { cwd = cwd }):wait()
        if result.code ~= 0 then
            local stderr = result.stderr or ''
            local stdout = result.stdout or ''
            local output = stderr ~= '' and stderr or stdout
            if output == '' then output = 'No output from build command.' end
            vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
        end
    end

    vim.api.nvim_create_autocmd('PackChanged', {
        callback = function(ev)
            local name = ev.data.spec.name
            local kind = ev.data.kind
            if kind ~= 'install' and kind ~= 'update' then return end

            if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
                run_build(name, { 'make' }, ev.data.path)
                return
            end

            if name == 'LuaSnip' then
                if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then run_build(name, { 'make', 'install_jsregexp' }, ev.data.path) end
                return
            end

            if name == 'nvim-treesitter' then
                if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
                vim.cmd 'TSUpdate'
                return
            end
        end,
    })
end

local function gh(repo) return 'https://github.com/' .. repo end

do
    vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
    require('guess-indent').setup {}

    -- Here is a more advanced configuration example that passes options to `gitsigns.nvim`
    --
    -- See `:help gitsigns` to understand what each configuration key does.
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
    require('gitsigns').setup {
        signs = {
            add = { text = '+' }, ---@diagnostic disable-line: missing-fields
            change = { text = '~' }, ---@diagnostic disable-line: missing-fields
            delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
            topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
            changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
        },
    }

    -- Highlight todo, notes, etc in comments
    vim.pack.add { gh 'folke/todo-comments.nvim' }
    require('todo-comments').setup { signs = false }

    vim.pack.add { gh 'nvim-mini/mini.nvim' }

    if vim.g.have_nerd_font then
        require('mini.icons').setup()
        MiniIcons.mock_nvim_web_devicons()
    end

    require('mini.ai').setup {
        mappings = {
            around_next = 'aa',
            inside_next = 'ii',
        },
        n_lines = 500,
    }

    require('mini.surround').setup()
end

do
    ---@type (string|vim.pack.Spec)[]
    local telescope_plugins = {
        gh 'nvim-lua/plenary.nvim',
        gh 'nvim-telescope/telescope.nvim',
        gh 'nvim-telescope/telescope-ui-select.nvim',
    }
    if vim.fn.executable 'make' == 1 then table.insert(telescope_plugins, gh 'nvim-telescope/telescope-fzf-native.nvim') end

    vim.pack.add(telescope_plugins)

    require('telescope').setup {
        extensions = {
            ['ui-select'] = { require('telescope.themes').get_dropdown() },
        },
    }

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
        callback = function(event)
            local buf = event.buf

            vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
            vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })
            vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
            vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })
            vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })
            vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
        end,
    })

    vim.keymap.set('n', '<leader>/', function()
                                         builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                                             winblend = 10,
                                             previewer = false,
                                         })
                                     end, { desc = '[/] Fuzzily search in current buffer' })

    vim.keymap.set(
        'n',
        '<leader>s/',
        function()
            builtin.live_grep {
                grep_open_files = true,
                prompt_title = 'Live Grep in Open Files',
            }
        end,
        { desc = '[S]earch [/] in Open Files' }
    )

    vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config', follow = true } end, { desc = '[S]earch [N]eovim files' })
end

do
    vim.pack.add { gh 'stevearc/conform.nvim' }
    require('conform').setup {
        notify_on_error = false,
        format_on_save = function(bufnr)
            local enabled_filetypes = {
                -- lua = true,
                -- python = true,
            }
            if enabled_filetypes[vim.bo[bufnr].filetype] then
                return { timeout_ms = 500 }
            else
                return nil
            end
        end,
        default_format_opts = {
            lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
        },
        -- You can also specify external formatters in here.
        formatters_by_ft = {
            -- rust = { 'rustfmt' },
            -- Conform can also run multiple formatters sequentially
            -- python = { "isort", "black" },
            --
            -- You can use 'stop_after_first' to run the first available formatter from the list
            -- javascript = { "prettierd", "prettier", stop_after_first = true },
        },
    }

    vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })
end
