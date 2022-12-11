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
bindkey '^R' history-incremental-search-backward
bindkey '^H' backward-kill-word
bindkey '^[^?' backward-kill-word
bindkey "\033[1~" beginning-of-line
bindkey "\033[4~" end-of-line
bindkey  "^[[3~"  delete-char

#### PLUGINS
[ -e /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && \
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

[ -e /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[ -e /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh ] && \
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh

[ -e /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh ] && \
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh

source ~/.config/zsh/lib/themes/theme.zsh-theme

# LOADING
for file in $(ls ~/.config/zsh/lib/*.zsh); do
    source $file
done

#### ENDING
[ -f $HOME/.xinitrc ] && rm -rf $HOME/.xinitrc 2>/dev/null
echo > /dev/null
