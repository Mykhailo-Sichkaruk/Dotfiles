return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    -- Optional pretty icons:
    "onsails/lspkind-nvim",
    -- If you use copilot-cmp, list it here so source "copilot" exists:
    -- "zbirenbaum/copilot-cmp",
  },
  config = function()
    local cmp = require("cmp")
    local lspkind_ok, lspkind = pcall(require, "lspkind")

    -- Don’t steal <Tab>; keep it free for Copilot’s accept
    vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect" }

    -- Build sources (add copilot only if available)
    local sources = {
      { name = "nvim_lsp" },
      { name = "path" },
      -- { name = "buffer" }, -- optional
    }
    local has_copilot = pcall(require, "copilot_cmp")
    if has_copilot then
      table.insert(sources, 1, { name = "copilot" })
    end

    cmp.setup({
      experimental = { ghost_text = true },

      -- No snippet engine: provide a NO-OP to satisfy cmp
      snippet = { expand = function(_) end },

      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"]     = cmp.mapping.abort(),
        ["<A-CR>"]    = cmp.mapping.confirm({ select = true }),

        -- Navigate with Alt+Tab / Alt+Shift+Tab (plus fallbacks for terminals)
        ["<A-Tab>"]   = cmp.mapping.select_next_item(),
        ["<M-Tab>"]   = cmp.mapping.select_next_item(),  -- alt synonym
        ["<A-S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<M-S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<S-Tab>"]   = cmp.mapping.select_prev_item(),  -- extra fallback
      }),

      sources = sources,

      formatting = lspkind_ok and {
        format = lspkind.cmp_format({
          mode = "symbol",
          maxwidth = 30,
          ellipsis_char = "...",
          before = function(_, item) return item end,
          symbol_map = { Copilot = "" },
        }),
      } or nil,
    })
  end,
}
