


## Neovim
I use lazy.nvim - it will bootstrap, or you just sync the packages first time
you open nvim.

## wezTerm
### workspaces / sessionizer
The workflow is:
1. attach to UNIX domain
2. load session

To create new session:
1. attach to UNIX domain
2. create session
3. save session


## Tmux
copy mode set up for mac
- <leader> + ] enters copy mode
- use 'v' (vi) mode to select and 'y' to yank


## dswitch
directory switch - bash function, needs to be sourced from `zshrc`
- script definition + function
- dotman config
- `zshrc` source

## kswitch
- kubernetes switcher: https://github.com/danielfoehrKn/kubeswitch
- NOTE: the binary has a "switch" shell script around it, which sets the env vars. (So the shell script is the true callable.)

## ansible playbooks
sudo apt install ansible to and run playbooks

sudo ansible-playbook -i localhost pipx.yml
