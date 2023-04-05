#!/usr/bin/zsh

#### SETTINGS
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.zhistory"
HISTIGNORE='pass *'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

autoload -U colors && colors
autoload -U compinit && compinit
autoload -U select-word-style && select-word-style bash
zstyle 'completion:*' menu select
#emulate sh

# Auto completion options
setopt autocd			# Imply cd when directory path is supplied
setopt automenu			# Automatically use menu completion on 2nd tab
setopt menucomplete		# Cycle though autocomplete options
	
# History options
setopt appendhistory	# Append history file rather than replace it
setopt extendedhistory	# Save each commands time stamp
setopt histfindnodups	# Ignore duplicates when searching
setopt histignoredups	# Ignore duplicate simultaneous events
setopt histignorespace	# Ignore commands that being with space
setopt histsavenodups	# Ignore old duplicate commands on save

setopt completealiases

#### BINDKEYS
bindkey -e

# Search
bindkey '^R' history-incremental-search-backward

# Clear screen A-h
# bindkey '\eh' clear-screen

#  # Move
#  bindkey -s '\eñ' '^[[C'
#  bindkey -s '\ej' '^[[D'
#  bindkey -s '\ek' '^[[B'
#  bindkey -s '\el' '^[[A'

#### PLUGINS
[ -e /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && \
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

[ -e /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[ -e /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh ] && \
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh

[ -e /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh ] && \
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh

# LOAD PLUGINS
[ ! -d "$HOME/.local/share/zsh/spaceship" ] && \
  git clone --depth=1 https://github.com/spaceship-prompt/spaceship-prompt.git "$HOME/.local/share/zsh/spaceship"

# PROMPT
source ~/.local/share/zsh/spaceship/spaceship.zsh

# LOADING
source ~/.config/zsh/config.zsh

#### ENDING
[ -f $HOME/.xinitrc ] && rm -rf $HOME/.xinitrc 2>/dev/null
echo > /dev/null
