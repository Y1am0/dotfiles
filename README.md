# My Zsh Configuration

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This repository hosts my personal Zsh configuration, meticulously crafted for a productive, fast, and aesthetically pleasing terminal experience. It leverages the **Zinit** plugin manager for speed and flexibility.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [1. Clone the Repository](#1-clone-the-repository)
  - [2. Install Dependencies](#2-install-dependencies)
  - [3. Link the `.zshrc`](#3-link-the-zshrc)
  - [4. Configure Oh My Posh (Optional)](#4-configure-oh-my-posh-optional)
  - [5. Restart Zsh](#5-restart-zsh)
- [Key Components & Usage](#key-components--usage)
  - [Plugin Management: Zinit](#plugin-management-zinit)
  - [Prompt: Oh My Posh](#prompt-oh-my-posh)
  - [Navigation: Zoxide](#navigation-zoxide)
  - [Fuzzy Finding: fzf & fzf-tab](#fuzzy-finding-fzf--fzf-tab)
  - [Syntax Highlighting & Autosuggestions](#syntax-highlighting--autosuggestions)
  - [Enhanced History](#enhanced-history)
  - [Utility Plugins](#utility-plugins)
  - [Startup Information: Neofetch](#startup-information-neofetch)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [Updating the Configuration](#updating-the-configuration)
- [License](#license)

## Features

- **Fast Startup:** Optimized plugin loading with Zinit (lucid, light modes).
- **Modern Plugin Management:** Uses [Zinit (zdharma-continuum fork)](https://github.com/zdharma-continuum/zinit) for efficient handling of plugins and snippets.
- **Enhanced Completions:**
  - `zsh-completions` for a vast array of additional completions.
  - `fzf-tab` for interactive fuzzy completion menus.
- **Powerful Fuzzy Finding:** Deep integration with `fzf` for history, files, and more.
- **Intelligent Navigation:** `zoxide` learns your frequently used directories.
- **Real-time Feedback:**
  - `zsh-syntax-highlighting` for commands.
  - `zsh-autosuggestions` based on history.
- **Improved History:**
  - `zsh-history-substring-search` for intuitive history recall.
  - Comprehensive history settings (deduplication, sharing, timestamps).
- **Customizable Prompt:** [Oh My Posh](https://ohmyposh.dev/) for a beautiful and informative prompt (configuration external).
- **Useful Utilities:**
  - `sudo` (OMZ snippet): `Esc` `Esc` to prepend sudo.
  - `extract` (OMZ snippet): Universal archive extractor.
- **System Info on Startup:** `neofetch` displays system information (if installed).
- **Robust Dependency Checks:** Gracefully handles missing optional binaries (e.g., zoxide, oh-my-posh).

## Prerequisites

Before using this configuration, ensure the following are installed on your system. The primary method of installation for macOS using [Homebrew](https://brew.sh/) is provided as an example.

- **`git`**: For Zinit and plugin management.
  ```bash
  brew install git
  ```
- **`zsh`**: The Z shell (usually default on modern macOS).
- **`fzf`**: Command-line fuzzy finder.
  ```bash
  brew install fzf
  ```
- **`zoxide`**: A smarter `cd` command.
  ```bash
  brew install zoxide
  ```
- **`oh-my-posh`**: Prompt theme engine (optional, for the prompt).
  ```bash
  brew install oh-my-posh
  ```
  - You'll also need a [Nerd Font](https://www.nerdfonts.com/) installed and set in your terminal for Oh My Posh glyphs.
- **`neofetch`**: System information tool (optional, for startup info).
  ```bash
  brew install neofetch
  ```
- **`bat`**: A cat(1) clone with wings, used for `fzf` previews.
  ```bash
  brew install bat
  ```

## Installation

### 1. Clone the Repository

Clone this `dotfiles` repository to a location on your machine, for example, `~/.dotfiles`:

```bash
git clone https://github.com/Y1am0/dotfiles.git ~/.dotfiles
```

_(Replace `Y1am0` with your GitHub username if you've forked this or are adapting it.)_

### 2. Install Dependencies

Ensure all tools listed under [Prerequisites](#prerequisites) are installed.

### 3. Link the `.zshrc`

It's recommended to symlink the `.zshrc` file from the repository to your home directory. This way, any `git pull` in the `~/.dotfiles` repository will automatically update your active Zsh configuration.

```bash
# Backup your existing .zshrc if you have one
# mv ~/.zshrc ~/.zshrc.backup

# Create the symlink
ln -sfn ~/.dotfiles/.zshrc ~/.zshrc
```

Alternatively, you can copy the file, but you'll need to manually copy it again after updates:
`cp ~/.dotfiles/.zshrc ~/.zshrc`

### 4. Configure Oh My Posh (Optional)

This `.zshrc` expects an Oh My Posh theme at:
`${XDG_CONFIG_HOME:-$HOME/.config}/ohmyposh/base.json`

Ensure you have a theme file at this location or update the `OMP_CONFIG_PATH` variable in `.zshrc` to point to your theme. You can find many themes or create your own: [Oh My Posh Themes](https://ohmyposh.dev/docs/themes).

### 5. Restart Zsh

For the changes to take effect, either close and reopen your terminal or source the configuration:

```bash
source ~/.zshrc
```

Zinit will automatically install the configured plugins on the first run.

## Key Components & Usage

### Plugin Management: Zinit

Zinit handles the loading of all plugins. You can explore Zinit's features and commands by typing `zinit` in your terminal (once completions are loaded).

### Prompt: Oh My Posh

If `oh-my-posh` is installed and a theme is found, your prompt will be styled. The configuration avoids loading Oh My Posh in Apple Terminal due to potential compatibility issues.

### Navigation: Zoxide

- Use `z <partial_name>` to jump to frequently visited or recently accessed directories.
- `zi <partial_name>` for interactive selection using fzf.
- `zoxide query <partial_name>` to see matches.

### Fuzzy Finding: fzf & fzf-tab

- **`fzf` Default Keybindings:**
  - `Ctrl+T`: Fuzzy find files and directories.
  - `Ctrl+R`: Fuzzy find commands in history.
  - `Alt+C` (Option+C on macOS): Fuzzy find directories and `cd` into the selected one.
- **`fzf-tab`:** Press `Tab` to trigger fzf-powered completions for commands, paths, variables, etc.
- **`FZF_DEFAULT_OPTS`:** Configured for a consistent look with `bat` previews.

### Syntax Highlighting & Autosuggestions

- **`zsh-syntax-highlighting`:** Commands will be highlighted as you type. Correct commands in green, incorrect in red.
- **`zsh-autosuggestions`:** Light grey suggestions will appear based on your history. Press `→` (right arrow) or `End` to accept.

### Enhanced History

- **`zsh-history-substring-search`:** Type part of a command and press `Up Arrow` or `Down Arrow` to cycle through matching history entries.
- History is configured to be large, shared across sessions, and deduplicated.

### Utility Plugins

- **`sudo` (OMZ snippet):** Press `Esc` twice to quickly prepend `sudo` to the current or previous command.
- **`extract` (OMZ snippet):** Use `extract <archive_file>` to decompress any common archive type (e.g., .zip, .tar.gz, .rar).

### Startup Information: Neofetch

If `neofetch` is installed, it will display a system information summary when you open a new interactive terminal.

## Customization

- **Oh My Posh Theme:** Modify `${XDG_CONFIG_HOME:-$HOME/.config}/ohmyposh/base.json` or change `OMP_CONFIG_PATH` in `.zshrc`.
- **Zinit Plugins:** Add or remove plugins in the `~/.zshrc` file within the `if command -v zinit &>/dev/null; then ... fi` block. Refer to Zinit's documentation for syntax.
- **Aliases and Functions:** Add your personal aliases and functions at the end of `.zshrc`.
- **FZF Options:** Modify `FZF_DEFAULT_OPTS` for different `fzf` behavior or appearance.
- **Shell Options:** Review and uncomment/modify `setopt` lines in `.zshrc` to change shell behavior.

## Troubleshooting

- **Zinit Errors on First Load:** If `git` was not installed when Zinit tried to clone itself, Zinit might not load. Ensure `git` is installed and remove the potentially incomplete Zinit directory (`${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git`) then restart Zsh.
- **Plugin Issues:** Use `zinit report <plugin_name>` for diagnostics or check Zinit's issue tracker.
- **Oh My Posh Glyphs/Icons Not Showing:** Ensure you have a Nerd Font installed and correctly configured in your terminal emulator settings.
- **Completions Not Working:** Ensure `compinit` is run. If you experience issues, you can try removing `~/.zcompdump` and restarting Zsh.

## Updating the Configuration

If you symlinked your `.zshrc` as recommended:

1.  Navigate to your dotfiles directory: `cd ~/.dotfiles`
2.  Pull the latest changes: `git pull origin main`
3.  Source the updated config or open a new terminal: `source ~/.zshrc`

If you copied the file, you'll need to re-copy it from `~/.dotfiles/.zshrc` to `~/.zshrc` after pulling changes.

## License

This configuration is released under the [MIT License](LICENSE). Feel free to use, modify, and distribute it.
