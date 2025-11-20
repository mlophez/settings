# Description: Configuración de Fish shell

# Exit if not interactive
if not status is-interactive
  exit
end

# Historial
#set -Ux fish_history (string join "" $HOME "/.local/share/fish/fish_history")
#set -U HISTSIZE 10000
#set -U SAVEHIST 10000
# Fish no soporta HISTIGNORE, pero puedes usar:
# set -U fish_history (contains --regex '^pass ')

# Umask
#umask 022

#fish_vi_key_bindings
#set -g fish_complete_path $fish_complete_path

# History options
#set -g fish_history_save (date "+%s")

# Key bindings
#bind \e\[H beginning-of-line
#bind \e\[F end-of-line
#bind \e\[3~ delete-char
#bind \cr history-search-backward

# Plugins
if test -e "$HOME/.config/zsh/plugins/fzf-history-search.zsh"
    # No existe equivalente directo; usar fzf.fish:
    # fisher install jethrokuan/fzf
end

# Prompt
if type -q starship
    starship init fish | source
end

# Completions
if type -q kubectl
    kubectl completion fish | source
end

# Config

# Fix nixGL
set -e LD_LIBRARY_PATH
set -e LIBGL_DRIVERS_PATH
set -e LIBVA_DRIVERS_PATH
set -e __EGL_VENDOR_LIBRARY_FILENAMES
