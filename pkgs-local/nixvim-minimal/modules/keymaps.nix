{
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
      action.__raw = ''
        function()
          require("hop").hint_char1()
        end
      '';
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
      key = "<leader>oa";
      action = "<cmd>Octo actions<CR>";
      options.desc = "Octo actions";
    }
    {
      mode = "n";
      key = "<leader>oi";
      action = "<cmd>Octo issue list<CR>";
      options.desc = "Octo issues";
    }
    {
      mode = "n";
      key = "<leader>op";
      action = "<cmd>Octo pr list<CR>";
      options.desc = "Octo pull requests";
    }
    {
      mode = "n";
      key = "<leader>on";
      action = "<cmd>Octo notification list<CR>";
      options.desc = "Octo notifications";
    }
    {
      mode = "n";
      key = "<leader>os";
      action.__raw = ''
        function()
          require("octo.utils").create_base_search_command({ include_current_repo = true })
        end
      '';
      options.desc = "Octo search";
    }
    {
      mode = "n";
      key = "<leader>o/";
      action = "<cmd>Octo<CR>";
      options.desc = "Octo command picker";
    }
    {
      mode = "n";
      key = "<leader>j";
      action.__raw = ''
        function()
          require("hop").hint_lines()
        end
      '';
      options.desc = "Hop lines";
    }
    {
      mode = "n";
      key = "<leader>k";
      action.__raw = ''
        function()
          require("hop").hint_lines()
        end
      '';
      options.desc = "Hop lines";
    }
    {
      mode = "n";
      key = "<leader>l";
      action.__raw = ''
        function()
          require("hop").hint_words()
        end
      '';
      options.desc = "Hop words";
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>gp";
      action.__raw = ''
        function()
          require("conform").format({
            async = true,
            lsp_format = "fallback",
          })
        end
      '';
      options.desc = "Format buffer";
    }
    {
      mode = "n";
      key = "<leader>s";
      action.__raw = ''
        function()
          require("hop").hint_char2()
        end
      '';
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
}
