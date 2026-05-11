{
  plugins.conform-nvim = {
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
}
