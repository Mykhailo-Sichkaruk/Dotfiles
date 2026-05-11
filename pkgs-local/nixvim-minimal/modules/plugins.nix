{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [
    git-conflict-nvim
    hop-nvim
    nvim-surround
    octo-nvim
    outline-nvim
    todo-comments-nvim
  ];

  plugins = {
    cmp = {
      enable = true;
      autoLoad = true;
    };

    cmp-nvim-lsp.enable = true;
    cmp-path.enable = true;
    comment.enable = true;

    copilot-lua = {
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

    diffview.enable = true;

    gitsigns = {
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
        on_attach.__raw = ''
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

    lualine = {
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

    bufferline = {
      enable = true;
      settings.options = {
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

    neo-tree = {
      enable = true;
      settings = {
        close_if_last_window = false;
        popup_border_style = "rounded";
        enable_git_status = true;
        enable_diagnostics = true;
        filesystem = {
          follow_current_file.enabled = true;
          filtered_items = {
            hide_dotfiles = false;
            hide_gitignored = true;
            hide_by_name = [ ];
            always_show = [ ];
          };
          window.mappings = {
            "<bs>" = "navigate_up";
            "." = "set_root";
            "/" = "fuzzy_finder";
            D = "fuzzy_finder_directory";
            H = "toggle_hidden";
            f = "filter_on_submit";
            "<c-x>" = "clear_filter";
            "[g" = "prev_git_modified";
            "]g" = "next_git_modified";
          };
        };
        git_status.window = {
          position = "float";
          mappings = {
            A = "git_add_all";
            gu = "git_unstage_file";
            ga = "git_add_file";
            gc = "git_commit";
            gp = "git_push";
            gg = "git_commit_and_push";
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
            l = "open";
            h = "close_node";
            S = "open_split";
            s = "open_vsplit";
            t = "open_tabnew";
            w = "open_with_window_picker";
            P = {
              command = "toggle_preview";
              config.use_float = true;
            };
            z = "close_all_nodes";
            a = {
              command = "add";
              config.show_path = "relative";
            };
            A = "add_directory";
            d = "delete";
            r = "rename";
            y = "copy_to_clipboard";
            x = "cut_to_clipboard";
            p = "paste_from_clipboard";
            c = "copy";
            m = "move";
            q = "close_window";
            R = "refresh";
            "?" = "show_help";
            "<" = "prev_source";
            ">" = "next_source";
          };
        };
      };
    };

    nvim-autopairs.enable = true;

    telescope = {
      enable = true;
      extensions.fzf-native.enable = true;
      settings = {
        defaults = {
          layout_config.horizontal.prompt_position = "top";
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
        pickers.find_files.hidden = true;
      };
    };

    web-devicons.enable = true;
    which-key.enable = true;
  };
}
