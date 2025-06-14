local M = {
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPost' },
  enabled = true,
  cond = function()
    for _, buf_id in ipairs(vim.api.nvim_list_bufs()) do
      local filename = vim.api.nvim_buf_get_name(buf_id)
      local lines = vim.api.nvim_buf_line_count(buf_id)
      if vim.fn.getfsize(filename) > 100 * 1024 and lines > 0 then
        return false
      end
    end

    return true
  end,
  build = function() vim.cmd("TSUpdate") end
}

M.dependencies = {
  'https://gitlab.com/HiPhish/rainbow-delimiters.nvim',
  'nvim-treesitter/nvim-treesitter-textobjects',
  'RRethy/nvim-treesitter-textsubjects', 'romgrk/nvim-treesitter-context',
  'JoosepAlviste/nvim-ts-context-commentstring'
}
M.init = function()
  local parser_config = require"nvim-treesitter.parsers".get_parser_configs()
  parser_config.typst = {
    install_info = {
      url = "https://github.com/TheOnlyMrCat/tree-sitter-typst",
      files = { "src/parser.c", "src/scanner.c" },
      generate_requires_npm = true,
      requires_generate_from_grammar = true
    },
    filetype = "typst"
  }
end

M.config = function()
  -- local enabled = function() return vim.api.nvim_buf_line_count(0) < 50000 end
  --
  local treesitter = require('nvim-treesitter.configs')

  treesitter.setup {
    ensure_installed = {
      'javascript', 'typescript', 'rust', 'lua', 'java', 'c', 'cpp', 'tsx',
      'vue', 'html', 'sql', 'proto', 'dockerfile', 'bash', 'json', 'yaml',
      'gitignore', 'jsonc', 'prisma', 'helm', 'gitcommit', 'diff', 'git_rebase', 'toml',
    },

    highlight = { enable = true, additional_vim_regex_highlighting = true },

    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = 'gn',
        node_incremental = 'gn',
        node_decremental = 'gr'
      }
    },

    rainbow = {
      enable = true,
      query = 'rainbow-delimiters',
      strategy = require('rainbow-delimiters').strategy.global
    },

    indent = { enable = true },

    context_commentstring = {
      enable = true,
      config = { fish = "# %s", scheme = ";; %s" }
    },

    autotag = { enable = true },

    textobjects = {
      select = {
        enable = true
        -- Commented becauser of https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/557
        -- keymaps = {
        --   ["af"] = "@function.outer",
        --   ["ac"] = "@class.outer",
        --   ["al"] = "@loop.outer",
        --   ["ab"] = "@block.outer",
        --   ["if"] = "@function.inner",
        --   ["ic"] = "@class.inner",
        --   ["il"] = "@loop.inner",
        --   ["ib"] = "@block.inner"
        -- }
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
        goto_previous_start = {
          ["[f"] = "@function.outer",
          ["[c"] = "@class.outer"
        },
        goto_previous_end = {
          ["[F"] = "@function.outer",
          ["[C"] = "@class.outer"
        }
      }
    },

    textsubjects = {
      enable = true,
      keymaps = { ['.'] = 'textsubjects-smart', [';'] = 'textsubjects-big' }
    }
  }

  local rainbow_delimiters = require 'rainbow-delimiters'
  vim.g.rainbow_delimiters = {
    strategy = { [''] = rainbow_delimiters.strategy['global'] },
    query = { [''] = 'rainbow-delimiters', tsx = 'rainbow-delimiters-react' },
    highlight = {
      'RainbowDelimiterRed', 'RainbowDelimiterYellow', 'RainbowDelimiterBlue',
      'RainbowDelimiterOrange', 'RainbowDelimiterGreen',
      'RainbowDelimiterViolet', 'RainbowDelimiterCyan'
    }
    -- blacklist = {'c', 'cpp', 'cc'},
  }
  vim.opt.foldmethod = 'expr'
  vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
end

return M
