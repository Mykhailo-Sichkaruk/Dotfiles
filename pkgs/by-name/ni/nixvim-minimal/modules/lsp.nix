{
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
        settings.workingDirectory.mode = "auto";
      };

      lua_ls = {
        enable = true;
        packageFallback = true;
        settings.Lua = {
          completion.callSnippet = "Replace";
          diagnostics.globals = [ "vim" ];
          telemetry.enable = false;
          workspace.checkThirdParty = false;
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
        extraOptions.init_options.maxTsServerMemory = 8192;
      };
    };
  };
}
