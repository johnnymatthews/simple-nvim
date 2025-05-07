--[[
  Simple Nvim - Consolidated Configuration File
  
  This file combines all configuration from:
  - init.lua
  - lua/options.lua
  - lua/mappings.lua
  - lua/commands.lua
  - lua/plugins/init.lua
  - and all plugin-specific configuration files
]]--

--------------------------------------------------------------------------------
-- OPTIONS (from lua/options.lua)
--------------------------------------------------------------------------------

local opt = vim.opt

vim.g.mapleader = " "

opt.laststatus = 3 -- global statusline
opt.showmode = false

opt.clipboard = ""
opt.scrolloff= 999

-- Indenting
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2

opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

-- Numbers
opt.number = true
opt.relativenumber = true
opt.ruler = false

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.timeoutlen = 400
opt.undofile = true

opt.timeoutlen = 400
opt.updatetime = 250

-- add binaries installed by mason.nvim to path
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
vim.env.PATH = vim.env.PATH .. (is_windows and ";" or ":") .. vim.fn.stdpath "data" .. "/mason/bin"

--------------------------------------------------------------------------------
-- MAPPINGS (from lua/mappings.lua)
--------------------------------------------------------------------------------

local map = vim.keymap.set

-- General
map("n", "<C-c>", "<cmd> %y+ <CR>") -- Copy current file to clipboard.

-- Nvim Tree
map("n", "<C-n>", "<cmd> NvimTreeToggle <CR>") -- Toggle sidebar navigation.

-- Telescope
map("n", "<leader>ff", "<cmd> Telescope find_files <CR>") -- Find file by filename.
map("n", "<leader>fo", "<cmd> Telescope oldfiles <CR>") -- Find files that you recently opened.
map("n", "<leader>fw", "<cmd> Telescope live_grep <CR>") -- Search for files by their content.

-- Tabs
map("n", "<Tab>", "<cmd> BufferLineCycleNext <CR>") -- Move right one tab.
map("n", "<S-Tab>", "<cmd> BufferLineCyclePrev <CR>") -- Move left one tab.
map("n", "<C-q>", "<cmd> bd <CR>") -- Close a tab.

-- Floating Terminal
map("n", "<leader>ft", "<cmd> ToggleTerm direction=float<CR>") -- Open a floating terminal.
map("n", "<leader>fg", "<cmd>lua require('toggleterm.terminal').Terminal:new({cmd='lazygit', direction='float', dir=vim.fn.expand('%:p:h')}):toggle()<CR>")

-- Undo tree
map("n", "<leader>u", "<cmd>lua require('undotree').toggle()<CR>") -- Show or hide Undotree on the left.

-- Make :W work like :w and :Q work like :q
vim.cmd('cnoreabbrev W w')
vim.cmd('cnoreabbrev Q q')

--------------------------------------------------------------------------------
-- COMMANDS (from lua/commands.lua)
--------------------------------------------------------------------------------

-- mason, write correct names only
vim.api.nvim_create_user_command("MasonInstallAll", function()
  vim.cmd "MasonInstall css-lsp html-lsp lua-language-server typescript-language-server stylua prettier"
end, {})

--------------------------------------------------------------------------------
-- PLUGINS AND LAZY.NVIM SETUP (from init.lua and lua/plugins/init.lua)
--------------------------------------------------------------------------------

-- bootstrap plugins & lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim" -- path where its going to be installed

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)

-- Plugin configurations (will be loaded within the plugin specifications below)
-- These would normally be in separate files but are included here for consolidated setup

-- Bufferline Configuration
local bufferline_config = function()
  require("bufferline").setup {
    options = {
      themable = true,
      offsets = {
        { filetype = "NvimTree", highlight = "NvimTreeNormal" },
      },
    },
  }
end

-- Telescope Configuration
local telescope_config = function()
  require("telescope").setup {
    defaults = {
      sorting_strategy = "ascending",
      layout_config = {
        horizontal = { prompt_position = "top" },
      },
    },
  }
end

-- Treesitter Configuration
local treesitter_config = function()
  require("nvim-treesitter.configs").setup {
    ensure_installed = { "lua", "vim", "vimdoc", "tsx", "html", "css", "typescript", "javascript" },
    highlight = {
      enable = true,
      use_languagetree = true,
    },
    indent = { enable = true },
  }
end

-- Undotree Configuration
local undotree_config = function()
  local undotree = require('undotree')
  undotree.setup({
    float_diff = true,  -- using float window previews diff, set this `true` will disable layout option
    layout = "left_bottom", -- "left_bottom", "left_left_bottom"
    position = "left", -- "right", "bottom"
    ignore_filetype = { 'undotree', 'undotreeDiff', 'qf', 'TelescopePrompt', 'spectre_panel', 'tsplayground' },
    window = {
      winblend = 30,
    },
    keymaps = {
      ['j'] = "move_next",
      ['k'] = "move_prev",
      ['J'] = "move_change_next",
      ['K'] = "move_change_prev",
      ['<cr>'] = "action_enter",
      ['p'] = "enter_diffbuf",
      ['q'] = "quit",
    },
  })
end

-- CMP Configuration
local cmp_config = function()
  local cmp = require "cmp"

  cmp.setup {
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert {
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm { select = true },

      -- luasnip
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif require("luasnip").expand_or_jumpable() then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif require("luasnip").jumpable(-1) then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
    },
    sources = cmp.config.sources {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "nvim_lua" },
      { name = "path" },
    },
  }
end

-- LSPConfig Configuration
local lspconfig_setup = function()
  -- Global mappings.
  vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
  vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

  -- Use LspAttach autocommand to only map the following keys
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
      -- Enable completion triggered by <c-x><c-o>
      vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

      local opts = { buffer = ev.buf }
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
      vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
      vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
      vim.keymap.set("n", "<space>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts)
      vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
      vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
      vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      -- vim.keymap.set("n", "<space>f", function()
      --   vim.lsp.buf.format { async = true }
      -- end, opts)
    end,
  })

  local capabilities = vim.lsp.protocol.make_client_capabilities()

  capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
      properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
      },
    },
  }
  -- Setup language servers.
  local lspconfig = require "lspconfig"

  lspconfig.lua_ls.setup {
    capabilities = capabilities,
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
      },
    },
  }

  -- setup multiple servers with same default options
  local servers = { "ts_ls", "html", "cssls" }

  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
      capabilities = capabilities,
    }
  end
end

-- Lazy.nvim Configuration
local lazy_config = {
  install = { colorscheme = { "nightfox" } },
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
}

-- Plugin list with configurations
local plugins = {
  -- A bunch of pre-written functions that other plugins make use of.
  { 
    "nvim-lua/plenary.nvim",
    lazy = true
  },

  -- A theme that I do use, and like very much.
  { 
    "catppuccin/nvim", 
    name = "catppuccin", 
    priority = 1000 
  },

  -- Show a floating terminal to quickly do terminal stuff.

  -- A nice sidebar File Tree. Open with CTRL + `n`.
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
          side = 'right'
        },
        filters = {
          dotfiles = true,
        },
        git = {
          enable = true,
          ignore = false,
          timeout = 500,
        },
      })
    end,
  },

  -- icons, for UI related plugins
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup()
    end,
  },

  {
  "akinsho/toggleterm.nvim", 
  version = "*", 
  config = function()
    require("toggleterm").setup({
      -- Default configuration options
      size = function(term)
        if term.direction == "horizontal" then

          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,

      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",

      close_on_exit = true,

      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
      -- This is the key setting that makes the terminal open in the current directory
      dir = function()
        -- Get the directory of the current buffer
        local buf_dir = vim.fn.expand("%:p:h")
        return buf_dir
      end,
    })
  end
},

  -- syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = treesitter_config,
  },

  -- buffer + tab line
  {
    "akinsho/bufferline.nvim",
    event = "BufReadPre",
    config = bufferline_config,
  },

  -- statusline
  {
    "echasnovski/mini.statusline",
    config = function()
      require("mini.statusline").setup { set_vim_settings = false }
    end,
  },

  -- we use cmp plugin only when in insert mode
  -- so lets lazyload it at InsertEnter event, to know all the events check h-events
  -- completion , now all of these plugins are dependent on cmp, we load them after cmp
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- cmp sources
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",

      -- snippets
      --list of default snippets
      "rafamadriz/friendly-snippets",

      -- snippets engine
      {
        "L3MON4D3/LuaSnip",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },

      -- autopairs , autocompletes ()[] etc
      {
        "windwp/nvim-autopairs",
        config = function()
          require("nvim-autopairs").setup()

          --  cmp integration
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          local cmp = require "cmp"
          cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },
    },
    config = cmp_config,
  },

  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonInstall" },
    config = function()
      require("mason").setup()
    end,
  },

  -- lsp
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = lspconfig_setup,
  },

  -- indent lines
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("ibl").setup()
    end,
  },

  -- files finder etc
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    config = telescope_config,
  },

  -- git status on signcolumn etc
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- comment plugin
  {
    "numToStr/Comment.nvim",
    lazy = true,
    config = function()
      require("Comment").setup()
    end,
  },

  -- undo tree.
  {
    "jiaoshijie/undotree",
    dependencies  = {
      "nvim-lua/plenary.nvim",
    },
    config = undotree_config,
  },
}

-- Initialize lazy with the plugins
require("lazy").setup(plugins, lazy_config)

--------------------------------------------------------------------------------
-- THEME SETUP (from init.lua final lines)
--------------------------------------------------------------------------------

vim.o.termguicolors = true
vim.cmd "colorscheme catppuccin-mocha"
