#===============================================================================
#                                     __             
#                         ____  _____/ /_  __________
#                        /_  / / ___/ __ \/ ___/ ___/
#                         / /_(__  ) / / / /  / /__  
#                        /___/____/_/ /_/_/   \___/  
#                        
#===============================================================================
#                               @cfsanderson

# --- Oh My Zsh Configuration ---
export ZSH="$HOME/.config/zsh/oh-my-zsh"

ZSH_THEME="agnoster"

plugins=(
    asdf
    git 
    npm 
    vi-mode 
    web-search 
    zsh-completions
    zsh-syntax-highlighting
)

# Load Oh My Zsh itself.
source $ZSH/oh-my-zsh.sh
# --- End Oh My Zsh ---

# Aliases moved to ~/.oh-my-zsh/custom/aliases.zsh and accessible with "confalias" alias.

# export TMUX_CONF=~/.config/tmux/tmux.conf

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line

# Vi style:
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

HIST_STAMPS="yyyy-mm-dd"
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=$HOME/.cache/zsh/history

ENABLE_CORRECTION="false"
COMPLETION_WAITING_DOTS="true"

# SSH key path
export SSH_KEY_PATH="~/.ssh/id_rsa"

fastfetch
# FZF
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
