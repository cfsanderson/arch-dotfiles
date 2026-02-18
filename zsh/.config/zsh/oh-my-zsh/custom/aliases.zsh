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
alias cal='khal interactive 2>/dev/null; vdirsyncer sync 2>/dev/null &'
alias calc='qalc'
alias calday='khal list'
alias code='codium'
alias dots='cd $HOME/Projects/arch-dotfiles/'
alias fedorapack='dnf repoquery --userinstalled --qf "%{name}\n" 2>/dev/null | sort -u > ~/Projects/arch-dotfiles/packages/packages-dnf.txt && flatpak list --app --columns=application 2>/dev/null | sort > ~/Projects/arch-dotfiles/packages/packages-flatpak.txt && grep -l "copr" /etc/yum.repos.d/*.repo 2>/dev/null | xargs grep -l "enabled=1" | sed "s|.*/copr:copr.fedorainfracloud.org:||;s|\.repo||" | tr ":" "/" | grep -v "^@" | sort > ~/Projects/arch-dotfiles/packages/packages-copr.txt && echo "Package lists updated."' 
alias gs='git switch'
alias home='cd $HOME && clear && fastfetch'
alias kbhypr='bat $HOME/Documents/keyboard-shorcuts/hyprland.md'
alias kbtmux='bat $HOME/Documents/keyboard-shorcuts/tmux.md'
alias kbaerc='bat $HOME/Documents/keyboard-shorcuts/aerc.md'
alias kbyazi='bat $HOME/Documents/keyboard-shorcuts/yazi.md'
alias key='bat ~/Documents/keyboard-shortcuts.md'
alias l='ls -lAh'
alias la='ls -a'
alias mail='aerc'
alias music='rmpc; rmpc stop'
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
alias spotify='brave-browser --app=https://open.spotify.com'
alias st='nmcli connection show --active && speedtest-cli'
alias stowr='cd ~/Projects/arch-dotfiles/ && stow -R -t $HOME */'
alias to=touch_open
touch_open() {
	if ! [ "$1" ]; then
		echo "need a file!" >&2
		return 1
	fi
	: > "$1" && nvim "$1"
}
alias tp='trash-put'
alias waybarreload='pkill -SIGUSR2 waybar'
alias wl='hyprctl clients -j | jq -r ".[] | select(.class != \"kitty\") | \"\(.workspace.id)\t\(.class)\t\(.title)\""'
alias screenrecordingstart='wf-recorder -f "$HOME/Videos/ScreenRecordings/recording-$(date +%Y-%m-%d_%H-%M-%S).mp4" &'
alias screenrecordingstop='pkill -SIGINT wf-recorder'
alias weather='clear && curl wttr.in/Richmond'
alias weathr='curl -s "wttr.in/Richmond,VA?format=3"'
alias yazikeys='bat ~/Documents/yazikeys.md'
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

# Private/sensitive aliases go in ~/.config/zsh/oh-my-zsh/custom/local.zsh
# That file is auto-sourced by Oh My Zsh but gitignored (entire oh-my-zsh/ dir is ignored)
