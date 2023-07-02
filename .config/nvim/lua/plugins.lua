local M = {
  { 'pantharshit00/vim-prisma', lazy = false }, {
    'famiu/nvim-reload',
    lazy = false,
    config = function()
      Map('n', '<leader>R', function() require('nvim-reload').Reload() end)
    end
  }, {
    "Alexis12119/nightly.nvim",
    lazy = false,
    config = function()
      local nightly = require('nightly')
      nightly.setup({
        color = "black", -- blue, green, or red
        transparent = false,
        styles = {
          comments = { italic = false },
          functions = { italic = false },
          keywords = { italic = false },
          variables = { italic = false }
        },
        highlights = { Normal = { bg = "#000000" } }
      })
    end
  }, {
    'echasnovski/mini.bufremove',
    version = '*',
    lazy = false,
    config = function()
      local bufremove = require('mini.bufremove')
      bufremove.setup({})
    end
  }, {
    'nvim-lualine/lualine.nvim',
    config = function()
      local lualine = require('lualine')
      lualine.setup {
        options = {
          icons_enabled = true,
          theme = 'nightly',
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
    'gelguy/wilder.nvim',
    lazy = false,
    dependencies = {
      'romgrk/fzy-lua-native', 'kyazdani42/nvim-web-devicons'
      -- 'liuchengxu/vim-clap'
    },
    config = function()
      local wilder = require('wilder')
      wilder.setup({ modes = { ':', '/', '?' } })

      wilder.set_option('pipeline', {
        wilder.branch(wilder.python_file_finder_pipeline({
          file_command = { 'fd', '-tf' },
          dir_command = { 'fd', '-td' },
          -- filters = { 'fuzzy_filter', 'difflib_sorter' },
          -- filters = { 'clap_filter' },
          path = function()
            local filename = vim.api.nvim_buf_get_name(0)
            return RootPattern(".git", ".project_root", "LICENSE", "Cargo.toml",
                               "package.json", "init.lua")(filename) or
                       vim.loop.os_homedir()
          end
        }), wilder.cmdline_pipeline(), wilder.python_search_pipeline())
      })

      wilder.set_option('renderer', wilder.renderer_mux({
        [':'] = wilder.popupmenu_renderer({
          highlighter = wilder.lua_fzy_highlighter(),
          left = { ' ', wilder.popupmenu_devicons() },
          right = { ' ', wilder.popupmenu_scrollbar() }
        }),
        ['/'] = wilder.wildmenu_renderer({
          highlighter = wilder.lua_fzy_highlighter()
        })
      }))
    end
  }, --
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim", {
        -- only needed if you want to use the commands with "_with_window_picker" suffix
        's1n7ax/nvim-window-picker',
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
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName"
          },
          git_status = {
            symbols = {
              -- Change type
              added = "✚", -- or "✚", but this is redundant info if you use git_status_colors on the name
              modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
              deleted = "✖", -- this can only be used in the git_status source
              renamed = "", -- this can only be used in the git_status source
              -- Status type
              untracked = "",
              ignored = "",
              unstaged = "",
              staged = "",
              conflict = ""
            }
          }
        },
        -- A list of functions, each representing a global custom command
        -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
        -- see `:h neo-tree-global-custom-commands`
        commands = {},

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
            ["<esc>"] = "revert_preview",
            ["P"] = { "toggle_preview", config = { use_float = true } },
            ["l"] = "focus_preview",
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
            hide_by_name = {
              -- "node_modules"
            },
            hide_by_pattern = { -- uses glob style patterns
              -- "*.meta",
              -- "*/src/*/tsconfig.json",
            },
            always_show = { -- remains visible even if other settings would normally hide it
              ".env", ".eslintrc.json"
            },
            never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
              -- ".DS_Store",
              -- "thumbs.db"
            },
            never_show_by_pattern = { -- uses glob style patterns
              -- ".null-ls_*",
            }
          },
          follow_current_file = false, -- This will find and focus the file in the active buffer every
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
            fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
              ["<down>"] = "move_cursor_down",
              ["<C-n>"] = "move_cursor_down",
              ["<up>"] = "move_cursor_up",
              ["<C-p>"] = "move_cursor_up"
            }
          },

          commands = {} -- Add a custom command or override a global one using the same function name
        },
        buffers = {
          follow_current_file = true, -- This will find and focus the file in the active buffer every
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
              ["gr"] = "git_revert_file",
              ["gc"] = "git_commit",
              ["gp"] = "git_push",
              ["gg"] = "git_commit_and_push"
            }
          }
        }
      })

      vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
      vim.cmd([[nnoremap g\ :Neotree git_status<cr>]])
    end
  }, { 'nvim-lua/plenary.nvim', lazy = false },
  { 'willthbill/opener.nvim', lazy = false },
  { 'https://github.com/jose-elias-alvarez/typescript.nvim', lazy = false }, {
    'sbdchd/neoformat',
    lazy = false,
    keys = { '<leader>F' },
    config = function()
      Map('n', '<leader>F', function()
        vim.cmd [[
          silent Neoformat
          write
        ]];
      end)
      Map('v', '<leader>F', function()
        local cmd = vim.api.nvim_replace_termcodes(
                        ':<C-U>silent \'<,\'>Neoformat<CR>', true, false, true);
        vim.api.nvim_feedkeys(cmd, 'n', true)
      end)
      vim.g.latexindent_opt = "-m"
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
      vim.g.neoformat_javascriptreact_tsfmt = {
        exe = 'tsfmt',
        args = { '--baseDir', '.', '-r' },
        replace = 1,
      }
      vim.g.neoformat_enabled_javascriptreact = { 'tsfmt' }
    end
  }, --
  { -- bar at the top
    'akinsho/nvim-bufferline.lua',
    lazy = false,
    dependencies = 'kyazdani42/nvim-web-devicons',
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
          fill = {
              fg = '#ffffff',
              bg = '#000000',
          },
          background = {
              fg = '#ffffff',
              bg = '#000000'
          },
          tab = {
              fg = '#ffffff',
              bg = '#000000'
          },
          tab_selected = {
              fg = '#ffffff',
              bg = '#333333'
          },
          buffer_visible = {
              fg = '#ffffff',
              bg = '#000000'
          },
          buffer_selected = {
              fg = '#ffffff',
              bg = '#333333',
              bold = false,
              italic = false,
          },
        }
      }
    end,
    init = function()
      Map('n', 'gb', function() require("bufferline").pick_buffer() end)

      Map('n', '<A-l>', function() require("bufferline").cycle(1) end)
      Map('n', '<A-h>', function() require("bufferline").cycle(-1) end)
      -- Map('n', '<Tab>', function() require("bufferline").cycle(1) end)
      -- Map('n', '<S-Tab>', function() require("bufferline").cycle(-1) end)
      -- Map('i', '<C-l>', function()
      --   vim.cmd "stopinsert";
      --   require("bufferline").cycle(1)
      -- end)
      -- Map('i', '<C-h>', function()
      --   vim.cmd "stopinsert";
      --   require("bufferline").cycle(-1)
      -- end)
      Map('n', '<S-h>', function() require("bufferline").move(-1) end)
      Map('n', '<S-l>', function() require("bufferline").move(1) end)
      Map('n', '<C-j>', '<cmd>tabn<cr>')
      Map('n', '<C-k>', '<cmd>tabp<cr>')
    end
  }, --
  { -- indent blankline
    'lukas-reineke/indent-blankline.nvim',
    lazy = false,
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
  { -- highlights yank
    'machakann/vim-highlightedyank',
    lazy = false,
    config = function() vim.g.highlightedyank_highlight_duration = 250 end
  }, --
  { -- colorize colors like this #01dd99
    'norcalli/nvim-colorizer.lua',
    lazy = false,
    config = function()
      require('colorizer').setup({
        '*',
        css = { css = true },
        scss = { scc = true }
      }, { names = false })
    end
  }, --
  {
    'lervag/vimtex',
    ft = { "tex", "bib" },
    dependencies = { 'KeitaNakamura/tex-conceal.vim', 'godlygeek/tabular' },
    config = function()
      vim.cmd "filetype plugin indent on"
      vim.cmd "syntax enable"
      Map('n', '<leader>vp', ':w<cr> :VimtexCompile<cr>')

      vim.g.tex_flavor = 'latex'
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_format_enabled = true
      -- vim.opt.conceallevel=1
      vim.g.tex_conceal = 'abdmg'
      vim.g.vimtex_view_method = 'zathura'

      vim.g.vimtex_view_general_viewer = 'okular'
      vim.g.vimtex_view_general_options = '--unique file:@pdf\\#src:@line@tex'

      vim.g.vimtex_compiler_method = 'latexrun'
      vim.g.vimtex_syntax_enabled = 0

      vim.g.maplocalleader = ","
    end
  }, --
  {
    'terrortylor/nvim-comment',
    enabled = true,
    config = function()
      require('nvim_comment').setup({
        -- Linters prefer comment and line to have a space in between markers
        marker_padding = true,
        -- should comment out empty or whitespace only lines
        comment_empty = true,
        -- trim empty comment whitespace
        comment_empty_trim_whitespace = false,
        -- Should key mappings be created
        create_mappings = true,
        -- Normal mode mapping left hand side
        line_mapping = "gcc",
        -- Visual/Operator mapping left hand side
        operator_mapping = "gc",
        -- text object mapping, comment chunk,,
        comment_chunk_text_object = "ic",
        -- Hook function to call before commenting takes place
        hook = nil
      })
      Map('n', "<C-_>", ":CommentToggle<CR>")
      Map('v', "<C-_>", ":CommentToggle<CR>")
    end,
    lazy = false
  }, --
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },

  -- { 'jiangmiao/auto-pairs', config = function() vim.g.AutoPairsMapCh = false end }
  {
    'windwp/nvim-autopairs',
    lazy = false,
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
  }, --
  { 'tversteeg/registers.nvim', lazy = false }, --
  {
    'phaazon/hop.nvim',
    name = 'hop',
    config = true,
    init = function()
      -- Map("n", "<leader>h", function() require'hop'.hint_words() end)
      -- Map("n", "<leader>k", function() require'hop'.hint_lines() end)
      Map("n", "<leader>l", function() require'hop'.hint_words() end)
      Map("n", "<leader>j", function() require'hop'.hint_lines() end)
      Map("n", "<leader>f", function() require'hop'.hint_char1() end)
      Map("n", "<leader>s", function() require'hop'.hint_char2() end)
    end
  }, -- use 'ray-x/lsp_signature.nvim'
  { -- TODO: Am I using it?
    "ahmedkhalf/project.nvim",
    lazy = false,
    config = function()
      require("project_nvim").setup {
        patterns = { ".git", "Makefile", "package.json", "init.lua" },
        detection_methods = { ".git", "Makefile", "package.json", "init.lua" },
        exclude_dirs = { "client" }
      }
    end
  }, -- use 'jackguo380/vim-lsp-cxx-highlight'
  { -- TODO: Doesn't work
    'simrat39/symbols-outline.nvim',
    keys = { '<leader>;' },
    cmd = { "SymbolsOutline" },
    config = function()
      require("symbols-outline").setup()
      Map('n', '<leader>;', ':SymbolsOutline<CR>')
    end
  }, --
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    lazy = false,
    enabled = false,
    config = function()
      vim.cmd "au BufReadPost,BufNewFile,BufRead * hi clear TODO"
      require("todo-comments").setup {
        signs = false,
        keywords = {
          FIX = {
            icon = " ",
            color = "error",
            alt = { "FIXME", "BUG", "FIXIT", "FIX", "ISSUE" }
          },
          TODO = { icon = " ", color = "info" },
          HACK = {
            icon = " ",
            color = "warning",
            alt = { "FUCK", "SHIT", "BAD" }
          },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO", "SAFETY" } }
        }
      }
    end
  }, --
  { -- xkbswitch TODO: doesn't work
    'lyokha/vim-xkbswitch',
    lazy = true,
    enabled = false,
    config = function()
      vim.g.XkbSwitchEnabled = 1
      vim.g.XkbSwitchIMappings = { 'ru', 'sk(qwerty)', 'ua' }
    end
  }, --
  { 'folke/neodev.nvim', ft = { 'lua' }, config = true }, {
    'luochen1990/rainbow',
    lazy = false,
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
  }, --
  {
    'mhinz/vim-startify',
    lazy = false,
    enabled = true,
    config = function()
      vim.g.startify_lists = {
        { type = 'dir', header = { "MRU [" .. vim.fn.getcwd() .. "]" } },
        { type = 'files', header = { "MRU [global]" } }
      }
      vim.g.startify_fortune_use_unicode = 1
      -- vim.g.startify_custom_header = 'startify#pad(startify#fortune#boxed())'
    end
  } --
  --
  --[[ use {
    'andweeb/presence.nvim',
    config = function() require("presence"):setup({}) end
  } ]]
}

return M
