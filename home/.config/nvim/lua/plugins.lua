local M = {
  { 'echasnovski/mini.icons', version = false },
  { 'echasnovski/mini.nvim', version = false }, { 'kevinhwang91/nvim-bqf' },
  { 'akinsho/git-conflict.nvim', version = "*", config = true },
  { "https://github.com/mfussenegger/nvim-dap" },
  { "https://github.com/mfussenegger/nvim-jdtls" },
  { "IndianBoy42/tree-sitter-just" },
  { "NoahTheDuke/vim-just", ft = { "just" } },
  { "https://github.com/roxma/nvim-yarp" }, {
    'numToStr/Comment.nvim',
    keys = {
      { "<C-/>", mode = { "n", "v" } } -- Specify the keys for NORMAL and VISUAL modes
    },
    config = function()
      require('Comment').setup({
        ---LHS of toggle mappings in NORMAL mode
        toggler = {
          ---Line-comment toggle keymap
          line = '<C-/>',
          ---Block-comment toggle keymap
          block = '<C-/>'
        },
        ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
          ---Line-comment keymap
          line = '<C-/>',
          ---Block-comment keymap
          block = '<C-/>'
        },
        ---Enable keybindings
        ---NOTE: If given `false` then the plugin won't create any mappings
        mappings = {
          ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
          basic = true,
          ---Extra mapping; `gco`, `gcO`, `gcA`
          extra = false
        }
      })
    end
  }, { 'tzachar/highlight-undo.nvim', opts = {} }, {
    'lewis6991/gitsigns.nvim',
    branch = 'main',
    lazy = false,

    config = function()
      require('gitsigns').setup({
        signs = {
          add = { text = '┃' },
          change = { text = '┃' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
          untracked = { text = '┆' }
        },
        -- signs_staged = {
        --   add = { text = '┃' },
        --   change = { text = '┃' },
        --   delete = { text = '_' },
        --   topdelete = { text = '‾' },
        --   changedelete = { text = '~' },
        --   untracked = { text = '┆' }
        -- },
        -- signs_staged_enable = true,
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = { follow_files = true },
        auto_attach = true,
        attach_to_untracked = true,
        current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
          virt_text_priority = 100
        },
        current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
          -- Options passed to nvim_open_win
          border = 'single',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1
        },
        on_attach = function(bufnr)
          local gitsigns = require('gitsigns')

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then
              vim.cmd.normal({ ']c', bang = true })
            else
              gitsigns.nav_hunk('next')
            end
          end)

          map('n', '[c', function()
            if vim.wo.diff then
              vim.cmd.normal({ '[c', bang = true })
            else
              gitsigns.nav_hunk('prev')
            end
          end)

          -- Actions
          map('n', '<leader>hs', gitsigns.stage_hunk)
          map('n', '<leader>hr', gitsigns.reset_hunk)
          map('v', '<leader>hs', function()
            gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') }
          end)
          map('v', '<leader>hr', function()
            gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') }
          end)
          map('n', '<leader>hS', gitsigns.stage_buffer)
          map('n', '<leader>hu', gitsigns.undo_stage_hunk)
          map('n', '<leader>hR', gitsigns.reset_buffer)
          map('n', '<leader>hp', gitsigns.preview_hunk)
          map('n', '<leader>hb',
              function() gitsigns.blame_line { full = true } end)
          map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
          map('n', '<leader>hd', gitsigns.diffthis)
          map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
          map('n', '<leader>td', gitsigns.toggle_deleted)

          -- Text object
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
      })
    end
  }, {
    'sudormrfbin/cheatsheet.nvim',
    enable = true,
    lazy = false,
    dependencies = {
      'nvim-telescope/telescope.nvim', 'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim'
    }
  }, {
    "tris203/hawtkeys.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    config = {}
  }, {
    'anuvyklack/pretty-fold.nvim',
    config = {
      sections = {
        left = { 'content' },
        right = {
          ' ', 'number_of_folded_lines', ': ', 'percentage', ' ',
          function(config) return config.fill_char:rep(3) end
        }
      },
      fill_char = '•',
      remove_fold_markers = true,
      -- Keep the indentation of the content of the fold string.
      keep_indentation = true,
      -- Possible values:
      -- "delete" : Delete all comment signs from the fold string.
      -- "spaces" : Replace all comment signs with equal number of spaces.
      -- false    : Do nothing with comment signs.
      process_comment_signs = 'spaces',
      -- Comment signs additional to the value of `&commentstring` option.
      comment_signs = {},
      -- List of patterns that will be removed from content foldtext section.
      stop_words = {
        '@brief%s*' -- (for C++) Remove '@brief' and all spaces after.
      },
      add_close_pattern = true, -- true, 'last_line' or false
      matchup_patterns = {
        { '{', '}' }, { '%(', ')' }, -- % to escape lua pattern char
        { '%[', ']' } -- % to escape lua pattern char
      },

      ft_ignore = { 'neorg' }
    }
  }, {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {}
  }, {
    "m4xshen/hardtime.nvim",

    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    opts = {
      max_time = 2000,
      max_count = 4,
      restricted_keys = {
        ["h"] = { "n", "x" },
        ["j"] = { "n" },
        ["k"] = { "n" },
        ["l"] = { "n", "x" },
        ["-"] = { "n", "x" },
        ["+"] = { "n", "x" },
        ["gj"] = { "n", "x" },
        ["gk"] = { "n", "x" },
        ["<CR>"] = { "n", "x" },
        ["<C-M>"] = { "n", "x" },
        ["<C-N>"] = { "n", "x" },
        ["<C-P>"] = { "n", "x" }
      },
      disabled_filetypes = {
        "Outline", "NvimTree", "TelescopePrompt", "aerial", "alpha",
        "checkhealth", "dapui-repl", "dapui_breakpoints", "dapui_console",
        "dapui_scopes", "dapui_stacks", "dapui_watches", "DressingInput",
        "DressingSelect", "help", "lazy", "NeogitStatus", "NeogitLogView",
        "mason", "neotest-summary", "minifiles", "neo-tree", "neo-tree-popup",
        "netrw", "noice", "notify", "prompt", "qf", "oil", "undotree"
      }
    }
  }, {
    "luckasRanarison/nvim-devdocs",
    keys = { { "<leader>o", "<cmd>DevdocsOpen<cr>", desc = "Open Devdocs" } },
    dependencies = {
      "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter"
    },

    config = true,
    cmd = {
      "DevdocsFetch", "DevdocsInstall", "DevdocsUninstall", "DevdocsOpen",
      "DevdocsOpenFloat", "DevdocsOpenCurrent", "DevdocsOpenCurrentFloat",
      "DevdocsUpdate", "DevdocsUpdateAll"
    },
    event = "VeryLazy",
    opts = {
      dir_path = vim.fn.stdpath("data") .. "/devdocs", -- installation directory
      telescope = {}, -- passed to the telescope picker
      filetypes = {
        scss = "sass",
        javascript = { "node", "javascript", "npm" },
        typescript = { "node", "javascript", "typescript", "npm" }
      },
      float_win = { -- passed to nvim_open_win(), see :h api-floatwin
        relative = "editor",
        height = 500,
        width = 800,
        border = "rounded"
      },
      wrap = true, -- text wrap, only applies to floating window
      previewer_cmd = "glow", -- for example: "glow"
      cmd_args = { "-w", "80", "-s", "dark", "-p" },
      cmd_ignore = {}, -- ignore cmd rendering for the listed docs
      picker_cmd = true, -- use cmd previewer in picker preview
      picker_cmd_args = { "-w", "80", "-s", "dark", "-p" },
      -- Commented out because it causes `Buildding large docs can freeze neovim` window to appear
      -- ensure_installed = {
      --   "node", "javascript", "typescript", "npm", "sass", "css", "html",
      --   "lua-5.4", "cpp", "go", "python-3.12", "jsdoc", "git"
      -- }, -- get automatically installed
      mappings = { open_in_browser = "m" },
      after_open = function(bufnr)
        -- Your existing setup for keymaps or other buffer-specific settings
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Esc>', ':close<CR>', {})

        -- Example of focusing the newly opened buffer
        -- vim.api.nvim_set_current_buf(bufnr)

        -- If you really need to close the previous buffer, you could do something like this:
        -- Be very cautious with this approach to avoid losing unsaved changes or closing buffers you want to keep open.
        local buffers = vim.api.nvim_list_bufs()
        for _, buffer in ipairs(buffers) do
          if buffer ~= bufnr and vim.api.nvim_buf_is_valid(buffer) and
              vim.bo[buffer].buftype == 'terminal' then
            vim.api.nvim_buf_delete(buffer, { force = true })
            break -- Remove this if you want to close all other terminal buffers, but be cautious
          end
        end
      end
    }
  }, { 'rcarriga/nvim-notify' }, {
    'antonk52/bad-practices.nvim',

    enable = true,
    config = function()
      local bad_practices = require("bad_practices")
      bad_practices.setup({
        most_splits = 3, -- how many splits are considered a good practice(default: 3)
        most_tabs = 3, -- how many tabs are considered a good practice(default: 3)
        max_hjkl = 10 -- how many times you can spam hjkl keys in a row(default: 10)
      })
    end
  }, {
    'gaborvecsei/usage-tracker.nvim',

    config = function()
      require('usage-tracker').setup({
        keep_eventlog_days = 14,
        cleanup_freq_days = 7,
        event_wait_period_in_sec = 5,
        inactivity_threshold_in_min = 5,
        inactivity_check_freq_in_sec = 5,
        verbose = 0
      })
    end
  }, {
    "ThePrimeagen/refactoring.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    config = function() require("refactoring").setup() end
  }, { 'puremourning/vimspector' }, {
    'nvimtools/none-ls.nvim',
    keys = {
      {
        "<leader>b",
        "<cmd>VimspectorBreakpoints<cr>",
        desc = "Open Vimspector breakpoints"
      }
    },

    enable = true,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.code_actions.refactoring,
          -- TODO: open issue that order of statixs affects their work
          null_ls.builtins.diagnostics.deadnix,
          null_ls.builtins.diagnostics.statix,
          null_ls.builtins.code_actions.statix, null_ls.builtins.hover.printenv,
          null_ls.builtins.completion.spell, null_ls.builtins.formatting.buf,
          null_ls.builtins.formatting.cmake_format,
          null_ls.builtins.diagnostics.yamllint,
          null_ls.builtins.diagnostics.hadolint,
          null_ls.builtins.diagnostics.protolint,
          -- null_ls.builtins.diagnostics.gccdiag,
          null_ls.builtins.diagnostics.checkmake,
          null_ls.builtins.diagnostics.cppcheck,
          null_ls.builtins.diagnostics.cpplint,
          null_ls.builtins.diagnostics.cmake_lint,
          null_ls.builtins.diagnostics.dotenv_linter,
          null_ls.builtins.diagnostics.editorconfig_checker,
          null_ls.builtins.diagnostics.gitlint
          -- null_ls.builtins.diagnostics.clang_check,
          -- null_ls.builtins.diagnostics.jsonlint,
          -- null_ls.builtins.formatting.fixjson, 
          -- null_ls.builtins.formatting.json_tool, 
          -- null_ls.builtins.formatting.jq
        }
      })
    end
  }, {
    'nvim-telescope/telescope-fzf-native.nvim',
    keys = {
      { "<leader>te", "<cmd>Telescope<cr>", desc = "Open Telescope" }, {
        "<leader>tg",
        "<cmd>Telescope live_grep<cr>",
        desc = "Open Telescope live_grep"
      }
    },
    build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  }, { 'anott03/nvim-lspinstall' }, {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts) require'lsp_signature'.setup(opts) end
  }, { 'RishabhRD/popfix' }, { 'RishabhRD/nvim-lsputils' }, -- {
  --   'quick-lint/quick-lint-js',
  --   
  -- },
  { 'scrooloose/syntastic' }, {
    'simrat39/inlay-hints.nvim',

    enable = true,
    config = function()
      require("inlay-hints").setup({
        only_current_line = true,
        eol = { right_align = true }
      })
    end
  }, {
    'sindrets/diffview.nvim',
    keys = {
      {
        "<leader>D",
        "<cmd>DiffviewOpen<cr>",
        desc = "Open git diff view",
        mode = { "n", "v" }
      }, {
        "<leader>c",
        "<cmd>DiffviewClose<cr>",
        desc = "Close git diff view",
        mode = { "n", "v" }
      }
    },
    config = function()
      require('diffview').setup({
        diff_binaries = false -- Show diffs for binaries
      })
    end
  }, { 'pantharshit00/vim-prisma' }, { 'famiu/nvim-reload' }, {
    'echasnovski/mini.bufremove',
    version = '*',
    keys = {
      {
        "<A-w>",
        "<cmd>lua MiniBufremove.delete(0, true) <cr>",
        mode = { "n", "v" }
      },
      desc = "Delete crrently opened buffer"
    },

    config = function()
      local bufremove = require('mini.bufremove')
      bufremove.setup({})
    end
  }, {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    config = function()
      local lualine = require('lualine')
      lualine.setup {
        options = {
          icons_enabled = true,
          theme = 'tokyonight',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = { statusline = {}, winbar = {} },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = { statusline = 1000, tabline = 1000, winbar = 1000 }
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { 'filename' },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      }
    end
  }, {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = true,
    enabled = true,
    keys = {
      { "<leader>\\", "toggle" }, { "\\", "toggle" }, { "g\\", "git_status" }
    },
    dependencies = {
      "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim", {
        -- only needed if you want to use the commands with "_with_window_picker" suffix
        's1n7ax/nvim-window-picker',
        -- tag = "v1.*",
        config = function()
          require'window-picker'.setup({
            autoselect_one = true,
            include_current = false,
            filter_rules = {
              -- filter using buffer options
              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { 'neo-tree', "neo-tree-popup", "notify" },

                -- if the buffer type is one of following, the window will be ignored
                buftype = { 'terminal', "quickfix" }
              }
            },
            other_win_hl_color = '#e35e4f'
          })
        end
      }
    },
    config = function()
      -- Unless you are still migrating, remove the deprecated commands from v1.x
      vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
      -- If you want icons for diagnostic errors, you'll need to define them somewhere:
      vim.fn.sign_define("DiagnosticSignError",
                         { text = " ", texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DiagnosticSignWarn",
                         { text = " ", texthl = "DiagnosticSignWarn" })
      vim.fn.sign_define("DiagnosticSignInfo",
                         { text = " ", texthl = "DiagnosticSignInfo" })
      vim.fn.sign_define("DiagnosticSignHint",
                         { text = "", texthl = "DiagnosticSignHint" })
      -- NOTE: this is changed from v1.x, which used the old style of highlight groups
      -- in the form "LspDiagnosticsSignWarning"
      require("neo-tree").setup({
        close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
        sort_case_insensitive = false, -- used when sorting files and directories in the tree
        sort_function = nil, -- use a custom function for sorting files and directories in the tree
        -- sort_function = function (a,b)
        --       if a.type == b.type then
        --           return a.path > b.path
        --       else
        --           return a.type > b.type
        --       end
        --   end , -- this sorts files and directories descendantly
        default_component_configs = {
          container = { enable_character_fade = true },
          indent = {
            indent_size = 2,
            padding = 1, -- extra padding on left hand side
            -- indent guides
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker",
            -- expander config, needed for nesting files
            with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander"
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "ﰊ",
            -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
            -- then these will never be used.
            default = "*",
            highlight = "NeoTreeFileIcon"
          },
          modified = { symbol = "[+]", highlight = "NeoTreeModified" },
          name = {
            trailing_slash = true,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName"
          },
          git_status = {
            symbols = {
              -- Change type
              added = "✚", -- or "✚", but this is redundant info if you use git_status_colors on the name
              modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
              deleted = "✖", -- this can only be used in the git_status source
              renamed = "" -- this can only be used in the git_status source
              -- Status type
              -- untracked = "",
              -- ignored = "",
              -- unstaged = "",
              -- staged = "",
              -- conflict = ""
            }
          }
        },
        --     -- A list of functions, each representing a global custom command
        --     -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
        --     -- see `:h neo-tree-global-custom-commands`
        --     commands = {},
        --
        window = {
          position = "left",
          width = 30,
          mapping_options = { noremap = true, nowait = true },
          mappings = {
            ["<space>"] = {
              "toggle_node",
              nowait = false -- disable `nowait` if you have existing combos starting with this char that you want to use
            },
            ["<2-LeftMouse>"] = "open",
            ["<cr>"] = "open",
            ["l"] = "open",
            ["<esc>"] = "revert_preview",
            ["P"] = { "toggle_preview", config = { use_float = true } },
            -- ["l"] = "focus_preview",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            -- ["S"] = "split_with_window_picker",
            -- ["s"] = "vsplit_with_window_picker",
            ["t"] = "open_tabnew",
            -- ["<cr>"] = "open_drop",
            -- ["t"] = "open_tab_drop",
            ["w"] = "open_with_window_picker",
            -- ["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing

            -- ['C'] = 'close_all_subnodes',
            ["z"] = "close_all_nodes",
            -- ["Z"] = "expand_all_nodes",
            ["a"] = {
              "add",
              -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
              -- some commands may take optional config options, see `:h neo-tree-mappings` for details
              config = {
                show_path = "relative" -- "none", "relative", "absolute"
              }
            },
            ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
            -- ["c"] = {
            --  "copy",
            --  config = {
            --    show_path = "none" -- "none", "relative", "absolute"
            --  }
            -- }
            ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
            ["<"] = "prev_source",
            [">"] = "next_source"
          }
        },
        nesting_rules = {},
        filesystem = {
          filtered_items = {
            visible = false, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = true,
            hide_gitignored = true,
            hide_hidden = true, -- only works on Windows for hidden files/directories
            hide_by_name = { "node_modules" },
            hide_by_pattern = { -- uses glob style patterns
              -- "*.meta",
              -- "*/src/*/tsconfig.json",
            },
            always_show = { -- remains visible even if other settings would normally hide it
              ".env", ".eslintrc.json", "eslint.config.js"
            },
            never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
              -- ".DS_Store",
              -- "thumbs.db"
            },
            never_show_by_pattern = { -- uses glob style patterns
              -- ".null-ls_*",
            }
          },
          follow_current_file = { enabled = true },
          -- time the current file is changed while the tree is open.
          group_empty_dirs = false, -- when true, empty folders will be grouped together
          hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
          -- in whatever position is specified in window.position
          -- "open_current",  -- netrw disabled, opening a directory opens within the
          -- window like netrw would, regardless of window.position
          -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
          use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
          -- instead of relying on nvim autocmd events.
          window = {
            mappings = {
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
              ["H"] = "toggle_hidden",
              ["/"] = "fuzzy_finder",
              ["D"] = "fuzzy_finder_directory",
              ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
              -- ["D"] = "fuzzy_sorter_directory",
              ["f"] = "filter_on_submit",
              ["<c-x>"] = "clear_filter",
              ["[g"] = "prev_git_modified",
              ["]g"] = "next_git_modified"
            },
            fuzzy_finder_mappings = {
              -- define keymaps for filter popup window in fuzzy_finder_mode
              ["<down>"] = "move_cursor_down",
              ["<C-n>"] = "move_cursor_down",
              ["<up>"] = "move_cursor_up",
              ["<C-p>"] = "move_cursor_up"
            }
          },
          commands = {} -- Add a custom command or override a global one using the same function name
        },
        buffers = {
          follow_current_file = { enabled = true },
          -- time the current file is changed while the tree is open.
          group_empty_dirs = true, -- when true, empty folders will be grouped together
          show_unloaded = true,
          window = {
            mappings = {
              ["bd"] = "buffer_delete",
              ["<bs>"] = "navigate_up",
              ["."] = "set_root"
            }
          }
        },
        git_status = {
          window = {
            position = "float",
            mappings = {
              ["A"] = "git_add_all",
              ["gu"] = "git_unstage_file",
              ["ga"] = "git_add_file",
              -- ["gr"] = "git_revert_file",
              ["gc"] = "git_commit",
              ["gp"] = "git_push",
              ["gg"] = "git_commit_and_push"
            }
          }
        }
      })

      vim.cmd([[nnoremap \  :Neotree reveal<cr>]])
      vim.cmd([[nnoremap <leader>\  :Neotree close<cr>]])
      vim.cmd([[nnoremap g\ :Neotree git_status reveal<cr>]])
    end
  }, { 'nvim-lua/plenary.nvim' }, { 'willthbill/opener.nvim' },
  { 'https://github.com/jose-elias-alvarez/typescript.nvim' }, {
    'sbdchd/neoformat',

    keys = {
      {
        "<leader>F",
        function()
          vim.cmd("silent Neoformat")
          vim.cmd("write")
        end,
        mode = "n",
        desc = "Format current buffer"
      }, {
        "<leader>F",
        function()
          local cmd = vim.api.nvim_replace_termcodes(
                          ':<C-U>silent \'<,\'>Neoformat<CR>', true, false, true)
          vim.api.nvim_feedkeys(cmd, 'n', true)
        end,
        mode = "v",
        desc = "Format selected text"
      }
    },
    config = function()
      vim.g.latexindent_opt = "-m"
      vim.g.neoformat_enabled_cpp = { 'clangformat' }
      vim.g.neoformat_cpp_clangformat = {
        exe = 'clang-format',
        args = {
          '--style="{BasedOnStyle: Google, IndentWidth: 2, ColumnLimit: 100}"'
        },
        stdin = 1
      }
      vim.g.neoformat_enabled_asm = { 'asmfmt' }
      vim.g.neoformat_enabled_json = { 'prettier' }
      vim.g.neoformat_enabled_nasm = { 'asmfmt' }
      vim.g.neoformat_nasm_asmfmt = { exe = 'asmfmt', stdin = 1 }
      vim.g.neoformat_asm_asmfmt = { exe = 'asmfmt', stdin = 1 }
      vim.g.neoformat_markdown_remark = {
        exe = 'prettier',
        args = { '--prose-wrap=always', '--stdin-filepath', '"%:p"' },
        stdin = 1,
        try_node_exe = 1
      }
      vim.g.neoformat_markdown_remark = {
        exe = 'prettier',
        args = { '--prose-wrap=always', '--stdin-filepath', '"%:p"' },
        stdin = 1,
        try_node_exe = 1
      }
      vim.g.neoformat_java_astyle = {
        exe = 'astyle',
        args = { '--indent=spaces=2' },
        replace = 1
      }
      vim.g.neoformat_html_htmlbeautify = {
        exe = 'html-beautify',
        args = { '--indent-size', '2' }
      }
      vim.g.neoformat_rust_rustfmt = {
        exe = 'rustfmt',
        -- args = { '--config', 'tab_spaces=2' },
        replace = 0,
        stdin = 1
      }
      vim.g.neoformat_try_node_exe = 1;
      vim.g.neoformat_lua_luaformatter = {
        exe = 'lua-format',
        args = {
          '--indent-width=2', '--spaces-inside-table-braces',
          '--column-limit=80'
        }
      }
      vim.g.neoformat_tex_latexindent = {
        exe = 'latexindent' --
        --
      }
      vim.g.neoformat_typescript_prettier = {
        exe = 'prettier',
        args = { vim.fn.expand('%:p') },
        replace = 1,
        try_node_exe = 1
      }
      vim.g.neoformat_typescript_deno_fmt = {
        exe = 'deno',
        args = { 'fmt' },
        replace = 1
      }
      vim.g.neoformat_enabled_typescript = { 'prettier', 'deno_fmt' }
      vim.g.neoformat_typescriptreact_prettier = {
        exe = 'prettier',
        args = { vim.fn.expand('%:p') },
        replace = 1,
        try_node_exe = 1
      }
      vim.g.neoformat_enabled_typescriptreact = { 'prettier' }
      vim.g.neoformat_javascriptreact_prettier = {
        exe = 'prettier',
        args = { vim.fn.expand('%:p') },
        replace = 1,
        try_node_exe = 1
      }
      vim.g.neoformat_enabled_javascriptreact = { 'prettier' }
      vim.g.neoformat_json_prettier = {
        exe = 'prettier',
        args = { vim.fn.expand('%:p') },
        replace = 1,
        try_node_exe = 1
      }
      vim.g.neoformat_enabled_json = { 'prettier' }
      vim.g.neoformat_enabled_nix = { 'nixfmt' }
      vim.g.neoformat_nix_nixfmt = { exe = 'nixfmt', stdin = 1 }
    end
  }, {
    -- bar at the top
    'akinsho/nvim-bufferline.lua',
    version = '*',
    keys = {
      { "gb", "pick_buffer" }, { "<A-l>", "<cmd>BufferLineCycleNext<CR>" },
      { "<A-h>", "<cmd>BufferLineCyclePrev<CR>" },
      { "<A-j>", "<cmd>BufferLineMovePrev<CR>" },
      { "<A-k>", "<cmd>BufferLineMoveNext" }
    },
    config = function()
      local b = require("bufferline")
      b.setup {
        options = {
          diagnostics = "nvim_lsp",
          show_buffer_icons = true,
          show_buffer_close_icons = false,
          show_close_icon = false,
          always_show_bufferline = true
        },
        highlights = {
          fill = { fg = '#ffffff', bg = '#000000' },
          background = { fg = '#ffffff', bg = '#000000' },
          tab = { fg = '#ffffff', bg = '#000000' },
          tab_selected = { fg = '#ffffff', bg = '#000000' },
          buffer_visible = { fg = '#ffffff', bg = '#000000' },
          buffer_selected = {
            fg = '#ffffff',
            bg = '#333333',
            bold = false,
            italic = false
          }
        }
      }
    end
  }, {
    -- indent blankline
    'lukas-reineke/indent-blankline.nvim',

    enabled = false,
    config = function()
      vim.g.indent_blankline_char = '▏'
      vim.g.indent_blankline_char_highlight_list = { "IndentLine" }
      vim.g.indent_blankline_show_first_indent_level = false
      -- vim.g.indent_blankline_show_trailing_blankline_indent = false
      vim.g.indent_blankline_use_treesitter = true
      vim.g.indent_blankline_filetype_exclude = {
        'markdown', 'mkd', 'tex', 'startify'
      }
    end
  }, --
  {
    -- highlights yank
    'machakann/vim-highlightedyank',

    config = function() vim.g.highlightedyank_highlight_duration = 250 end
  }, --
  {
    -- colorize colors like this #01dd99
    'norcalli/nvim-colorizer.lua',

    config = function()
      require('colorizer').setup({
        '*',
        css = { css = true },
        scss = { scc = true }
      }, { names = true })
    end
  }, {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  }, {
    'windwp/nvim-autopairs',

    config = function()
      require('nvim-autopairs').setup({})
      -- local Rule = require('nvim-autopairs.rule')
      -- local npairs = require('nvim-autopairs')

      -- npairs.add_rule(Rule("<", ">", "typescript"))
      -- npairs.add_rule(Rule("<", ">", "typescriptreact"))
      -- npairs.add_rule(Rule("<", ">", "rust"))
      Map('i', 'х', 'х')
      Map('i', 'ъ', 'ъ')
      Map('i', 'э', 'э')
      Map('i', 'ё', 'ё')
      Map('i', 'Х', 'Х')
      Map('i', 'Ъ', 'Ъ')
      Map('i', 'Э', 'Э')
      Map('i', 'Ё', 'Ё')
    end
  }, { 'tversteeg/registers.nvim' }, {
    'phaazon/hop.nvim',
    name = 'hop',
    keys = {
      { "<leader>k", "<cmd>lua require'hop'.hint_lines()<cr>" },
      { "<leader>l", "<cmd>lua require'hop'.hint_words()<cr>" },
      { "<leader>j", "<cmd>lua require'hop'.hint_lines()<cr>" },
      { "<leader>f", "<cmd>lua require'hop'.hint_char1()<cr>" },
      { "<leader>s", "<cmd>lua require'hop'.hint_char2()<cr>" }
    },
    config = { keys = 'asdfghjkl;eiurtcxm,' },
  }, {
    "ahmedkhalf/project.nvim",

    config = function()
      require("project_nvim").setup {
        patterns = { ".git", "Makefile", "package.json", "init.lua" },
        detection_methods = { ".git", "Makefile", "package.json", "init.lua" },
        exclude_dirs = { "client" }
      }
    end
  }, {
    "hedyhli/outline.nvim",
    keys = { { "<leader>;", "<cmd>Outline<CR>" } },
    config = function()
      -- Example mapping to toggle outline
      vim.keymap.set("n", "<leader>;", "<cmd>Outline<CR>",
                     { desc = "Toggle Outline" })

      require("outline").setup {
        -- Your setup opts here (leave empty to use defaults)
      }
    end
  }, {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",

    lazy = false,
    config = function()
      vim.cmd "au BufReadPost,BufNewFile,BufRead * hi clear TODO"
      require("todo-comments").setup {
        signs = false,
        signs_priority = 8,
        keywords = {
          FIX = {
            icon = " ",
            color = "error",
            alt = { "FIXME", "BUG", "FIXIT", "FIX", "ISSUE" }
          },
          TODO = { icon = " ", color = "info" },
          HACK = {
            icon = " ",
            color = "#ffa000",
            alt = { "FUCK", "SHIT", "BAD" }
          },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO", "SAFETY" } },
          WHERE_AM_I_GOING_WITH_THIS = {
            icon = "!",
            color = "error",
            alt = { "WTF", "WAIGWT" }
          },
          ASSUMPTION = {
            icon = "__",
            color = "error",
            alt = { "AXIOM", "ASSUME" }
          }
        },
        merge_keywords = true, -- when true, custom keywords will be merged with the defaults
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
        comments_only = true, -- uses treesitter to match keywords in comments only
        max_line_len = 400, -- ignore lines longer than this
        exclude = {}, -- list of file types to exclude highlighting
        -- list of named colors where we try to extract the guifg from the
        -- list of highlight groups or use the hex color if hl not found as a fallback
        highlight = {
          multiline = false, -- enable multine todo comments
          multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
          multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
          before = "", -- "fg" or "bg" or empty
          keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
          after = "fg", -- "fg" or "bg" or empty
          pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
          comments_only = true, -- uses treesitter to match keywords in comments only
          max_line_len = 400, -- ignore lines longer than this
          exclude = {} -- list of file types to exclude highlighting
        },
        colors = {
          error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
          warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
          info = { "DiagnosticInfo", "#2563EB" },
          hint = { "DiagnosticHint", "#10B981" },
          default = { "Identifier", "#7C3AED" },
          test = { "Identifier", "#FF00FF" }
        },
        search = {
          command = "rg",
          args = {
            "--color=never", "--no-heading", "--with-filename", "--line-number",
            "--column"
          },
          -- regex that will be used to match keywords.
          -- don't replace the (KEYWORDS) placeholder
          pattern = [[\b(KEYWORDS):]] -- ripgrep regex
          -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
        }

      }
    end
  }, {
    -- xkbswitch TODO: doesn't work
    'lyokha/vim-xkbswitch',
    lazy = true,
    enabled = false,
    config = function()
      vim.g.XkbSwitchEnabled = 1
      vim.g.XkbSwitchIMappings = { 'ru', 'sk(qwerty)', 'ua' }
    end
  }, { 'folke/neodev.nvim', ft = { 'lua' }, config = true }, {
    'luochen1990/rainbow',

    enabled = true,
    config = function()
      vim.g.rainbow_active = 1;
      vim.g.grainbow_conf = {
        -- guifgs = { 'royalblue3', 'darkorange3', 'seagreen3', 'firebrick' },
        -- ctermfgs = { 'lightblue', 'lightyellow', 'lightcyan', 'lightmagenta' },
        guifgs = { "#bf616a", "#ffd700", "#a3de3c", "#ebcb8b", "#88c0d0" },
        ctermfgs = { "#af5f5f", "#ffd700", "#afff00", "#d7af87", "#afd7ff" },
        guis = { '' },
        cterms = { '' },
        operators = '_,_',
        parentheses = {
          'start=/(/ end=/)/ fold', 'start=/[/ end=/]/ fold',
          'start=/{/ end=/}/ fold', 'start=/</ end=/>/ fold'
        },
        separately = {
          markdown = {
            parentheses_options = 'containedin=markdownCode contained' -- "enable rainbow for code blocks only
          },
          css = 0, -- disable this plugin for css files
          nerdtree = 0 -- rainbow is conflicting with NERDTree, creating extra parentheses
        }
      }
    end
  }, {
    'mhinz/vim-startify',

    enabled = true,
    config = function()
      vim.g.startify_lists = {
        { type = 'dir', header = { "MRU [" .. vim.fn.getcwd() .. "]" } },
        { type = 'files', header = { "MRU [global]" } }
      }
      vim.g.startify_fortune_use_unicode = 1
      -- vim.g.startify_custom_header = 'startify#pad(startify#fortune#boxed())'
    end
  }
}

return M
