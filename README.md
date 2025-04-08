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

All keyboard shortcuts (also called _mappings_) for this config can be found within the `MAPPINGS` section of the `init.lua` file. Here is a complete list of all the keyboard shortcuts (all shortcuts are from `normal` mode, unless otherwise stated):

| Description | Shortcut |
| ----------- | -------- |
| Comment or uncomment a line | `gc` |
| Open or close the sidebar navigation | `CTRL` + `n` |
| Change focus to or from the sidebar navigation | `CTRL` + `ww` |
| Copy the current file to the clipboard | `CTRL` + `c` |
| Find file by filename. | `SPACE` `ff` |
| Find files that you recently opened. | `SPACE` `fo` |
| Search for files by their content. | `SPACE` `fw` |
| Open a Lazygit window | `SPACE` `fg` |
| Open a floating terminal window | `SPACE` `ft` |
| Close current tab | `CTRL` + `q` |
| Open or close the undo-tree | `SPACE` `u` |

## Customising

Since all configuration is in a single `init.lua` file, customization is straightforward:

1. Open `init.lua` in your editor.
2. Find the relevant section (OPTIONS, MAPPINGS, PLUGINS, etc.).
3. Make your desired changes.
4. Save and restart Neovim.

The configuration file is extensively commented to help you understand what each section does. GLHF.

