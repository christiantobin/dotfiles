# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source "$OMARCHY_PATH/default/bash/rc"

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

# Aliases from my old setup
alias p='sudo pacman'
alias vi='nvim'
alias b='nvim ~/.bashrc'
alias bs='clear && source ~/.bashrc'
command -v lsd >/dev/null && alias ls='lsd'
command -v ncdu >/dev/null && alias disk='ncdu'
alias dotfs='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias lazydot='/usr/bin/lazygit --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias discord='webcord'

# clear typos
alias celar='clear' clera='clear' cls='clear' lear='clear' qq='clear' clea='clear' sclear='clear' cl='clear'

# Local and npm-global bins
export PATH="$PATH:$HOME/.local/bin"
export PATH="$HOME/.npm-global/bin:$PATH"

# neofetch was abandoned; fastfetch is the maintained replacement
alias neofetch='fastfetch'

# System summary at the start of each interactive terminal
if [[ -t 1 ]]; then
  echo ""
  fastfetch
fi
