#!/usr/bin/zsh

function settheme() {
    local gnome_schema="org.gnome.desktop.interface"
    # THEME
    ## CURSORS
    [ ! -d $HOME/.icons/default ] && mkdir -p $HOME/.icons/default &>/dev/null
    echo "[Icon Theme]" > $HOME/.icons/default/index.theme
    echo "Inherits=$XCURSOR_THEME" >> $HOME/.icons/default/index.theme

    ## GTK
    [ ! -d $HOME/.config/gtk-3.0 ] && mkdir -p $HOME/.config/gtk-3.0 &> /dev/null
    cat << EOF > $HOME/.config/gtk-3.0/settings.ini
[Settings]
gtk-theme-name=$GTK_THEME
gtk-icon-theme-name=$THEME_ICON
gtk-font-name=$THEME_FONT
gtk-cursor-theme-name=$XCURSOR_THEME
gtk-cursor-theme-size=0
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
EOF

    if type gsettings &>/dev/null; then
        gsettings set "$gnome_schema" gtk-theme "$GTK_THEME"
        gsettings set "$gnome_schema" icon-theme "$THEME_ICON"
        gsettings set "$gnome_schema" cursor-theme "$XCURSOR_THEME"
        gsettings set "$gnome_schema" font-name "$THEME_FONT"
    fi
}
