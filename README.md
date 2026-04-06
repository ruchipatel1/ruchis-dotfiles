# Dotfiles

Zsh plugins (syntax highlighting, autosuggestions, extra completions), Catppuccin **Frappé** and **Macchiato** for `bat`/delta/Ghostty, Git wired for **diffnav** + delta, **lazygit**, and a **cmux** layout helper (AI CLI + command shell).

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

`install.sh` runs `brew bundle` (including **JetBrains Mono** via `font-jetbrains-mono`), clones zsh plugins into `zsh/plugins/`, installs Catppuccin bat themes, and symlinks `~/.zshrc`, `~/.config/bat/config`, `~/.config/git/config`, Ghostty palette files, and `~/.local/bin/cmux-ai-split`.

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

## cmux: AI CLI + command shell

`cmux-ai-split` opens a **new cmux workspace** (cwd + sidebar title = directory basename), splits **left / right**, starts your **AI CLI on the left**, and leaves the **right** pane as a normal shell for git/build/commands.

```bash
cmux-ai-split .                    # default AI: claude (Claude Code)
cmux-ai-split -a cursor ~/src/app  # Cursor agent CLI (`agent` by default)
cmux-ai-split --list               # show presets → resolved commands
```

**Switch tools**

- Per run: `-a claude` | `-a cursor` | `-a codex`, or any custom name (runs that command, or `CMUX_AI_CMD_<NAME>` if set).
- Default preset: `export CMUX_AI_TOOL=cursor` in your shell or in `~/.config/cmux-ai-layout.conf`.
- Override commands: `export CMUX_AI_CMD_CURSOR="agent"`, `CMUX_AI_CMD_CLAUDE="claude"`, etc. Copy `config/cmux/ai-layout.conf.example` to `~/.config/cmux-ai-layout.conf` to persist.

The **cursor** preset defaults to **`agent`** ([Cursor CLI](https://cursor.com/docs/cli/overview)); change it if your install uses another binary.

If the AI lands in the wrong split, set `CMUX_AI_PANE_INDEX` / `CMUX_CMD_PANE_INDEX` (0-based) in the same config file.

Requires [cmux](https://www.cmux.dev) and the `cmux` CLI (see their docs for symlink from the app bundle). Optional: uncomment the cask lines in `Brewfile`.

Shell alias (after install): `csplit` → `cmux-ai-split`.

## Optional local overrides

- `~/.zshrc.local` — machine-specific zsh (sourced automatically if present).
