require("utils")

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- If you still want your OnAttach (semantic tokens off, format key), use it here:
      local on_attach = OnAttach or nil

      -- Capabilities for cmp (even if we don't use snippets)
      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        vim.lsp.config("*", {
          on_attach = on_attach,
          capabilities = cmp_lsp.default_capabilities(),
        })
      elseif on_attach then
        vim.lsp.config("*", { on_attach = on_attach })
      end

      -- Your LSP buffer keymaps (once, on attach)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
        callback = function(ev)
          local b = { buffer = ev.buf, silent = true, noremap = true }
          vim.keymap.set("n", "gD",  vim.lsp.buf.declaration, b)
          vim.keymap.set("n", "gd",  vim.lsp.buf.definition, b)
          vim.keymap.set("n", "gI",  vim.lsp.buf.implementation, b)
          vim.keymap.set("n", "gr",  vim.lsp.buf.references, b)
          vim.keymap.set("n", "K",   vim.lsp.buf.hover, b)
          vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, b)
          vim.keymap.set({ "n","v" }, "<leader>a", vim.lsp.buf.code_action, b)
          vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, b)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, b)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, b)
          vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, b)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, b)
        end,
      })

      -- Enable servers (ts_ls for TS/JS; vue_ls for .vue templates/CSS/HTML)
      vim.lsp.enable("ts_ls")
      vim.lsp.enable("vue_ls")
      vim.lsp.enable("rust_analyzer")

      -- your others:
      vim.lsp.enable("dockerls")
      vim.lsp.enable("protols")
      vim.lsp.enable("docker_compose_language_service")
      vim.lsp.enable("buf_ls")
      vim.lsp.enable("jsonls")
    end,
  },
}

