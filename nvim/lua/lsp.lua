local api = vim.api
local map = vim.keymap.set

local setup = function()
  local lsp_group = api.nvim_create_augroup("lsp", { clear = true })

  local on_attach = function(client, bufnr)
    map("n", "<leader>awf", vim.lsp.buf.add_workspace_folder)
    map("n", "<leader>ca", vim.lsp.buf.code_action)
    vim.keymap.set("n", "<F3>", function()
      vim.lsp.buf.format({ async = true })
    end)
    map("n", "<leader>cl", vim.lsp.codelens.run)
    map("n", "F2", vim.lsp.buf.rename)
    map("n", "<leader>sh", vim.lsp.buf.signature_help)
    map("n", "K", vim.lsp.buf.hover)
    map("n", "gd", vim.lsp.buf.definition)
    vim.keymap.set("n", "gds", vim.lsp.buf.document_symbol)
    map("n", "gi", vim.lsp.buf.implementation)
    map("n", "gr", vim.lsp.buf.references)
    map("n", "gtD", vim.lsp.buf.type_definition)
    vim.keymap.set("n", "gws", vim.lsp.buf.workspace_symbol)
    map("n", "<leader>h", function()
      if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      else
        vim.notify("Server is not an inlayhint provider", vim.log.levels.ERROR)
      end
    end)

    local opts = { silent = true }
    opts.desc = "Show buffer diagnostics"
    map("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

    opts.desc = "Show line diagnostics"
    map("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

    vim.keymap.set("n", "[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end)
    vim.keymap.set("n", "]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end)

    opts.desc = "Show documentation for what is under cursor"
    map("n", "K", vim.lsp.buf.hover, opts)
    ----------------------------------------------------

    api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

    vim.keymap.set("n", "<leader>mc", require("telescope").extensions.metals.commands)
  end
  -- format on save
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
      vim.lsp.buf.format({ async = false })
    end,
    group = lsp_group,
  })

  ------------------------------------------------
  -- Metals specific setup
  ------------------------------------------------
  local metals_config = require("metals").bare_config()

  metals_config.tvp = {
    icons = {
      enabled = true,
    },
  }

  metals_config.settings = {
    defaultBspToBuildTool = true,
    enableSemanticHighlighting = false,
    inlayHints = {
      byNameParameters = { enable = true },
      hintsInPatternMatch = { enable = true },
      implicitArguments = { enable = true },
      implicitConversions = { enable = true },
      inferredTypes = { enable = true },
      typeParameters = { enable = true },
    },
    serverVersion = "latest.snapshot",
    -- startMcpServer = true,
    -- mcpClient = "claude",
    --serverVersion = "1.6.1-SNAPSHOT",
    --testUserInterface = "Test Explorer"
  }

  metals_config.init_options = {
    statusBarProvider = "off",
    icons = "unicode",
  }

  metals_config.on_attach = function(client, bufnr)
    on_attach(client, bufnr)

    map("v", "K", require("metals").type_of_range)

    map("n", "<leader>ws", function()
      require("metals").hover_worksheet({ border = "single" })
    end)

    map("n", "<leader>tt", require("metals.tvp").toggle_tree_view)

    map("n", "<leader>tr", require("metals.tvp").reveal_in_tree)

    map("n", "<leader>mmc", require("metals").commands)

    -- A lot of the servers I use won't support document_highlight or codelens,
    -- so we juse use them in Metals
    api.nvim_create_autocmd("CursorHold", {
      callback = vim.lsp.buf.document_highlight,
      buffer = bufnr,
      group = lsp_group,
    })
    api.nvim_create_autocmd("CursorMoved", {
      callback = function()
        vim.lsp.buf.clear_references()
      end,
      buffer = bufnr,
      group = lsp_group,
    })
    api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
      callback = vim.lsp.codelens.refresh,
      buffer = bufnr,
      group = lsp_group,
    })
  end

  local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
  api.nvim_create_autocmd("FileType", {
    pattern = { "scala", "sbt", "java" },
    callback = function()
      require("metals").initialize_or_attach(metals_config)
    end,
    group = nvim_metals_group,
  })

  api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.worksheet.sc" },
    callback = function()
      vim.lsp.inlay_hint.enable(true)
    end,
    group = nvim_metals_group,
  })

  ------------------------------------------------
  -- END
  ------------------------------------------------

  -- Helper to wrap on_attach with executable check
  local function on_attach_with_check(cmd_name)
    return function(client, bufnr)
      if vim.fn.executable(cmd_name) == 0 then
        vim.notify(
          string.format("LSP server '%s' is configured but '%s' is not installed", client.name, cmd_name),
          vim.log.levels.WARN
        )
      end
      on_attach(client, bufnr)
    end
  end

  vim.lsp.config.lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = {
      ".luarc.json",
      ".luarc.jsonc",
      ".luacheckrc",
      ".stylua.toml",
      "stylua.toml",
      "selene.toml",
      "selene.yml",
      ".git",
    },
    on_attach = on_attach_with_check("lua-language-server"),
    commands = {
      Format = {
        function()
          require("stylua-nvim").format_file()
        end,
      },
    },
    settings = {
      Lua = {
        diagnostics = { globals = { "vim", "it", "describe", "before_each" } },
        telemetry = { enable = false },
      },
    },
  }
  vim.lsp.enable("lua_ls")

  vim.lsp.config.jsonls = {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
    root_markers = { "package.json", ".git" },
    on_attach = on_attach_with_check("vscode-json-language-server"),
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
        end,
      },
    },
  }
  vim.lsp.enable("jsonls")

  vim.lsp.config.yamlls = {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml", "yml", "yaml.docker-compose", "yaml.gitlab" },
    root_markers = { ".git" },
    on_attach = on_attach_with_check("yaml-language-server"),
    settings = {
      yaml = {
        schemas = {
          ["https://raw.githubusercontent.com/oyvindberg/bleep/master/schema.json"] = "bleep.yaml",
        },
      },
    },
  }
  vim.lsp.enable("yamlls")

  -- These server just use the vanilla setup
  local servers = {
    {
      name = "bashls",
      cmd = { "bash-language-server", "start" },
      filetypes = { "sh", "bash" },
      root_markers = { ".git" },
    },
    {
      name = "dockerls",
      cmd = { "docker-langserver", "--stdio" },
      filetypes = { "dockerfile" },
      root_markers = { "Dockerfile", ".git" },
    },
    {
      name = "html",
      cmd = { "vscode-html-language-server", "--stdio" },
      filetypes = { "html" },
      root_markers = { "package.json", ".git" },
    },
    {
      name = "ts_ls",
      cmd = { "typescript-language-server", "--stdio" },
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
    },
    {
      name = "gopls",
      cmd = { "gopls" },
      filetypes = { "go", "gomod", "gowork", "gotmpl" },
      root_markers = { "go.mod", "go.work", ".git" },
    },
    {
      name = "basedpyright",
      cmd = { "basedpyright-langserver", "--stdio" },
      filetypes = { "python" },
      root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
    },
  }
  for _, server in pairs(servers) do
    vim.lsp.config[server.name] = {
      cmd = server.cmd,
      filetypes = server.filetypes,
      root_markers = server.root_markers,
      on_attach = on_attach_with_check(server.cmd[1]),
    }
    vim.lsp.enable(server.name)
  end

  -- Uncomment for trace logs from neovim
  -- vim.lsp.set_log_level('trace')
end

return {
  setup = setup,
}
