local M = {
  'folke/tokyonight.nvim',
  lazy = false,
  enabled = true,

  priority = 10000,
  config = function()
    local tokyo = require("tokyonight")
    tokyo.setup({
      style = "night",
      styles = {
         functions = {}
      },
      colors = {
      },
      on_colors = function(colors)
        colors.black = "#000000"
        colors.bg = "#000000"
        -- colors.bg_dark = "#0ff000"
        -- colors.bg_float = "#2f2f2f"
        colors.bg_highlight = "#333333"
        colors.bg_popup = "#000000"
        -- colors.bg_search = "#ff00ff"
        colors.bg_sidebar = "#000000"
        colors.bg_statusline = "#000000"
        colors.bg_visual = "#ff3333"
        colors.black = "#000000"
        colors.CursorLine = {
          bg = "#292e42"
        }
        colors.CursorLineNr = {
          fg = "#ffffff"
        }
      end
    })
    vim.cmd [[ 
      colorscheme tokyonight-night
      ]]
  end

}

return M
