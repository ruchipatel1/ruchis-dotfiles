# Dotfiles

Zsh plugins (syntax highlighting, autosuggestions, extra completions), Catppuccin **Frappé** and **Macchiato** for `bat`/delta/Ghostty, Git wired for **diffnav** + delta, **lazygit**, and a **cmux** workspace helper.

## Prerequisites

- macOS with [Homebrew](https://brew.sh)
- zsh (default on macOS)

## Install

```bash
cd /path/to/ruchis-dotfiles
chmod +x install.sh
./install.sh
```

Then restart the terminal or `source ~/.zshrc`.

`install.sh` runs `brew bundle` (including **JetBrains Mono** via `font-jetbrains-mono`), clones zsh plugins into `zsh/plugins/`, installs Catppuccin bat themes, and symlinks `~/.zshrc`, `~/.config/bat/config`, `~/.config/git/config`, Ghostty palette files, and `~/.local/bin/cmux-workspace`.

## Zsh plugins

Managed as shallow git clones (see `install.sh`):

- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-completions](https://github.com/zsh-users/zsh-completions) (extra completion definitions — the usual “autocomplete” stack with the other two)

## Catppuccin

- **bat**: Frappé and Macchiato themes under `$(bat --config-dir)/themes`; default theme in `config/bat/config`.
- **delta / diffnav**: `delta.syntax-theme` in `config/git/config` (used by diffnav).
- **Ghostty**: theme files linked into `~/.config/ghostty/themes/`. Add `theme = catppuccin-macchiato` or `catppuccin-frappe` using `config/ghostty/config.example` as a reference.

Shell helpers: `ctp-macchiato` and `ctp-frappe` adjust `BAT_THEME` and the delta syntax theme in `~/.config/git/config`.

## cmux workspace script

Creates a new workspace with cwd set to the target directory and renames the workspace to that directory’s basename:

```bash
cmux-workspace          # current directory
cmux-workspace ~/src/my-app
```

Requires [cmux](https://www.cmux.dev) and the `cmux` CLI (see their docs for symlink from the app bundle). Optional: uncomment the cask lines in `Brewfile`.

## Optional local overrides

- `~/.zshrc.local` — machine-specific zsh (sourced automatically if present).
