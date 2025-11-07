-- OPTIONS
----------

local opt = vim.opt

vim.g.mapleader = " "

opt.laststatus = 3 -- global statusline
opt.showmode = false

opt.clipboard = ""
opt.scrolloff= 15

-- Indenting.
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2

-- Prevent filetype plugins from changing indentation.
vim.g.filetype_plugin_indent = false

opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

-- Numbers.
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

-- add binaries installed by mason.nvim to path.
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
vim.env.PATH = vim.env.PATH .. (is_windows and ";" or ":") .. vim.fn.stdpath "data" .. "/mason/bin"
----------



-- MAPPINGS
-----------

local map = vim.keymap.set

-- General
map("n", "<C-c>", "<cmd> %y+ <CR>") -- Copy current file to clipboard.
map("v", "<C-c>", '"+y', { noremap = true, silent = true }) -- Copy highlighted text to clipboard.

-- Word wrap toggle
map("n", "<leader>ww", function()
  if vim.wo.wrap then
    vim.wo.wrap = false
    print("Word wrap disabled")
  else
    vim.wo.wrap = true
    print("Word wrap enabled")
  end
end, { desc = "Toggle word wrap" })

-- Nvim Tree
map("n", "<C-n>", "<cmd> NvimTreeToggle <CR>") -- Toggle sidebar navigation.

-- Telescope
map("n", "<leader>ff", "<cmd> Telescope find_files <CR>") -- Find file by filename.
map("n", "<leader>fo", "<cmd> Telescope oldfiles <CR>") -- Find files that you recently opened.
map("n", "<leader>fw", "<cmd> Telescope live_grep <CR>") -- Search for files by their content.

-- Tabs
map("n", "<Tab>", "<cmd> BufferLineCycleNext <CR>") -- Move right one tab.
map("n", "<S-Tab>", "<cmd> BufferLineCyclePrev <CR>") -- Move left one tab.
map("n", "<C-q>", function() -- Close a tab.
  local bufnr = vim.api.nvim_get_current_buf()
  local buffers = vim.fn.getbufinfo({buflisted = 1})

  -- If there are other buffers, switch to the next one before closing
  if #buffers > 1 then
    vim.cmd("BufferLineCycleNext")
    vim.cmd("bd " .. bufnr)
  else
    -- If this is the last buffer, close it normally
    vim.cmd("bd")
  end
end, { desc = "Close current buffer" })


-- Floating Terminal
map("n", "<leader>ft", "<cmd> ToggleTerm direction=float<CR>") -- Open a floating terminal.
map("n", "<leader>fg", "<cmd>lua require('toggleterm.terminal').Terminal:new({cmd='lazygit', direction='float', dir=vim.fn.expand('%:p:h')}):toggle()<CR>") -- Open Lazygit in current dir.

-- Undo tree
map("n", "<leader>u", "<cmd>lua require('undotree').toggle()<CR>") -- Show or hide Undotree on the left.

-- Harper Grammar Checker keymaps
map("n", "<leader>hh", function()
  vim.lsp.buf.code_action({
    filter = function(action)
      return string.match(action.title, "^Harper:")
    end,
    apply = true,
  })
end, { desc = "Apply Harper grammar suggestions" })

-- Toggle Harper diagnostics visibility
map("n", "<leader>th", function()
  if vim.diagnostic.is_disabled() then
    vim.diagnostic.enable()
    print("Harper diagnostics enabled")
  else
    vim.diagnostic.disable()
    print("Harper diagnostics disabled")
  end
end, { desc = "Toggle Harper diagnostics" })

-- Focus mode
map("n", "<leader>tf", "<cmd> ZenMode <CR>", { desc = "Toggle Focus-mode" })

-- Make :W work like :w and :Q work like :q
vim.cmd('cnoreabbrev W w')
vim.cmd('cnoreabbrev Q q')
-----------



-- COMMANDS
-----------

-- mason, write correct names only
vim.api.nvim_create_user_command("MasonInstallAll", function()
  vim.cmd "MasonInstall css-lsp html-lsp lua-language-server typescript-language-server stylua prettier harper-ls"
end, {})
-----------



-- PLUGINS AND LAZY.NVIM SETUP
------------------------------

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
        { 
          filetype = "NvimTree", 
          highlight = "NvimTreeNormal",
          separator = true  -- Add separator for better visual separation
        },
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
      file_ignore_patterns = {
        "node_modules/.*",
        "%.git/.*",
        "%.DS_Store",
        "package%-lock%.json",
        "yarn%.lock",
        "dist/.*",
        "build/.*",
        "%.log",
        "%.tmp",
        "%.temp",
      },
    },
    pickers = {
      find_files = {
        hidden = false,
        find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*", "--glob", "!**/node_modules/*" },
      },
      live_grep = {
        additional_args = function()
          return { "--hidden", "--glob", "!**/.git/*", "--glob", "!**/node_modules/*" }
        end,
      },
    },
  }
end

-- Treesitter Configuration
local treesitter_config = function()
  require("nvim-treesitter.configs").setup {
    ensure_installed = { 
      "css", 
      "html", 
      "javascript", 
      "lua", 
      "markdown", 
      "tsx", 
      "typescript", 
      "vim", 
      "vimdoc", 
    },
    highlight = {
      enable = true
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

  -- Remove this line entirely:
  -- local lspconfig = require "lspconfig"

  -- Change from lspconfig.lua_ls.setup to:
  vim.lsp.config.lua_ls = {
    capabilities = capabilities,
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
      },
    },
  }

  -- Setup Harper Language Server for grammar checking
  vim.lsp.config.harper_ls = {
    capabilities = capabilities,
    filetypes = {
      "markdown",
      "text",
    },
    settings = {
      ["harper-ls"] = {
        userDictPath = "~/.config/harper-ls/user.dict",  -- Custom dictionary path
      },
    },
  }

  -- setup multiple servers with same default options
  local servers = { "ts_ls", "html", "cssls" }

  for _, lsp in ipairs(servers) do
    vim.lsp.config[lsp] = {
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
  {
    "akinsho/toggleterm.nvim", 
    version = "*", 
    config = true
  },

  -- A nice sidebar File Tree. Open with CTRL + `n`.
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require("nvim-tree").setup({
        disable_netrw = true,
        hijack_netrw = true,
        view = {
          width = 30,
          side = 'right'
        },
        renderer = {
          highlight_git = true,
          icons = {
            show = {
              git = true,
            },
          },
        },
        filters = {
          dotfiles = false,
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

  -- easy titlecase
  {
    "christoomey/vim-titlecase",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      vim.keymap.set("n", "<leader>tc", "gzz", { desc = "Title case current line" })
      vim.keymap.set("v", "<leader>tc", "gz", { desc = "Title case selection" })
    end,
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

  -- Focus/zen mode for distraction-free writing
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    config = function()
      require("zen-mode").setup({
        window = {
          width = 120,
          options = {
            number = false,
            relativenumber = false,
            wrap = true,
            linebreak = true,
          },
        },
        plugins = {
          options = {
            enabled = true,
            laststatus = 0, -- hide statusline
          },
        },
        on_open = function()
          vim.opt.laststatus = 0
        end,
        on_close = function()
          vim.opt.laststatus = 3 -- restore global statusline
        end,
      })
    end,
  },
}

-- Initialize lazy with the plugins.
require("lazy").setup(plugins, lazy_config)
------------------------------



-- THEME SETUP
--------------

-- Stop Alacritty freaking out.
vim.o.termguicolors = true

-- Set overarching Catppuccin theme.
vim.cmd "colorscheme catppuccin-mocha"

-- Force indentation to be 2 characters.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.expandtab = true
  end,
})

-- Treat MDX files as Markdown files
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.mdx",
  callback = function()
    vim.bo.filetype = "markdown"
  end,
})

-- Harper Grammar Checker Configuration
-- Configure diagnostics for Harper to be less intrusive
vim.diagnostic.config({
  virtual_text = {
    source = "if_many",
    prefix = "●",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Custom diagnostic signs
vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
