# PATH
fish_add_path --path $HOME/.config/scripts
fish_add_path --path $HOME/.local/bin
fish_add_path --path /usr/local/bin

# SHELL
set -gx HOSTNAME (hostname)
set -gx EDITOR nvim

# XDG
set -gx XDG_STATE_HOME $HOME/.local/share/state

# GNUPG / PASS
set -gx GNUPGHOME $HOME/.config/gnupg
set -gx PASSWORD_STORE_DIR $HOME/.local/share/vault
set -gx PASSWORD_STORE_CLIP_TIME 8

# FZF - Catppuccin Mocha
set -gx FZF_DEFAULT_OPTS '-m --ansi --layout=reverse --inline-info --prompt=»\  --pointer=█ --marker=█ --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 --color=selected-bg:#45475a,border:#313244,label:#cdd6f4'

# AWS
set -gx AWS_PROFILE none

# KUBERNETES
set -gx KUBECONFIG $HOME/.config/kube/config
set -gx KUBE_EDITOR nvim
set -gx HELM_CONFIG_HOME $HOME/.config/helm

# ANSIBLE
set -gx ANSIBLE_CONFIG $HOME/.config/ansible.cfg

# TERRAFORM
set -gx TF_PLUGIN_CACHE_DIR $HOME/.local/share/terraform/plugin-cache
mkdir -p $TF_PLUGIN_CACHE_DIR 2>/dev/null

# PYTHON
set -gx PYLINTRC $HOME/.config/pylintrc

# GO
set -gx GOPATH $HOME/.local/share/go
set -gx GOMAXPROCS 4
fish_add_path --path $GOPATH/bin

# RUST
set -gx RUSTUP_HOME $HOME/.local/share/rustup

# NODEJS
set -gx NPM_CONFIG_PREFIX $HOME/.local

# BUN
fish_add_path --path $HOME/.bun/bin

# JAVA
set -gx M2_HOME $HOME/.local/share/maven

# FLUTTER
set -gx FLUTTER_HOME $HOME/.local/share/flutter/default
fish_add_path --path $FLUTTER_HOME/bin
fish_add_path --path $HOME/.pub-cache/bin

# ANDROID
set -gx ANDROID_HOME $HOME/.local/share/android
fish_add_path --path $ANDROID_HOME/platform-tools
fish_add_path --path $ANDROID_HOME/cmdline-tools/latest/bin
fish_add_path --path $ANDROID_HOME/emulator

# RUBY
set -gx GEM_HOME $HOME/.local/share/ruby

# PODMAN
set -gx DOCKER_HOST "unix:///run/user/$UID/podman/podman.sock"

# BREW (macOS)
if test (uname) = Darwin
    fish_add_path --path /opt/homebrew/bin /opt/podman/bin
end

# NIX
fish_add_path --path $HOME/.nix-profile/bin

# OPENCODE
fish_add_path --path $HOME/.opencode/bin

# TLS (Linux)
# El tooling instalado con nix no busca el trust store del host por diseño:
# se le apunta al bundle del sistema, probando las rutas habituales (la
# canónica de Fedora, su symlink de compatibilidad y la de Debian/Ubuntu).
# El bloque NETSKOPE de debajo lo sobreescribe cuando aplica.
for ca_bundle in /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem \
    /etc/pki/tls/certs/ca-bundle.crt \
    /etc/ssl/certs/ca-certificates.crt
    if test -e $ca_bundle
        set -gx SSL_CERT_FILE $ca_bundle
        break
    end
end

# NETSKOPE
set -l netskope_cert $HOME/.local/share/certificates/netskope.crt
if test -e $netskope_cert
    set -gx AWS_CA_BUNDLE $netskope_cert
    set -gx REQUESTS_CA_BUNDLE $netskope_cert
    set -gx CURL_CA_BUNDLE $netskope_cert
    set -gx NODE_EXTRA_CA_CERTS $netskope_cert
    set -gx GIT_SSL_CAINFO $netskope_cert
    set -gx SSL_CERT_FILE $netskope_cert
    set -gx JAVA_TOOL_OPTIONS "-Djavax.net.ssl.trustStore=$HOME/.local/share/certificates/netskope.jks -Djavax.net.ssl.trustStorePassword=changeit"
end

# LOCAL ENVIRONMENT (secretos/overrides no versionados)
if test -e $HOME/.local/share/environment.fish
    source $HOME/.local/share/environment.fish
end

# NIX (fish-native)
if test -e $HOME/.nix-profile/etc/profile.d/nix.fish
    source $HOME/.nix-profile/etc/profile.d/nix.fish
else if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
end

# NIX LOCALE (Linux)
if test -f /usr/lib/locale/locale-archive
    set -gx LOCALE_ARCHIVE /usr/lib/locale/locale-archive
end

# HYPRLAND autostart (Linux, login shell, TTY1, no Wayland)
if status is-login
    and test -z "$WAYLAND_DISPLAY"
    and test (tty) = /dev/tty1
    and type -q Hyprland
    exec systemd-run --user --scope --unit=hyprland.scope --slice=desktop.slice -- nixGL Hyprland
end
