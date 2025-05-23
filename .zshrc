# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Add old bash exports

export PATH="/root/.local/bin:$PATH"
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

function getos() {                                                   
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    MSYS_NT*)   machine=Git;;
    *)          machine="UNKNOWN:${unameOut}"
esac;
echo "$machine";
}


# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git aws direnv)
# MAC specific settings
if [ "$(getos)" = Mac ]; then                                              
    plugins=(git aws)
else
    plugins=(git)
fi


# User configuration
#
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define nliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias vim=nvim
alias st=starship_toggle
alias sp=ssh_spawn
alias docker=podman
alias pm=podman

# Autocopmletion for pipx in zsh
autoload -Uz compinit
compinit

eval "$(register-python-argcomplete pipx)"
# kubectl autocompletion
if [ "$(getos)" = Mac ]; then                                              
    source <(switcher init zsh)
    # switch.sh script has to run the switcher binary...
    alias kswitch=switch
    compdef kswitch='switcher'
fi

source <(kubectl completion zsh)
alias k=kubectl
compdef k='kubectl'
source <(helm completion zsh)

# MAC specific settings
if [ "$(getos)" = Mac ]; then                                              
    export AWS_PROFILE=saml
    export HOMEBREW_NO_AUTO_UPDATE=1
    export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
    export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
fi

if [ "$(getos)" = Linux ]; then                                              
    export PATH="$PATH:/usr/local"
fi
# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# source custom functions
. ~/.local/bin/dswitch
# oh-my-zsh
source $ZSH/oh-my-zsh.sh
# Use starship prompt
eval "$(starship init zsh)"

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:/opt/nvim-linux64/bin"

# direnv config to start automagically:
## ensure compatibility tmux <-> direnv
#if [ -n "$TMUX" ] && [ -n "$DIRENV_DIR" ]; then
#    unset -m "DIRENV_*"  # unset env vars starting with DIRENV_
#fi
#eval "$(direnv hook bash)"


export GPG_TTY=$(tty)
setopt COMBINING_CHARS
export KUBECONFIG="$HOME/.kube/config/bika-config"
. <(flux completion zsh)
