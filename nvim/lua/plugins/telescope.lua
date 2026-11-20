return {
  { 'nvim-lua/plenary.nvim', lazy = true },

  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'nvim-telescope/telescope-ui-select.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function() return vim.fn.executable 'make' == 1 end,
      },
    },
    init = function()
      -- Registered at startup so LSP buffers always get these maps,
      -- even before Telescope itself has been loaded.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
        callback = function(event)
          local builtin = function() return require 'telescope.builtin' end
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
          end
          map('grr', function() builtin().lsp_references() end, '[G]oto [R]eferences')
          map('gri', function() builtin().lsp_implementations() end, '[G]oto [I]mplementation')
          map('grd', function() builtin().lsp_definitions() end, '[G]oto [D]efinition')
          map('grt', function() builtin().lsp_type_definitions() end, '[G]oto [T]ype Definition')
          map('gO', function() builtin().lsp_document_symbols() end, 'Open Document Symbols')
          map('gW', function() builtin().lsp_dynamic_workspace_symbols() end, 'Open Workspace Symbols')
        end,
      })
    end,
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = require('telescope.themes').get_dropdown(),
        },
      }
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
    end,
    keys = {
      { '<leader>sh', function() require('telescope.builtin').help_tags() end, desc = '[S]earch [H]elp' },
      { '<leader>sk', function() require('telescope.builtin').keymaps() end, desc = '[S]earch [K]eymaps' },
      { '<leader>sf', function() require('telescope.builtin').find_files() end, desc = '[S]earch [F]iles' },
      { '<leader>ss', function() require('telescope.builtin').builtin() end, desc = '[S]earch [S]elect Telescope' },
      { '<leader>sw', function() require('telescope.builtin').grep_string() end, mode = { 'n', 'v' }, desc = '[S]earch current [W]ord' },
      { '<leader>sg', function() require('telescope.builtin').live_grep() end, desc = '[S]earch by [G]rep' },
      { '<leader>sd', function() require('telescope.builtin').diagnostics() end, desc = '[S]earch [D]iagnostics' },
      { '<leader>sr', function() require('telescope.builtin').resume() end, desc = '[S]earch [R]esume' },
      { '<leader>s.', function() require('telescope.builtin').oldfiles() end, desc = '[S]earch Recent Files ("." for repeat)' },
      { '<leader>sc', function() require('telescope.builtin').commands() end, desc = '[S]earch [C]ommands' },
      { '<leader><leader>', function() require('telescope.builtin').buffers() end, desc = '[ ] Find existing buffers' },
      {
        '<leader>/',
        function()
          require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end,
        desc = '[/] Fuzzily search in current buffer',
      },
      {
        '<leader>s/',
        function()
          require('telescope.builtin').live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end,
        desc = '[S]earch [/] in Open Files',
      },
      {
        '<leader>sn',
        function() require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' } end,
        desc = '[S]earch [N]eovim files',
      },
    },
  },
}
