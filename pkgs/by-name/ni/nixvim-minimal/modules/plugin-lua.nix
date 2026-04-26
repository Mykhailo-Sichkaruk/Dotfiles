{
  extraConfigLuaPost = ''
    vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect" }

    vim.diagnostic.config({
      severity_sort = true,
      underline = true,
      update_in_insert = false,
      virtual_text = false,
      float = {
        border = "rounded",
        source = "if_many",
      },
    })

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover,
      { border = "rounded" }
    )

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
      vim.lsp.handlers.signature_help,
      { border = "rounded" }
    )

    pcall(function()
      require("telescope").load_extension("fzf")
    end)

    pcall(function()
      require("Comment.ft").set("helm", "#%s")
    end)

    pcall(function()
      require("git-conflict").setup({})
    end)

    pcall(function()
      require("octo").setup({
        enable_builtin = true,
        picker = "telescope",
        notifications = {
          current_repo_only = false,
        },
      })
    end)

    pcall(function()
      require("hop").setup({
        keys = "asdfghjkl;eiurtcxm,",
      })
    end)

    pcall(function()
      require("nvim-surround").setup({})
    end)

    pcall(function()
      require("outline").setup({})
    end)

    pcall(function()
      require("todo-comments").setup({
        signs = false,
        keywords = {
          FIX = { alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
          HACK = { alt = { "FUCK", "SHIT", "BAD" } },
          NOTE = { alt = { "INFO", "SAFETY" } },
          ASSUMPTION = { alt = { "AXIOM", "ASSUME" } },
          WHERE_AM_I_GOING_WITH_THIS = { alt = { "WTF", "WAIGWT" } },
        },
      })
    end)

    local cmp = require("cmp")

    cmp.setup({
      experimental = { ghost_text = true },
      preselect = cmp.PreselectMode.None,
      snippet = {
        expand = function(_) end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<A-CR>"] = cmp.mapping.confirm({ select = true }),
        ["<A-Tab>"] = cmp.mapping.select_next_item(),
        ["<M-Tab>"] = cmp.mapping.select_next_item(),
        ["<A-S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<M-S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
      }),
      sources = {
        { name = "nvim_lsp" },
        { name = "path" },
      },
    })
  '';
}
