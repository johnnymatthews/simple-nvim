# Simple Nvim

A straightforward Neovim configuration that should work for _most_ developers. Cloned from NvChad's [Tinyvim](https://github.com/NvChad/tinyvim).

<img width="1280" alt="image" src="https://github.com/johnnymatthews/simple-nvim/assets/9611008/02483a5e-c9a7-43f0-93ec-463243179b53">

## Features

- Catpuccin colour scheme.
- Sidebar navigation.
- Tabs by default.
- Easy lazygit access.
- Basic code completion.
- Sensible hotkeys.
- A simple directory structure.
- Leader key set to `SPACE`.

## Prerequisities

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

1. Backup your existing Neovim config if you haven't already:

    ```shell
    mv ~/.config/nvim ~/.config/nvim-backup
    ```

1. Clear out your existing Neovim cache and local files:

    ```shell
    rm -rf ~/.cache/nvim 
    rm -rf ~/.local/share/nvim
    ```

1. Clone this repository into your `~/.config` directory:

    ```shell
    git clone https://github.com/johnnymatthews/simple-nvim ~/.config/nvim
    ```

1. Open Neovim:

    ```shell
    nvim
    ```

    Neovim should download all the extensions, theme files, and dependencies for you.

## Keyboard shortcuts

Most of the keyboard shortcuts (also called _mappings_) for this config can be found within `./lua/mappings.lua`, however some shortcuts are defined within plugins. Here is a complete list of all the keyboard shortcut for this repo (all shortcuts are from `normal` mode, unless otherwise stated):

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
| Open a floating termial window | `SPACE` `ft` |
| Close current tab | `CTRL` + `q` |
| Open or close the undo-tree | `SPACE` `u` |
