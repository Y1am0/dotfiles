# ~/.zshrc
# ==============================================================================
# This is the main configuration file for Zsh.
# It's read when Zsh starts, setting up your shell environment,
# aliases, functions, options, and loading plugins.
#
# This configuration uses Zinit (zdharma-continuum fork) for plugin management
# for speed, flexibility, and modern features.
#
# For this configuration to work optimally, ensure the following are installed
# (e.g., via Homebrew on macOS):
#   - git (for Zinit and plugin management)
#   - fzf (for fuzzy finding capabilities)
#   - zoxide (for intelligent directory navigation)
#   - oh-my-posh (for the prompt, if used)
#   - neofetch (for the startup system info, if enabled)
#   - bat for previewing files
# ==============================================================================

# --- Zinit Plugin Manager Setup ---
# Zinit (zdharma-continuum/zinit) is a flexible and fast plugin manager for Zsh.
# It allows for conditional loading, compiling plugins for speed (Turbo mode),
# and managing snippets from Oh My Zsh, Prezto, and other sources.

# Define the installation path for Zinit.
# Uses XDG Base Directory Specification if XDG_DATA_HOME is set, otherwise ~/.local/share.
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if it doesn't already exist.
if [[ ! -d $ZINIT_HOME ]]; then
  # Ensure git is available before trying to clone
  if command -v git &>/dev/null; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
  else
    echo "Zinit Error: git is not installed. Zinit and plugins cannot be loaded." >&2
    # Optionally, you could return here or exit if git is critical for your setup
  fi
fi

# Source Zinit to make its commands available, only if Zinit was successfully installed.
if [[ -f "${ZINIT_HOME}/zinit.zsh" ]]; then
  source "${ZINIT_HOME}/zinit.zsh"

  # Load Zinit's own completions (optional but highly recommended for Zinit usage).
  # This allows you to use Tab completion for Zinit commands.
  autoload -Uz _zinit
  (( ${+_comps} )) && _comps[zinit]=_zinit
else
  echo "Zinit Error: Zinit not found at ${ZINIT_HOME}. Plugins will not be loaded." >&2
fi

# --- Plugin Loading with Zinit (only if Zinit was sourced) ---
if command -v zinit &>/dev/null; then
  # Zinit 'ice' modifiers control how plugins are loaded:
  #   lucid:  Loads the plugin in the background (non-blocking) for faster shell startup.
  #   light:  A lighter way to load plugins, often for simple ones or snippets.
  #   load:   The standard way to load a Zsh plugin, sourcing its main plugin file.
  #   wait"X": Delays loading slightly, useful for plugins that need to act last (e.g., syntax highlighting).
  #   snippet: Loads a specific file (snippet) from a repository, often from Oh My Zsh (OMZ).

  # 1. zsh-syntax-highlighting: Provides real-time syntax highlighting for commands.
  #    - `wait"1"`: Ensures it loads after other plugins that might modify the command line.
  zinit ice lucid wait"1"
  zinit light zsh-users/zsh-syntax-highlighting

  # 2. zsh-autosuggestions: Suggests commands as you type based on your history.
  zinit ice lucid
  zinit light zsh-users/zsh-autosuggestions

  # Initialize Zsh's completion system
  # This MUST be done before loading zsh-completions or fzf-tab,
  # as they hook into and extend the existing completion system.
  autoload -Uz compinit
  compinit # Consider adding -C here if ~/.zcompdump is managed elsewhere or to avoid checks

  # 3. zsh-completions: Provides additional, more comprehensive tab completions.
  zinit ice lucid
  zinit load zsh-users/zsh-completions

  # 4. fzf (Fuzzy Finder) Integration: Core fuzzy finding capabilities.
  #    - Zinit makes the fzf plugin available.
  #    - Its keybindings (Ctrl+T, Ctrl+R, Alt+C) are then explicitly sourced below for robustness.
  #    - The fzf binary itself (assumed to be installed, e.g., via Homebrew) provides the core functionality.
  zinit ice lucid
  zinit light junegunn/fzf

  # Explicitly source fzf keybindings AFTER fzf is loaded by Zinit.
  # This ensures its bindings take precedence or are correctly applied.
  if [ -f "${ZINIT[PLUGINS_DIR]}/junegunn---fzf/shell/key-bindings.zsh" ]; then
    source "${ZINIT[PLUGINS_DIR]}/junegunn---fzf/shell/key-bindings.zsh"
  fi

  # 5. fzf-tab: Replaces Zsh's standard Tab completion menu with fzf.
  zinit ice lucid
  zinit load Aloxaf/fzf-tab

  # 6. zoxide: A smarter 'cd' command that learns your frequently used directories.
  #    - Requires the 'zoxide' binary to be installed.
  #    - The plugin handles its own initialization (e.g., 'zoxide init zsh').
  if command -v zoxide &>/dev/null; then # Check if zoxide binary is available
    zinit ice lucid
    zinit load ajeetdsouza/zoxide
  else
    echo "Zinit Info: zoxide binary not found, zoxide plugin not loaded." >&2
  fi

  # 7. sudo (Oh My Zsh snippet): Quickly prepend 'sudo' to the current or previous command (Esc Esc).
  zinit ice lucid
  zinit snippet OMZ::plugins/sudo/sudo.plugin.zsh

  # 8. extract (Oh My Zsh snippet): Universal archive extractor (`extract <filename>`).
  zinit ice lucid
  zinit snippet OMZ::plugins/extract/extract.plugin.zsh

  # 9. zsh-history-substring-search: Enhanced history search with Up/Down arrows.
  zinit ice lucid
  zinit light zsh-users/zsh-history-substring-search
  # Keybindings for zsh-history-substring-search:
  # Use terminfo for better portability if available, otherwise fallback to common escape codes.
  if (( ${+terminfo[kcuu1]} )); then
    bindkey "${terminfo[kcuu1]}" history-substring-search-up
  else
    bindkey '^[[A' history-substring-search-up # Fallback for Up arrow
  fi
  if (( ${+terminfo[kcud1]} )); then
    bindkey "${terminfo[kcud1]}" history-substring-search-down
  else
    bindkey '^[[B' history-substring-search-down # Fallback for Down arrow
  fi
fi # End of Zinit plugin loading block

# --- Shell Options & History Configuration ---
# For a more ergonomic and consistent shell experience.

# History Configuration
HISTFILE=~/.zsh_history       # Where to save command history.
HISTSIZE=10000                # Max number of lines to keep in internal history.
SAVEHIST=10000                # Max number of lines to save in HISTFILE.
setopt append_history         # Append to history file, don't overwrite.
setopt extended_history       # Save timestamp and duration for each command.
setopt hist_expire_dups_first # If history is full, delete oldest duplicates first.
setopt hist_ignore_all_dups   # Remove older duplicate commands from history.
setopt hist_ignore_dups       # Don't record command if it's an exact duplicate of the previous one.
setopt hist_ignore_space      # Don't record commands starting with a space.
setopt hist_reduce_blanks     # Remove superfluous blanks from history items.
setopt hist_verify            # When recalling history, show command before executing.
setopt inc_append_history     # Append commands to HISTFILE immediately, not just on shell exit.
setopt share_history          # Share history between all running Zsh sessions (imports new entries).

# Other useful shell options
# setopt auto_cd                # If a command is a path to a directory, cd to it.
# setopt auto_pushd             # Make cd push the old directory onto the directory stack.
# setopt correct                # Enable command auto-correction.
# setopt glob_dots              # Include dotfiles in globbing results.
# setopt no_beep                # No more beeping!
# setopt notify                 # Report status of background jobs immediately.
# setopt numeric_glob_sort      # Sort filenames numerically when globbing.
# setopt pushd_ignore_dups      # Don't push duplicate directories onto the stack.

# --- Oh My Posh Prompt Configuration ---
# Oh My Posh is a highly customizable prompt theme engine.
# Assumes Oh My Posh binary is installed and a theme is configured.
# Your theme configuration is typically stored in `~/.config/ohmyposh/theme.json` (or similar).

# Conditionally load Oh My Posh, checking if the command exists.
if command -v oh-my-posh &>/dev/null && [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
    # Initialize Oh My Posh for Zsh, using your specified config file.
    # Replace ~/.config/ohmyposh/base.json with your actual theme path if different.
    OMP_CONFIG_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/ohmyposh/base.json" # Example using XDG
    if [ -f "$OMP_CONFIG_PATH" ]; then
        eval "$(oh-my-posh init zsh --config "$OMP_CONFIG_PATH")"
    else
        echo "Oh My Posh Warning: Config file not found at $OMP_CONFIG_PATH. Prompt may not be styled." >&2
    fi
elif [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
    echo "Oh My Posh Info: 'oh-my-posh' command not found. Prompt will not be styled by Oh My Posh." >&2
fi

# --- fzf Default Options ---
# Customize the default behavior and appearance of fzf.
# These options are applied if the `fzf` binary is available.
if command -v fzf &>/dev/null; then
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --multi --info=inline --preview "bat --color=always --style=numbers --line-range=:500 {}"'
  # For fzf-tab, you might want specific settings via zstyle, e.g.:
  # zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -F --color=always $realpath'
  # zstyle ':fzf-tab:complete:kill:argument' fzf-preview 'ps -p $word -o cmd --no-headers -w -w'
fi

# --- Automatically run Neofetch on new interactive terminal ---
# This will display system information using Neofetch when a new
# interactive Zsh session starts.
# Checks if Neofetch command exists and if the shell is interactive.

if command -v neofetch &>/dev/null && [[ -o interactive ]]; then
  # Optional: Clear the screen before showing neofetch for a cleaner look
  # clear
  neofetch
fi

# --- Final Space & Other Customizations ---
# Ensure `final_space` from your Oh My Posh config is respected if not handled by OMP itself.
# This is generally handled by Oh My Posh's `final_space` setting in the JSON.
# If you notice a missing space before your command input, you might add:
# PROMPT+="%f " # Ensure a space after the prompt if OMP doesn't add one.

# Add any personal aliases, functions, or other settings below.
# Example:
# alias ll='ls -alhF'
# alias la='ls -A'
# alias l='ls -CF'

# ==============================================================================
# End of ~/.zshrc
# For changes to take effect, either restart your terminal or run: source ~/.zshrc
# ==============================================================================
