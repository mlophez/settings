if not status is-interactive
    return
end
umask 022

set -g fish_greeting
# Fix nixGL
set -e LD_LIBRARY_PATH
set -e LIBGL_DRIVERS_PATH
set -e LIBVA_DRIVERS_PATH
set -e __EGL_VENDOR_LIBRARY_FILENAMES

# THEMES
#fish_config theme choose catppuccin-mocha --color-theme=dark

# Cursor shape: blinking bar antes de cada prompt
function __set_cursor --on-event fish_prompt
    printf '\e[5 q'
end

# Starship prompt
if type -q starship
    starship init fish | source
end

# Kubectl completions
# if type -q kubectl
#     kubectl completion fish | source
# end

