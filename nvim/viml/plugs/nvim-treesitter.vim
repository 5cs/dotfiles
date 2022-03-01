lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    'bash',
    'c',
    'cpp',
    'python',
    'go'
  },
  ignore_install = { 'javascript' },
  highlight = {
    enable = true,
    disable = { 'rust' },
    additional_vim_regex_highlighting = false,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      disable = {},
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ak'] = '@class.outer',
        ['ik'] = '@class.inner',
        ['ac'] = '@conditional.outer',
        ['ic'] = '@conditional.inner',
        ['ae'] = '@block.outer',
        ['ie'] = '@block.inner',
        ['iL'] = {
          c = '(function_definition) @function',
          cpp = '(function_definition) @function',
          python = '(function_definition) @function',
        },
      }
    },
  }
}
EOF
