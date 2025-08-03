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
alias archpack='pacman -Qen > ~/Projects/arch-dotfiles/packages/packages-official.txt && pacman -Qem > ~/Projects/arch-dotfiles/packages/packages-aur.txt'
alias c='clear'
alias dots='cd $HOME/Projects/arch-dotfiles/' 
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
alias nv='nvim'
alias open='xdg-open'
alias pbcopy='wl-copy'
alias pbpaste='wl-paste'
alias sourz='source $HOME/Projects/arch-dotfiles/zsh/.config/zsh/.zshrc'
alias st='speedtest'
alias stowr='cd ~/Projects/arch-dotfiles/ && stow -R -t $HOME */'
## removed sensitive alias
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
alias waybarreload='pkill -SIGUSR2 waybar'
alias wiki='cd $HOME/Projects/wiki && nv index.md'
alias yt='yt-dlp'
alias ytm='yt-dlp --extract-audio --audio-format mp3 --audio-quality 0'

# Configs
alias conf='/usr/bin/git --git-dir=$HOME/.cfs-dotfiles/ --work-tree=$HOME'
alias confalias='cd $HOME/Projects/arch-dotfiles/zsh/.config/zsh/oh-my-zsh/custom/ && nvim aliases.zsh'
alias confghostty='cd $HOME/Projects/arch-dotfiles/ghostty/.config/ghostty/ && nvim config'
alias confhypr='cd $HOME/Projects/arch-dotfiles/hyprland/.config/hypr/ && nvim .'
alias conftmux='cd $HOME/Projects/arch-dotfiles/tmux/.config/tmux/ && nvim .'
alias confnv='cd $HOME/Projects/arch-dotfiles/nvim/.config/nvim/ && nvim init.lua'
alias confzsh='cd $HOME/Projects/arch-dotfiles/zsh/.config/zsh/ && nvim .zshrc'
