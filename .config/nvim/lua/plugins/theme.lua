local M = {
  'folke/tokyonight.nvim',
  lazy = false,
  enabled = true,

  priority = 10000,
  config = function()

    require("tokyonight").setup({
      style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
      transparent = false, -- Enable this to disable setting the background color
      styles = {
        comments = {},
        keywords = {},
        functions = {},
        variables = {}
      },
      hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
      dim_inactive = false, -- dims inactive windows
      lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

      --- You can override specific color groups to use other groups or a hex color
      --- function will be called with a ColorScheme table
      on_colors = function(colors)
        colors.black = "#000000"
        colors.bg = "#000000"
        colors.bg_dark = "#000000"
        colors.bg_float = "#000000"
        colors.bg_highlight = "#333333"
        colors.bg_popup = "#000000"
        colors.bg_search = "#000000"
        colors.bg_sidebar = "#000000"
        colors.bg_statusline = "#000000"
        colors.bg_visual = "#333333"
        colors.black = "#000000"
      end,

      on_highlights = function(hl)
        hl.TreesitterContext = { bg = "#222222" }
      end,

    })
    vim.cmd [[ 
      colorscheme tokyonight-night
    ]]
  end

}

return M
