{
  colorschemes.tokyonight = {
    enable = true;
    settings = {
      style = "night";
      transparent = false;
      styles = {
        comments = { };
        keywords = { };
        functions = { };
        variables = { };
      };
      hide_inactive_statusline = false;
      dim_inactive = false;
      lualine_bold = false;
      on_colors = ''
        function(colors)
          colors.black = "#000000"
          colors.bg = "#000000"
          colors.bg_dark = "#222222"
          colors.bg_float = "#000000"
          colors.bg_highlight = "#333333"
          colors.fg_highlight = "#ff0000"
          colors.bg_popup = "#000000"
          colors.bg_search = "#880000"
          colors.bg_sidebar = "#000000"
          colors.bg_statusline = "#000000"
          colors.bg_visual = "#333333"
        end
      '';
      on_highlights = ''
        function(hl)
          hl.TreesitterContext = { bg = "#222222" }
          hl.DiagnosticUnnecessary = { fg = "#ffffff" }
          hl.ScrollbarSearch = { bg = "#ff0000", fg = "#ff0000" }
          hl.IncSearch = { bg = "#bbbbbb", fg = "#000000" }
          hl.Search = { bg = "#3d59a1", fg = "#ff0000" }
        end
      '';
    };
  };
}
