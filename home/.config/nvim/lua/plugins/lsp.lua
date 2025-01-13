require('utils')

local M = {
  -- Collection of configurations for built-in LSP client
  'neovim/nvim-lspconfig',
  event = { 'BufReadPost' },
  enabled = true,
  branch = "master"
}

M.config = function()
  local nvim_lsp = require('lspconfig')
  local luasnip = require('luasnip')
  local on_attach = OnAttach
  local root_pattern = nvim_lsp.util.root_pattern

  nvim_lsp.dockerls.setup({})
  require("luasnip.loaders.from_snipmate").lazy_load(
      { paths = { "./snippets" } })

  -- TODO: verify does it solves bug with random jumps on tab
  luasnip.config.set_config({
    region_check_events = 'InsertEnter',
    delete_check_events = 'InsertLeave'
  })

  nvim_lsp.buf_ls.setup {}
  nvim_lsp.asm_lsp.setup({
    cmd = { "asm-lsp" },
    filetypes = { "asm", "vmasm", "nasm" },
    root_dir = root_pattern(".git", ".gitmodules", ".hg", ".bzr", ".svn")
  })

  nvim_lsp.ts_ls.setup({});

  local configs = require('lspconfig.configs')
  if not configs.typst then
    configs.typst = {
      default_config = {
        cmd = { "typst-lsp" },
        filetypes = { "typ", "typst" },
        root_dir = function(fname)
          return root_pattern(".git")(fname) or vim.loop.os_homedir()
        end,
        settings = {}
      }
    }
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
  capabilities.offsetEncoding = 'utf-16'
  capabilities.general = { positionEncodings = { 'utf-16' } }
  capabilities.experimental = { localDocs = true }

  local servers = {
    "bashls", "yamlls", "jsonls", "gopls", "cssls", "pyright", "html", "cmake",
    "vuels", "vimls"
  }
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      single_file_support = true
    }
  end

  nvim_lsp.jsonls.setup {
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
        end
      }
    }
  }
  nvim_lsp.typst.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      -- exportPdf = "onType"
      exportPdf = "onSave"
      -- exportPdf = "never",
    }
  }
  nvim_lsp.sqlls.setup {};
  vim.g.rust_recommended_style = 0;
  nvim_lsp.eslint.setup({
    root_dir = nvim_lsp.util.root_pattern(".eslintrc.json", ".eslintrc",
                                          ".eslintrc.js", "eslint.config.js"),
    settings = {
      codeAction = {
        disableRuleComment = { enable = true, location = "separateLine" },
        showDocumentation = { enable = true }
      },
      codeActionOnSave = { enable = true, mode = "all" },
      experimental = { useFlatConfig = false },
      useFlatConfig = false,
      format = true,
      nodePath = "node_modules/",
      onIgnoredFiles = "on",
      problems = { shortenToSingleLine = false },
      quiet = false,
      rulesCustomizations = {},
      run = "onSave",
      useESLintClass = false,
      validate = "on",
      workingDirectory = { mode = "auto" }
    },
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      vim.api.nvim_create_autocmd("BufWritePre",
                                  { buffer = bufnr, command = "EslintFixAll" })
    end
  })

  vim.g.rust_recommended_style = 1;
  nvim_lsp.rust_analyzer.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      ['rust-analyzer'] = {
        cargo = { allFeatures = true },
        -- hoverActions = { linksInHover = true },
        checkOnSave = {
          allFeatures = true,
          overrideCommand = {
            'cargo', 'clippy', '--workspace', '--message-format=json',
            '--all-targets', '--all-features'
          }
        }
      }
    }
  }

  -- nvim_lsp.java_language_server.setup {
  --   on_attach = on_attach,
  --   capabilities = capabilities,
  --   cmd = { "/home/ms/java-language-server/dist/lang_server_linux.sh" },
  --   filetypes = { "java" }
  --   -- settings = {},
  -- }

  nvim_lsp.texlab.setup {
    capabilities = capabilities,
    settings = {
      latex = {
        build = {
          args = {
            "-pdf", "-interaction=nonstopmode", "-synctex=1", "-outdir=./build",
            "%f"
          },
          outputDirectory = "./build",
          onSave = true
        },
        lint = { onChange = true }
      }
    },
    on_attach = on_attach
  }

  nvim_lsp.lua_ls.setup {
    on_init = function(client)
      local path = client.workspace_folders[1].name
      if not vim.loop.fs_stat(path .. '/.luarc.json') and
          not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
        client.config.settings = vim.tbl_deep_extend('force',
                                                     client.config.settings, {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
              library = vim.api.nvim_get_runtime_file("", true)
            }
          }
        })

        client.notify("workspace/didChangeConfiguration",
                      { settings = client.config.settings })
      end
      return true
    end
  }

  nvim_lsp.clangd.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "cpp", "c" },
    cmd = {
      'clangd', '--header-insertion=never', '--suggest-missing-includes',
      '--background-index', '-j=8', '--cross-file-rename',
      '--pch-storage=memory', '--clang-tidy', -- '-std=c11',
      '--clang-tidy-checks=-clang-analyzer-*,bugprone-*,misc-*,-misc-non-private-member-variables-in-classes,performance-*,-performance-no-automatic-move,modernize-use-*,-modernize-use-nodiscard,-modernize-use-trailing-return-type'
      -- '--compile-commands-dir=build'
    },
    -- on_init = require'clangd_nvim'.on_init,
    -- callbacks = lsp_status.extensions.clangd.setup(),
    init_options = {
      clangdFileStatus = true,
      usePlaceholders = true,
      completeUnimported = true
    },
    offset_encoding = "utf-16"
  }

  -- nvim_lsp.ccls.setup {
  --   on_attach = on_attach,
  --   capabilities = capabilities,
  --   cmd = { "ccls" },
  --   filetypes = { "c", "cpp", "objc", "objcpp" },
  --   single_file_support = true,
  --   init_options = {
  --     compilationDatabaseDirectory = "build",
  --     index = { threads = 0 },
  --     cache = { directory = os.getenv("XDG_CACHE_HOME") .. "/ccls" },
  --     clang = {
  --       extraArgs = {
  --         "-std=c++23", "-Wall", "-Wextra", "-Wno-logical-op-parentheses", "--std=c17"
  --       },
  --       -- extraArgs = { "-Wall", "-Wextra", "-Wno-logical-op-parentheses" },
  --       excludeArgs = { "-frounding-math" }
  --     },
  --     client = { snippetSupport = true }
  --   kj}
  -- }
  nvim_lsp.emmet_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "html", "css", "typescriptreact", "javascriptreact" }
  })

  nvim_lsp.luau_lsp.setup({})
  nvim_lsp.nixd.setup({
    settings = { nixd = { formatting = { command = { "nixfmt" } } } }
  })
end

M.init = function()
  -- Mappings
  Map('n', 'gD', function() vim.lsp.buf.declaration() end)
  Map('n', 'gd', function() vim.lsp.buf.definition() end)
  Map('n', 'gI', function() vim.lsp.buf.implementation() end)
  Map('n', 'gr', function() vim.lsp.buf.references() end)

  Map('n', 'K', function() vim.lsp.buf.hover() end)
  Map('n', '<F2>', function() vim.lsp.buf.rename() end)
  Map('n', '<leader>a', function() vim.lsp.buf.code_action() end)
  Map('v', '<leader>a', function() vim.lsp.buf.code_action() end)
  Map('n', '<leader>D', function() vim.lsp.buf.type_definition() end)

  Map('n', '<leader>e', function() vim.diagnostic.open_float() end)
  Map('n', '[d', function() vim.diagnostic.goto_prev() end)
  Map('n', ']d', function() vim.diagnostic.goto_next() end)
  Map('n', '<leader>q', function() vim.diagnostic.setloclist() end)
  Map('n', '<leader>rn', function() vim.lsp.buf.rename() end)

  local function open_local_docs(_, url)
    if url == nil then
      print("nil")
      return
    end
    vim.fn["netrw#BrowseX"](url["local"], 0)
  end

  Map('n', '<leader>rd', function()
    vim.lsp.buf_request(0, "experimental/externalDocs",
                        vim.lsp.util.make_position_params(), open_local_docs)
  end)
  Map('v', '<leader>rd', function()
    vim.lsp.buf_request(0, "experimental/externalDocs",
                        vim.lsp.util.make_position_params(), open_local_docs)
  end)

  -- Map('n', '<leader>ha', function () vim.lsp.buf.add_workspace_folder() end)
  -- Map('n', '<leader>hr', function () vim.lsp.buf.remove_workspace_folder() end)
  -- Map('n', '<leader>hl',
  --     function () print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end)

  -- Map('n', 'gs', '<Cmd>ClangdSwitchSourceHeader<CR>')
  -- Map('n', '<A-k>', function () vim.lsp.buf.signature_help() end)
end
M.dependencies = {
  'hrsh7th/nvim-cmp', --
  'hrsh7th/cmp-path', --
  'hrsh7th/cmp-nvim-lsp', --
  'onsails/lspkind-nvim', --
  -- 'SmiteshP/nvim-navic',
  {
    "L3MON4D3/LuaSnip",
    -- dependencies = "saadparwaiz1/cmp_luasnip",
    build = "make install_jsregexp"
  }, {
    'RishabhRD/nvim-lsputils',
    dependencies = { 'RishabhRD/popfix' },
    config = function()
      vim.lsp.handlers['textDocument/codeAction'] =
          require'lsputil.codeAction'.code_action_handler
      vim.lsp.handlers['textDocument/references'] =
          require'lsputil.locations'.references_handler
      vim.lsp.handlers['textDocument/definition'] =
          require'lsputil.locations'.definition_handler
      vim.lsp.handlers['textDocument/declaration'] =
          require'lsputil.locations'.declaration_handler
      vim.lsp.handlers['textDocument/typeDefinition'] =
          require'lsputil.locations'.typeDefinition_handler
      vim.lsp.handlers['textDocument/implementation'] =
          require'lsputil.locations'.implementation_handler
      vim.lsp.handlers['textDocument/documentSymbol'] =
          require'lsputil.symbols'.document_handler
      vim.lsp.handlers['workspace/symbol'] =
          require'lsputil.symbols'.workspace_handler
    end
  }
}

return M
