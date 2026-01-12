require("utils")

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local on_attach = OnAttach or nil

      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        vim.lsp.config("*", {
          on_attach = on_attach,
          capabilities = cmp_lsp.default_capabilities()
        })
      elseif on_attach then
        vim.lsp.config("*", { on_attach = on_attach })
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
        callback = function(ev)
          local b = { buffer = ev.buf, silent = true, noremap = true }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, b)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, b)
          vim.keymap.set("n", "gI", vim.lsp.buf.implementation, b)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, b)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, b)
          vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, b)
          vim.keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, b)
          vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, b)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, b)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, b)
          vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, b)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, b)
        end
      })

      vim.lsp.enable("ts_ls")
      vim.lsp.enable("vue_ls")
      vim.lsp.enable("rust_analyzer")

      vim.lsp.config("rust_analyzer", {
        cmd = {
          "/nix/store/9xfh661pswmwz5z7warwmhj8chr7bvbf-home-manager-path/bin/rust-analyzer"
        },
        settings = {
          ["rust-analyzer"] = {
            cargo = { target = "xtensa-esp32-espidf" },
            check = { allTargets = false }
          }
        }
      })

      vim.lsp.enable("dockerls")
      vim.lsp.enable("protols")
      vim.lsp.enable("docker_compose_language_service")
      vim.lsp.enable("buf_ls")
      vim.lsp.enable("jsonls")
      vim.lsp.enable("eslint")
    end
  }
}

