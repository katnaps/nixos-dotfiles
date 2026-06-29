# Lines configured by zsh-newuser-install
HISTFILE=~/.history_zsh
HISTSIZE=10000
SAVEHIST=10000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall
#
#
#
### alias list
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# alias fanspeed=$HOME/scripts/fanSpeed
alias cpustatus=$HOME/scripts/readCpuGovernor
alias setcpu=$HOME/scripts/setCpuPerformance

# Connect to bluetooth audio
alias audiobluetooth='bluetoothctl connect F4:4E:FD:49:F8:3C'

# Disconnect bluetooth connection
alias disconnectBluetooth='bluetoothctl disconnect'

# Check bluetooth battery percentage
alias batterybluetooth='bluetoothctl info | grep -E "Name|Battery"'

# Function section
# Check fan speed
function fanspeed {
	bash $HOME/scripts/fanSpeed "$@"
}

# Check PlayStation Controller Battery
function ds4Battery {
	bash $HOME/scripts/ps4BatteryCheck "$@"
}

# Prompt
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/p10k.toml)"

# Zoxide
eval "$(zoxide init --cmd cd zsh)"

# Exports
export EDITOR="nvim"
export VISUAL="nvim"

# Enable fzf with zsh history search for CTRL + R
source <(fzf --zsh)
