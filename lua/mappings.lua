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
map("n", "<leader>fg", "<cmd>TermExec cmd='lazygit && exit' direction=float<CR>") -- Open a floating Lazygit instance.

-- Undo tree
map("n", "<leader>u", "<cmd>lua require('undotree').toggle()<CR>") -- Show or hide Undotree on the left.

-- Make :W work like :w and :Q work like :q
vim.cmd('cnoreabbrev W w')
vim.cmd('cnoreabbrev Q q')
