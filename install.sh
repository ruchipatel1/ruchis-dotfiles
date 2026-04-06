#!/usr/bin/env bash
# Bootstrap dotfiles: Homebrew deps, Oh My Zsh, zsh plugins, Catppuccin bat themes, config links.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGINS_DIR="${REPO_ROOT}/zsh/plugins"
OMZ_DIR="${HOME}/.oh-my-zsh"
BAT_CONFIG_DIR="$(command -v bat >/dev/null 2>&1 && bat --config-dir || echo "${HOME}/.config/bat")"

log() { printf '\033[0;36m==>\033[0m %s\n' "$*"; }

if ! command -v brew >/dev/null 2>&1; then
  log "Homebrew not found. Install from https://brew.sh then re-run."
  exit 1
fi

log "Installing Homebrew bundle"
brew bundle --file="${REPO_ROOT}/Brewfile"

log "Installing Oh My Zsh"
if [[ ! -d "${OMZ_DIR}" ]]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  log "Oh My Zsh already present at ${OMZ_DIR}; leaving it as-is"
fi

log "Cloning zsh plugins"
mkdir -p "${PLUGINS_DIR}"
clone_plugin() {
  local url="$1" name
  name="$(basename "$url" .git)"
  if [[ ! -d "${PLUGINS_DIR}/${name}/.git" ]]; then
    git clone --depth 1 "$url" "${PLUGINS_DIR}/${name}"
  else
    git -C "${PLUGINS_DIR}/${name}" pull --ff-only || true
  fi
}
clone_plugin https://github.com/zsh-users/zsh-syntax-highlighting.git
clone_plugin https://github.com/zsh-users/zsh-autosuggestions.git
clone_plugin https://github.com/zsh-users/zsh-completions.git

log "Installing Catppuccin Frappé and Macchiato themes for bat"
mkdir -p "${BAT_CONFIG_DIR}/themes"
curl -fsSL "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme" \
  -o "${BAT_CONFIG_DIR}/themes/Catppuccin Frappe.tmTheme"
curl -fsSL "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme" \
  -o "${BAT_CONFIG_DIR}/themes/Catppuccin Macchiato.tmTheme"
hash -r 2>/dev/null || true
if command -v bat >/dev/null 2>&1; then
  bat cache --build
fi

log "Linking ~/.zshrc"
ln -sf "${REPO_ROOT}/zsh/.zshrc" "${HOME}/.zshrc"

mkdir -p "${HOME}/.config"
log "Linking ~/.config/bat/config"
ln -sf "${REPO_ROOT}/config/bat/config" "${HOME}/.config/bat/config"

log "Linking ~/.config/git (includes delta + pager)"
mkdir -p "${HOME}/.config/git"
ln -sf "${REPO_ROOT}/config/git/config" "${HOME}/.config/git/config"

log "Ghostty Catppuccin Frappé + Macchiato (optional)"
mkdir -p "${HOME}/.config/ghostty/themes"
ln -sf "${REPO_ROOT}/themes/ghostty/catppuccin-frappe.conf" "${HOME}/.config/ghostty/themes/catppuccin-frappe.conf"
ln -sf "${REPO_ROOT}/themes/ghostty/catppuccin-macchiato.conf" "${HOME}/.config/ghostty/themes/catppuccin-macchiato.conf"
log "Ghostty: add 'theme = catppuccin-macchiato' (or catppuccin-frappe) to ~/.config/ghostty/config — see config/ghostty/config.example"

log "Adding bin/ to PATH: append to ~/.zshrc.local if you use a custom PATH block"
mkdir -p "${HOME}/.local/bin"
rm -f "${HOME}/.local/bin/cmux-workspace"
ln -sf "${REPO_ROOT}/bin/cmux-ai-split" "${HOME}/.local/bin/cmux-ai-split"
chmod +x "${REPO_ROOT}/bin/cmux-ai-split"

log "Done. Open a new zsh, or: source ~/.zshrc"
