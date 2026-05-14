if not status is-interactive
    return
end

set -g fish_greeting

umask 022

# Cursor shape: blinking bar antes de cada prompt
function __set_cursor --on-event fish_prompt
    printf '\e[5 q'
end

# Fix nixGL
set -e LD_LIBRARY_PATH
set -e LIBGL_DRIVERS_PATH
set -e LIBVA_DRIVERS_PATH
set -e __EGL_VENDOR_LIBRARY_FILENAMES

# Starship prompt
if type -q starship
    starship init fish | source
end

# Kubectl completions
if type -q kubectl
    kubectl completion fish | source
end

# THEMES
fish_config theme choose catppuccin-mocha --color-theme=dark
