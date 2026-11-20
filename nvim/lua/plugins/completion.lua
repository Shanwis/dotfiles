return {
  {
    'L3MON4D3/LuaSnip',
    version = '2.*',
    build = 'make install_jsregexp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    event = 'InsertEnter',
    config = function()
      require('luasnip').setup {}
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },

  {
    'saghen/blink.cmp',
    version = '1.*',
    event = 'InsertEnter',
    config = function()
      require('blink.cmp').setup {
        keymap = {
          -- 'default' is closest to built-in completion semantics:
          --   <c-y> accept, <c-n>/<c-p> select, <c-e> hide, <c-space> open docs
          preset = 'default',
        },

        appearance = {
          nerd_font_variant = 'mono',
        },

        completion = {
          documentation = { auto_show = false, auto_show_delay_ms = 500 },
        },

        sources = {
          default = { 'lsp', 'path', 'snippets' },
        },

        snippets = { preset = 'luasnip' },

        fuzzy = { implementation = 'lua' },

        signature = { enabled = true },
      }
    end,
  },
}
