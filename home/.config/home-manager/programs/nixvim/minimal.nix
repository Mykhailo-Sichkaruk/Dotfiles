{ pkgs, ... }:
{
  env.NVIM_APPNAME = "nixvim-minimal";

  viAlias = true;
  vimAlias = true;

  globals = {
    mapleader = " ";
    maplocalleader = " ";
  };

  opts = {
    breakindent = true;
    clipboard = "unnamedplus";
    confirm = true;
    exrc = true;
    expandtab = true;
    hlsearch = true;
    inccommand = "split";
    ignorecase = true;
    mouse = "a";
    number = true;
    relativenumber = true;
    scrolloff = 8;
    shiftwidth = 2;
    showmode = false;
    signcolumn = "yes";
    smartcase = true;
    splitbelow = true;
    splitright = true;
    tabstop = 2;
    termguicolors = true;
    timeoutlen = 300;
    undofile = true;
    updatetime = 250;
    wrap = false;
  };

  extraPackages = with pkgs; [
    fd
    git
    luaformatter
    nixfmt-rfc-style
    nodejs
    nodePackages_latest.prettier
    prettierd
    ripgrep
    ruff
  ];

  extraPlugins = with pkgs.vimPlugins; [
    git-conflict-nvim
    hop-nvim
    nvim-surround
    outline-nvim
    todo-comments-nvim
  ];

  keymaps = [
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      options.desc = "Clear search highlight";
    }
    {
      mode = "n";
      key = "<leader>w";
      action = "<cmd>write<CR>";
      options.desc = "Write buffer";
    }
    {
      mode = "n";
      key = "<leader>q";
      action = "<cmd>quit<CR>";
      options.desc = "Quit window";
    }
    {
      mode = "n";
      key = "<leader>x";
      action = "<cmd>bdelete<CR>";
      options.desc = "Close buffer";
    }
    {
      mode = "n";
      key = "<leader>ch";
      action = "<cmd>checkhealth<CR>";
      options.desc = "Check health";
    }
    {
      mode = "n";
      key = "<leader>tf";
      action = "<cmd>Telescope find_files<CR>";
      options.desc = "Find files";
    }
    {
      mode = "n";
      key = "<leader>tg";
      action = "<cmd>Telescope live_grep<CR>";
      options.desc = "Live grep";
    }
    {
      mode = "n";
      key = "<leader>te";
      action = "<cmd>Telescope<CR>";
      options.desc = "Open Telescope";
    }
    {
      mode = "n";
      key = "<leader>f";
      action = {
        __raw = ''
          function()
            require("hop").hint_char1()
          end
        '';
      };
      options.desc = "Hop char";
    }
    {
      mode = "n";
      key = "\\";
      action = "<cmd>Neotree reveal<CR>";
      options.desc = "Reveal in tree";
    }
    {
      mode = "n";
      key = "<leader>\\";
      action = "<cmd>Neotree close<CR>";
      options.desc = "Close tree";
    }
    {
      mode = "n";
      key = "g\\";
      action = "<cmd>Neotree git_status reveal<CR>";
      options.desc = "Git status tree";
    }
    {
      mode = "n";
      key = "<leader>gd";
      action = "<cmd>DiffviewOpen<CR>";
      options.desc = "Open diff view";
    }
    {
      mode = "n";
      key = "<leader>D";
      action = "<cmd>DiffviewOpen<CR>";
      options.desc = "Open diff view";
    }
    {
      mode = "n";
      key = "<leader>gq";
      action = "<cmd>DiffviewClose<CR>";
      options.desc = "Close diff view";
    }
    {
      mode = "n";
      key = "<leader>c";
      action = "<cmd>DiffviewClose<CR>";
      options.desc = "Close diff view";
    }
    {
      mode = "n";
      key = "<leader>j";
      action = {
        __raw = ''
          function()
            require("hop").hint_lines()
          end
        '';
      };
      options.desc = "Hop lines";
    }
    {
      mode = "n";
      key = "<leader>k";
      action = {
        __raw = ''
          function()
            require("hop").hint_lines()
          end
        '';
      };
      options.desc = "Hop lines";
    }
    {
      mode = "n";
      key = "<leader>l";
      action = {
        __raw = ''
          function()
            require("hop").hint_words()
          end
        '';
      };
      options.desc = "Hop words";
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>gp";
      action = {
        __raw = ''
          function()
            require("conform").format({
              async = true,
              lsp_format = "fallback",
            })
          end
        '';
      };
      options.desc = "Format buffer";
    }
    {
      mode = "n";
      key = "<leader>s";
      action = {
        __raw = ''
          function()
            require("hop").hint_char2()
          end
        '';
      };
      options.desc = "Hop 2-char";
    }
    {
      mode = "n";
      key = "gb";
      action = "<cmd>BufferLinePick<CR>";
      options.desc = "Pick buffer";
    }
    {
      mode = "n";
      key = "<A-w>";
      action = "<cmd>bdelete<CR>";
      options.desc = "Close current buffer";
    }
    {
      mode = "n";
      key = "<leader>;";
      action = "<cmd>Outline<CR>";
      options.desc = "Toggle outline";
    }
    {
      mode = "n";
      key = "<A-h>";
      action = "<cmd>BufferLineCyclePrev<CR>";
      options.desc = "Previous buffer";
    }
    {
      mode = "n";
      key = "<A-l>";
      action = "<cmd>BufferLineCycleNext<CR>";
      options.desc = "Next buffer";
    }
    {
      mode = "n";
      key = "<A-j>";
      action = "<cmd>BufferLineMovePrev<CR>";
      options.desc = "Move buffer left";
    }
    {
      mode = "n";
      key = "<A-k>";
      action = "<cmd>BufferLineMoveNext<CR>";
      options.desc = "Move buffer right";
    }
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options.desc = "Focus left window";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options.desc = "Focus lower window";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options.desc = "Focus upper window";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options.desc = "Focus right window";
    }
  ];

  autoCmd = [
    {
      event = [ "TextYankPost" ];
      desc = "Highlight yanked text";
      callback = {
        __raw = ''
          function()
            vim.highlight.on_yank({ timeout = 150 })
          end
        '';
      };
    }
    {
      event = [
        "FocusGained"
        "TermClose"
        "TermLeave"
      ];
      desc = "Reload files changed outside Neovim";
      command = "checktime";
    }
  ];

  extraConfigLuaPost = ''
    vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect" }

    vim.diagnostic.config({
      severity_sort = true,
      underline = true,
      update_in_insert = false,
      virtual_text = false,
      float = {
        border = "rounded",
        source = "if_many",
      },
    })

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover,
      { border = "rounded" }
    )

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
      vim.lsp.handlers.signature_help,
      { border = "rounded" }
    )

    pcall(function()
      require("telescope").load_extension("fzf")
    end)

    pcall(function()
      require("Comment.ft").set("helm", "#%s")
    end)

    pcall(function()
      require("git-conflict").setup({})
    end)

    pcall(function()
      require("hop").setup({
        keys = "asdfghjkl;eiurtcxm,",
      })
    end)

    pcall(function()
      require("nvim-surround").setup({})
    end)

    pcall(function()
      require("outline").setup({})
    end)

    pcall(function()
      require("todo-comments").setup({
        signs = false,
        keywords = {
          FIX = { alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
          HACK = { alt = { "FUCK", "SHIT", "BAD" } },
          NOTE = { alt = { "INFO", "SAFETY" } },
          ASSUMPTION = { alt = { "AXIOM", "ASSUME" } },
          WHERE_AM_I_GOING_WITH_THIS = { alt = { "WTF", "WAIGWT" } },
        },
      })
    end)

    local cmp = require("cmp")

    cmp.setup({
      experimental = { ghost_text = true },
      preselect = cmp.PreselectMode.None,
      snippet = {
        expand = function(_) end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<A-CR>"] = cmp.mapping.confirm({ select = true }),
        ["<A-Tab>"] = cmp.mapping.select_next_item(),
        ["<M-Tab>"] = cmp.mapping.select_next_item(),
        ["<A-S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<M-S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
      }),
      sources = {
        { name = "nvim_lsp" },
        { name = "path" },
      },
    })
  '';

  plugins.lsp = {
    enable = true;
    inlayHints = true;
    capabilities = ''
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
    '';
    onAttach = ''
      if client.name == "ts_ls" then
        client.server_capabilities.documentFormattingProvider = false
      end

      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
      end

      map("gD", vim.lsp.buf.declaration, "Go to declaration")
      map("gd", vim.lsp.buf.definition, "Go to definition")
      map("gI", vim.lsp.buf.implementation, "Go to implementation")
      map("gr", vim.lsp.buf.references, "List references")
      map("K", vim.lsp.buf.hover, "Hover documentation")
      map("<F2>", vim.lsp.buf.rename, "Rename symbol")
      map("<leader>a", vim.lsp.buf.code_action, "Code action")
      map("<leader>e", vim.diagnostic.open_float, "Line diagnostics")
      map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
      map("]d", vim.diagnostic.goto_next, "Next diagnostic")
      map("<leader>lq", vim.diagnostic.setloclist, "Diagnostics to loclist")
    '';

    servers = {
      jsonls = {
        enable = true;
        packageFallback = true;
      };

      eslint = {
        enable = true;
        packageFallback = true;
        settings = {
          workingDirectory.mode = "auto";
        };
      };

      lua_ls = {
        enable = true;
        packageFallback = true;
        settings = {
          Lua = {
            completion.callSnippet = "Replace";
            diagnostics.globals = [ "vim" ];
            telemetry.enable = false;
            workspace.checkThirdParty = false;
          };
        };
      };

      nixd = {
        enable = true;
        packageFallback = true;
      };

      ruff = {
        enable = true;
        packageFallback = true;
        filetypes = [ "python" ];
        rootMarkers = [
          "pyproject.toml"
          "ruff.toml"
          ".ruff.toml"
          ".git"
        ];
      };

      ts_ls = {
        enable = true;
        packageFallback = true;
        extraOptions = {
          init_options = {
            maxTsServerMemory = 8192;
          };
        };
      };
    };
  };

  plugins.treesitter = {
    enable = true;
    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      bash
      css
      diff
      html
      javascript
      jsdoc
      json
      jsonc
      lua
      markdown
      markdown_inline
      nix
      python
      query
      regex
      toml
      tsx
      typescript
      vim
      vimdoc
      yaml
    ];
    settings = {
      highlight.enable = true;
      indent.enable = true;
      incremental_selection = {
        enable = true;
        keymaps = {
          init_selection = "gnn";
          node_decremental = "grm";
          node_incremental = "grn";
          scope_incremental = "grc";
        };
      };
    };
  };

  plugins = {
    "cmp" = {
      enable = true;
      autoLoad = true;
    };

    "cmp-nvim-lsp".enable = true;
    "cmp-path".enable = true;
    "comment".enable = true;
    "conform-nvim" = {
      enable = true;
      settings = {
        notify_on_error = false;
        notify_no_formatters = false;
        format_on_save = {
          timeout_ms = 1000;
          lsp_format = "fallback";
        };
        formatters_by_ft = {
          css = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          html = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          javascript = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          javascriptreact = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          json = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          jsonc = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          lua = [ "lua_format" ];
          markdown = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          nix = [ "nixfmt" ];
          python = [
            "ruff_fix"
            "ruff_format"
          ];
          scss = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          typescript = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          typescriptreact = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
          yaml = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            stop_after_first = true;
          };
        };
      };
    };
    "copilot-lua" = {
      enable = true;
      settings = {
        panel = {
          enabled = false;
          auto_refresh = true;
        };
        suggestion = {
          enabled = true;
          auto_trigger = true;
          debounce = 75;
          keymap = {
            accept = "<Tab>";
            accept_word = false;
            accept_line = false;
            dismiss = "<C-l>";
          };
        };
        filetypes = {
          "." = false;
          cvs = false;
          gitcommit = false;
          gitrebase = false;
          help = false;
          hgcommit = false;
          markdown = false;
          svn = false;
          yaml = false;
        };
        copilot_node_command = "node";
      };
    };
    "diffview".enable = true;
    "gitsigns" = {
      enable = true;
      settings = {
        attach_to_untracked = true;
        current_line_blame = true;
        current_line_blame_formatter = "<author>, <author_time:%R> - <summary>";
        numhl = true;
        preview_config = {
          border = "rounded";
          style = "minimal";
        };
        signcolumn = true;
        signs = {
          add.text = "┃";
          change.text = "┃";
          changedelete.text = "~";
          delete.text = "_";
          topdelete.text = "‾";
          untracked.text = "┆";
        };
        watch_gitdir.follow_files = true;
        on_attach = {
          __raw = ''
            function(bufnr)
              local gitsigns = require("gitsigns")

              local function map(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
              end

              map("n", "]c", function()
                if vim.wo.diff then
                  vim.cmd.normal({ "]c", bang = true })
                else
                  gitsigns.nav_hunk("next")
                end
              end, "Next hunk")

              map("n", "[c", function()
                if vim.wo.diff then
                  vim.cmd.normal({ "[c", bang = true })
                else
                  gitsigns.nav_hunk("prev")
                end
              end, "Previous hunk")

              map("n", "<leader>hs", gitsigns.stage_hunk, "Stage hunk")
              map("n", "<leader>hr", gitsigns.reset_hunk, "Reset hunk")
              map("n", "<leader>hS", gitsigns.stage_buffer, "Stage buffer")
              map("n", "<leader>hu", gitsigns.undo_stage_hunk, "Undo stage hunk")
              map("n", "<leader>hR", gitsigns.reset_buffer, "Reset buffer")
              map("n", "<leader>hp", gitsigns.preview_hunk, "Preview hunk")
              map("n", "<leader>hb", function()
                gitsigns.blame_line({ full = true })
              end, "Blame line")
              map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "Toggle line blame")
              map("n", "<leader>hd", gitsigns.diffthis, "Diff this")
              map("n", "<leader>hD", function()
                gitsigns.diffthis("HEAD")
              end, "Diff against HEAD")
              map("n", "<leader>td", gitsigns.toggle_deleted, "Toggle deleted")
              map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
            end
          '';
        };
      };
    };
    "lualine" = {
      enable = true;
      settings = {
        options = {
          globalstatus = true;
          theme = "auto";
        };
        sections = {
          lualine_a = [ "mode" ];
          lualine_b = [
            "branch"
            "diff"
            "diagnostics"
          ];
          lualine_c = [ "filename" ];
          lualine_x = [
            "encoding"
            "fileformat"
            "filetype"
          ];
          lualine_y = [ "progress" ];
          lualine_z = [ "location" ];
        };
        inactive_sections = {
          lualine_a = [ ];
          lualine_b = [ ];
          lualine_c = [ "filename" ];
          lualine_x = [ "location" ];
          lualine_y = [ ];
          lualine_z = [ ];
        };
      };
    };
    "bufferline" = {
      enable = true;
      settings = {
        options = {
          diagnostics = "nvim_lsp";
          offsets = [
            {
              filetype = "neo-tree";
              text = "Files";
              text_align = "center";
            }
          ];
          show_buffer_close_icons = false;
          show_close_icon = false;
        };
      };
    };
    "neo-tree" = {
      enable = true;
      settings = {
        close_if_last_window = false;
        popup_border_style = "rounded";
        enable_git_status = true;
        enable_diagnostics = true;
        filesystem = {
          follow_current_file.enabled = true;
          filtered_items = {
            hide_dotfiles = true;
            hide_gitignored = true;
            hide_hidden = true;
            hide_by_name = [ "node_modules" ];
            always_show = [
              ".env"
              ".env.example"
              "eslint.config.js"
            ];
          };
          window = {
            mappings = {
              "<bs>" = "navigate_up";
              "." = "set_root";
              "/" = "fuzzy_finder";
              "D" = "fuzzy_finder_directory";
              "H" = "toggle_hidden";
              "f" = "filter_on_submit";
              "<c-x>" = "clear_filter";
              "[g" = "prev_git_modified";
              "]g" = "next_git_modified";
            };
          };
        };
        window = {
          position = "left";
          width = 30;
          mappings = {
            "<space>" = {
              command = "toggle_node";
              nowait = false;
            };
            "<cr>" = "open";
            "l" = "open";
            "h" = "close_node";
            "S" = "open_split";
            "s" = "open_vsplit";
            "t" = "open_tabnew";
            "w" = "open_with_window_picker";
            "P" = {
              command = "toggle_preview";
              config.use_float = true;
            };
            "z" = "close_all_nodes";
            "a" = {
              command = "add";
              config.show_path = "relative";
            };
            "A" = "add_directory";
            "d" = "delete";
            "r" = "rename";
            "y" = "copy_to_clipboard";
            "x" = "cut_to_clipboard";
            "p" = "paste_from_clipboard";
            "c" = "copy";
            "m" = "move";
            "q" = "close_window";
            "R" = "refresh";
            "?" = "show_help";
            "<" = "prev_source";
            ">" = "next_source";
          };
        };
      };
    };
    "nvim-autopairs".enable = true;
    "telescope" = {
      enable = true;
      extensions."fzf-native".enable = true;
      settings = {
        defaults = {
          layout_config = {
            horizontal = {
              prompt_position = "top";
            };
          };
          path_display = [ "truncate" ];
          prompt_prefix = " ";
          selection_caret = " ";
          sorting_strategy = "ascending";
          file_ignore_patterns = [
            "^.git/"
            "^node_modules/"
            "^coverage/"
            "^dist/"
            "^build/"
          ];
        };
        pickers.find_files = {
          hidden = true;
        };
      };
    };
    "web-devicons".enable = true;
    "which-key".enable = true;
  };
}
