# Dotfiles root (repo): zsh/.zshrc -> parent of zsh/
export DOTFILES="${DOTFILES:-${${(%):-%x}:A:h:h}}"
export ZSH="${ZSH:-${HOME}/.oh-my-zsh}"
ZSH_THEME="robbyrussell"
plugins=(git)

# History
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHDMINUS
setopt EXTENDED_HISTORY SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE
setopt INTERACTIVE_COMMENTS COMPLETE_IN_WORD ALWAYS_TO_END AUTO_MENU
unsetopt MENU_COMPLETE FLOW_CONTROL

# Paths
typeset -U path PATH
path=(
  "${HOME}/.local/bin"
  /opt/homebrew/bin
  /usr/local/bin
  $path
)

_brew_prefix=""
if command -v brew >/dev/null 2>&1; then
  _brew_prefix="$(brew --prefix 2>/dev/null || true)"
fi

# Completion: extra definitions (load before Oh My Zsh)
if [[ -n "${_brew_prefix}" && -d "${_brew_prefix}/share/zsh-completions" ]]; then
  fpath=("${_brew_prefix}/share/zsh-completions" $fpath)
fi
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-${HOME}/.cache}/zsh"
mkdir -p "${ZSH_CACHE_DIR}"

export EDITOR='mvim'

_clean_fpath=()
for _fpath_dir in $fpath; do
  if [[ ! -d "${_fpath_dir}" ]]; then
    continue
  fi

  _has_broken_symlink=0
  for _entry in "${_fpath_dir}"/*(N); do
    if [[ -L "${_entry}" && ! -e "${_entry}" ]]; then
      _has_broken_symlink=1
      break
    fi
  done

  if (( _has_broken_symlink )); then
    _sanitized_dir="${ZSH_CACHE_DIR}/fpath/${${_fpath_dir#/}:gs/\//_}"
    mkdir -p "${_sanitized_dir}"
    for _sanitized_entry in "${_sanitized_dir}"/*(N); do
      rm -f "${_sanitized_entry}"
    done
    for _entry in "${_fpath_dir}"/*(N); do
      if [[ -e "${_entry}" || ! -L "${_entry}" ]]; then
        ln -sf "${_entry}" "${_sanitized_dir}/${_entry:t}"
      fi
    done
    _clean_fpath+=("${_sanitized_dir}")
  else
    _clean_fpath+=("${_fpath_dir}")
  fi
done
fpath=("${_clean_fpath[@]}")
unset _clean_fpath _fpath_dir _entry _has_broken_symlink _sanitized_dir _sanitized_entry

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${ZSH_CACHE_DIR}"

if [[ -r "${ZSH}/oh-my-zsh.sh" ]]; then
  source "${ZSH}/oh-my-zsh.sh"
else
  autoload -Uz compinit
  compinit -C
fi

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# zsh-autosuggestions (before syntax highlighting)
if [[ -n "${_brew_prefix}" && -r "${_brew_prefix}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "${_brew_prefix}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# zsh-syntax-highlighting must be last
if [[ -n "${_brew_prefix}" && -r "${_brew_prefix}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "${_brew_prefix}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# fzf (Homebrew)
if command -v brew >/dev/null 2>&1; then
  _fzf_prefix="$(brew --prefix fzf 2>/dev/null)"
  if [[ -n "${_fzf_prefix}" ]]; then
    [[ -r "${_fzf_prefix}/shell/key-bindings.zsh" ]] && source "${_fzf_prefix}/shell/key-bindings.zsh"
    [[ -r "${_fzf_prefix}/shell/completion.zsh" ]] && source "${_fzf_prefix}/shell/completion.zsh"
  fi
  unset _fzf_prefix
fi

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh --disable-up-arrow)"
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
[[ -x "${HOME}/.local/bin/cmux-ai-split" ]] && alias csplit='cmux-ai-split'
alias ls='ls -G'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'

# Prompt
autoload -Uz colors && colors
unset _brew_prefix

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
