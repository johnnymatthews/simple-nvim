# Simple Nvim

A straightforward Neovim configuration that should work for _most_ developers. A minimalist fork of NvChad's [Tinyvim](https://github.com/NvChad/tinyvim), now simplified into a single configuration file.

<img width="1486" alt="Screenshot 2024-08-31 at 10 15 59 AM" src="https://github.com/user-attachments/assets/399c779d-9b1f-493b-b06a-45e4153102cd">

## Features

- [Catpuccin](https://catppuccin.com/) colour scheme.
- Sidebar navigation.
- Tabs by default.
- Easy [lazygit](https://github.com/jesseduffield/lazygit) access.
- Basic code completion.
- Sensible hotkeys.
- Single file configuration for simplicity.
- Leader key set to `SPACE`.

## Prerequisities

There are only a few things you'll need to install.

- Any C Compiler to build the LSP configs:

    ```shell
    # MacOS
    brew install gcc

    # Ubuntu
    sudo apt install build-essential

    # Arch
    sudo pacman -S base-devel
    ```

- [Ripgrep](https://github.com/BurntSushi/ripgrep) to search through files and folders:

    ```shell
    # MacOS
    brew install ripgrep

    # Ubuntu
    sudo apt install ripgrep

    # Arch
    sudo pacman -S ripgrep
    ```

- [Lazygit](https://github.com/jesseduffield/lazygit) for Git things:

    ```shell
    # MacOS
    brew install lazygit

    # Ubuntu
    sudo apt install lazygit

    # Arch
    sudo pacman -S lazygit
    ```

- [Claude Code](https://claude.ai/code) if you want to use the integrated AI assistant:

    ```shell
    # Install Claude Code
    npm install -g @anthropic/claude-code
    
    # Login to Claude Code
    claude-code login
    ```

## Install

This whole setup is just a single file, so installing it is pretty straightforward.

1. Backup your existing Neovim config if you haven't already:

    ```shell
    mv ~/.config/nvim ~/.config/nvim-backup
    ```

2. Clear out your existing Neovim cache and local files:

    ```shell
    rm -rf ~/.cache/nvim 
    rm -rf ~/.local/share/nvim
    ```

3. Clone this repository into your `~/.config` directory:

    ```shell
    git clone https://github.com/johnnymatthews/simple-nvim ~/.config/nvim
    ```

4. Open Neovim:

    ```shell
    nvim
    ```

    Neovim should download all the extensions, theme files, and dependencies for you.

## Repository Structure

This configuration uses a minimal approach with just a single file:

- `init.lua` - Contains all configuration settings, key mappings, plugins, and plugin configurations.

## Keyboard shortcuts

All keyboard shortcuts (also called _mappings_) for this config can be found within the `MAPPINGS` section of the `init.lua` file. Here is a complete list of all the keyboard shortcuts:

**Leader Key:** `<Space>`

### General

| Key | Mode | Action |
|-----|------|--------|
| `<C-c>` | Normal | Copy current file to clipboard |
| `<C-c>` | Visual | Copy highlighted text to clipboard |

### File Navigation

#### Nvim Tree
| Key | Mode | Action |
|-----|------|--------|
| `<C-n>` | Normal | Toggle sidebar navigation |

#### Telescope
| Key | Mode | Action |
|-----|------|--------|
| `<leader>ff` | Normal | Find file by filename |
| `<leader>fo` | Normal | Find files that you recently opened |
| `<leader>fw` | Normal | Search for files by their content |

### Buffer/Tab Management

| Key | Mode | Action |
|-----|------|--------|
| `<Tab>` | Normal | Move right one tab |
| `<S-Tab>` | Normal | Move left one tab |
| `<C-q>` | Normal | Close current buffer |

### Terminal

| Key | Mode | Action |
|-----|------|--------|
| `<leader>ft` | Normal | Open a floating terminal |
| `<leader>fg` | Normal | Open Lazygit in current directory |

### Undo Tree

| Key | Mode | Action |
|-----|------|--------|
| `<leader>u` | Normal | Show or hide Undotree on the left |

### Claude Code Integration

| Key | Mode | Action |
|-----|------|--------|
| `<C-,>` | Normal | Toggle Claude Code terminal |
| `<leader>cC` | Normal | Continue conversation |
| `<leader>cV` | Normal | Verbose mode |

### LSP (Language Server Protocol)

#### Global Diagnostics
| Key | Mode | Action |
|-----|------|--------|
| `<space>e` | Normal | Open floating diagnostic |
| `[d` | Normal | Go to previous diagnostic |
| `]d` | Normal | Go to next diagnostic |
| `<space>q` | Normal | Set location list |

#### LSP Attached Buffer (Available when LSP is active)
| Key | Mode | Action |
|-----|------|--------|
| `gD` | Normal | Go to declaration |
| `gd` | Normal | Go to definition |
| `K` | Normal | Hover documentation |
| `gi` | Normal | Go to implementation |
| `<C-k>` | Normal | Signature help |
| `<space>wa` | Normal | Add workspace folder |
| `<space>wr` | Normal | Remove workspace folder |
| `<space>wl` | Normal | List workspace folders |
| `<space>D` | Normal | Type definition |
| `<space>rn` | Normal | Rename symbol |
| `<space>ca` | Normal/Visual | Code action |
| `gr` | Normal | Go to references |

### Command Abbreviations

| Command | Expands To |
|---------|------------|
| `:W` | `:w` |
| `:Q` | `:q` |

### Additional Plugin Commands

In addition to the keybindings, the following commands are available:

- `:ClaudeCode` - Toggle Claude Code terminal
- `:ClaudeCodeContinue` - Resume recent conversation
- `:ClaudeCodeResume` - Show conversation picker
- `:ClaudeCodeVerbose` - Enable verbose logging
- `:MasonInstallAll` - Install all configured LSP servers
- `:NvimTreeToggle` - Toggle file tree
- `:NvimTreeFocus` - Focus file tree
- `:ToggleTerm` - Toggle terminal
- `:Telescope` - Access Telescope commands

## Customising

Since all configuration is in a single `init.lua` file, customization is straightforward:

1. Open `init.lua` in your editor.
2. Find the relevant section (OPTIONS, MAPPINGS, PLUGINS, etc.).
3. Make your desired changes.
4. Save and restart Neovim.

The configuration file is extensively commented to help you understand what each section does. GLHF.

