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
alias dots='cd $HOME/Projects/arch-dotfiles/' 
alias gs='git switch'
alias home='cd $HOME && clear && fastfetch'
alias key='bat ~/keyboard-shortcuts.md'
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
alias sourz='source $HOME/Projects/arch-dotfiles/zsh/.config/zsh/.zshrc && clear && fastfetch'
alias st='nmcli connection show --active && speedtest-cli'
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
alias waybarreload='pkill -SIGUSR2 waybar'
alias weather='clear && curl wttr.in/Richmond'
alias weathr='curl -s "wttr.in/Richmond,VA?format=3"'
alias yt='yt-dlp'
alias ytm='yt-dlp --extract-audio --audio-format mp3 --audio-quality 0'

# Configs
alias conf='/usr/bin/git --git-dir=$HOME/.cfs-dotfiles/ --work-tree=$HOME'
alias confalias='cd $HOME/Projects/arch-dotfiles/zsh/.config/zsh/oh-my-zsh/custom/ && nvim aliases.zsh'
alias confkitty='cd $HOME/Projects/arch-dotfiles/kitty/.config/kitty/ && nvim .'
alias confhypr='cd $HOME/Projects/arch-dotfiles/hyprland/.config/hypr/ && nvim .'
alias conftmux='cd $HOME/Projects/arch-dotfiles/tmux/.config/tmux/ && nvim .'
alias confnv='cd $HOME/Projects/arch-dotfiles/nvim/.config/nvim/ && nvim init.lua'
alias confzsh='cd $HOME/Projects/arch-dotfiles/zsh/.config/zsh/ && nvim .zshrc'
