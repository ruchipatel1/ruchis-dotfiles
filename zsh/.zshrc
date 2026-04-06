# Dotfiles root (repo): zsh/.zshrc -> parent of zsh/
export DOTFILES="${DOTFILES:-${${(%):-%x}:A:h:h}}"

# History
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE

# Paths
typeset -U path PATH
path=(
  "${HOME}/.local/bin"
  /opt/homebrew/bin
  /usr/local/bin
  $path
)

# Completion: extra definitions (load before compinit)
fpath=("${DOTFILES}/zsh/plugins/zsh-completions/src" $fpath)
autoload -Uz compinit
compinit -C

# zsh-autosuggestions (before syntax highlighting)
[[ -r "${DOTFILES}/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] &&
  source "${DOTFILES}/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# zsh-syntax-highlighting must be last
[[ -r "${DOTFILES}/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] &&
  source "${DOTFILES}/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# fzf (Homebrew)
if command -v brew >/dev/null 2>&1; then
  _fzf_prefix="$(brew --prefix fzf 2>/dev/null)"
  if [[ -n "${_fzf_prefix}" ]]; then
    [[ -r "${_fzf_prefix}/shell/key-bindings.zsh" ]] && source "${_fzf_prefix}/shell/key-bindings.zsh"
    [[ -r "${_fzf_prefix}/shell/completion.zsh" ]] && source "${_fzf_prefix}/shell/completion.zsh"
  fi
  unset _fzf_prefix
fi

# Catppuccin-aligned defaults (bat installs Frappé + Macchiato themes via install.sh)
export BAT_THEME="${BAT_THEME:-Catppuccin Macchiato}"

# Optional machine-specific overrides
[[ -r "${HOME}/.zshrc.local" ]] && source "${HOME}/.zshrc.local"

# Catppuccin flavor helpers (bat + delta in ~/.config/git/config)
_ctp_git_cfg="${HOME}/.config/git/config"
ctp-frappe() {
  export BAT_THEME="Catppuccin Frappé"
  [[ -f "${_ctp_git_cfg}" ]] && git config --file "${_ctp_git_cfg}" delta.syntax-theme "Catppuccin Frappé"
}
ctp-macchiato() {
  export BAT_THEME="Catppuccin Macchiato"
  [[ -f "${_ctp_git_cfg}" ]] && git config --file "${_ctp_git_cfg}" delta.syntax-theme "Catppuccin Macchiato"
}

# Tools
command -v lazygit >/dev/null && alias lg=lazygit

# Prompt
autoload -Uz colors && colors
PS1="%F{cyan}%~%f %# "
