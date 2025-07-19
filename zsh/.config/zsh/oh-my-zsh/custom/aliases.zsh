#===============================================================================
#                             ___                     
#                      ____ _/ (_)___ _________  _____
#                     / __ `/ / / __ `/ ___/ _ \/ ___/
#                    / /_/ / / / /_/ (__  )  __(__  ) 
#                    \__,_/_/_/\__,_/____/\___/____/  
#                                                     
#===============================================================================
#                               @cfsanderson

# General
alias c='clear'
alias dropbox='cd /Users/caleb/Library/CloudStorage/Dropbox/'
alias gs='git switch'
alias home='cd $HOME && clear && fastfetch'
alias l='ls -lAh'
alias mkcdir=mkdir_cd
mkdir_cd() {
    mkdir -p -- "$1" &&
    cd -P -- "$1" &&
    ls -la
}
alias notes='cd $HOME/Projects/.notes && nvim 003_DUMP.md'
alias nv='nvim'
alias sourz='source $HOME/.config/zsh/.zshrc'
alias st='speedtest'
alias to=touch_open
touch_open() {
	if ! [ "$1" ]; then
		echo "need a file!" >&2
		return 1
	fi
	: > "$1" && nvim "$1"
}
# alias tmux='env TERM=screen-256color tmux'
alias tp='trash-put'
alias wiki='cd $HOME/Projects/wiki && nv index.md'

# Configs
alias conf='/usr/bin/git --git-dir=$HOME/.cfs-dotfiles/ --work-tree=$HOME'
alias confalacritty='cd $HOME/.config/alacritty/ && nvim alacritty.toml'
alias confalias='cd $HOME/.config/zsh/oh-my-zsh/custom/ && nvim aliases.zsh'
alias confhypr='cd $HOME/.config/hypr/ && nvim .'
alias conftmux='cd $HOME/ && nvim .tmux.conf'
alias confnv='cd $HOME/.config/nvim/ && nvim init.lua'
alias confzsh='cd $HOME/.config/zsh/ && nvim .zshrc'
