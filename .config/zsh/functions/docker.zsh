#!/usr/bin/zsh

# function _wine() {
#     local wineprefix="$1"
#     local args
# 
#     # PREPARATIVES
#     [[ -z "$cmd" ]] && cmd="/bin/bash"
#     [[ -z "$wineprefix" ]] && wineprefix="$HOME/.local/wine/default"
#     mkdir -p $wineprefix &>/dev/null
# 
#     # ARGS
#     args="$args --rm -it --network=host"
#     args="$args --privileged"
#     args="$args -u $USER"
#     args="$args -w $HOME"
#     args="$args -e TZ=Europe/Madrid"
#     args="$args -e DISPLAY"
#     args="$args -e WINEPREFIX=$HOME/wine"
#     args="$args -v /tmp/.X11-unix:/tmp/.X11-unix"
#     args="$args -v /etc/passwd:/etc/passwd:ro"
#     args="$args -v /etc/group:/etc/group:ro"
#     args="$args -v $wineprefix:$HOME"
#     args="$args -v $HOME:$HOME/User"
#     args="$args --device /dev/dri"
# 
#     echo $args
# }
# 
# function wine32() {
#     xhost local:root &>/dev/null
#     echo "docker run $(_wine "$@") -e WINEARCH=win32 wine:latest $2"
# }
# 
# function wine64() {
#     xhost local:root &>/dev/null
#     echo "podman run $(_wine "$@") wine:latest $2"
# }
# 
# function kali-linux() {
#     local name="kali"
#     local image="kali:latest"
#     local cmd
#     local args
# 
#     # PREPARATIVES
#     [[ -z "$@" ]] && cmd="/bin/bash" || cmd="$@"
# 
#     args="$args --rm -it --network=host"
#     args="$args --privileged"
#     args="$args -w /root"
#     args="$args -e TZ=Europe/Madrid"
#     args="$args -e DISPLAY=$DISPLAY"
#     args="$args -v $HOME:$HOME"
#     args="$args -v /root:/root"
# 
#     xhost local:root &>/dev/null
#     echo "podman run $args $image $cmd"
# }

# function container() {
#     local image="$1"
#     local cmd="$2"
#     local args
# 
#     [[ -z "$cmd" ]] && cmd="/bin/bash"
# 
#     args="$args --rm -it --network=host"
#     args="$args --privileged"
#     args="$args -u $USER"
#     args="$args -w $HOME"
#     args="$args -e TZ=Europe/Madrid"
#     args="$args -e DISPLAY=$DISPLAY"
#     args="$args -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR"
#     args="$args -v /tmp/.X11-unix:/tmp/.X11-unix"
#     args="$args -v /etc/passwd:/etc/passwd:ro"
#     args="$args -v /etc/group:/etc/group:ro"
#     args="$args -v /etc/machine-id:/etc/machine-id"
#     args="$args -v $XDG_RUNTIME_DIR:$XDG_RUNTIME_DIR"
#     args="$args -v $HOME:$HOME"
#     args="$args --device /dev/dri"
# 
#     eval "podman run $args $image $cmd"
# }
# 
# function container-root() {
#     local image="$1"
#     local cmd="$2"
#     local args
# 
#     [[ -z "$cmd" ]] && cmd="/bin/bash"
# 
#     args="$args --rm -it --network=host"
#     args="$args --privileged"
#     args="$args -w /root"
#     args="$args -e TZ=Europe/Madrid"
#     args="$args -e DISPLAY=$DISPLAY"
#     args="$args -v /tmp/.X11-unix:/tmp/.X11-unix"
#     args="$args -v $HOME:$HOME"
#     args="$args --device /dev/dri"
# 
#     eval "podman run $args $image $cmd"
# }
# 
# function terminal-app() {
#     local args
# 
#     args="$args --rm -it --network=host"
#     args="$args --privileged"
#     args="$args -e TZ=Europe/Madrid"
#     args="$args -w $(pwd)"
#     args="$args -v /etc/passwd:/etc/passwd:ro"
#     args="$args -v /etc/group:/etc/group:ro"
#     args="$args -v $HOME:$HOME"
#     #args="$args -e TERM=screen-256color"
#     #args="$args -e DISPLAY=$DISPLAY"
#     #args="$args -v /tmp/.X11-unix:/tmp/.X11-unix"
#     #args="$args -v $XDG_RUNTIME_DIR/pulse/native:$XDG_RUNTIME_DIR/pulse/native"
#     #args="$args --userns=host"
#     #args="$args --ipc=host"
#     #args="$args --tmpfs /run --tmpfs /run/lock"
#     #args="$args --device /dev/dri"
#     #args="$args -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR"
#     #args="$args -v /etc/machine-id:/etc/machine-id"
#     #args="$args -v $XDG_RUNTIME_DIR:$XDG_RUNTIME_DIR"
# 
#     eval "podman run $args $@"
# }
# 
# function wine() {
#     local image="$1"
#     local cmd="$2"
#     local args
# 
#     [[ -z "$cmd" ]] && cmd="/bin/bash"
# 
#     args="$args --rm -it --network=host"
#     args="$args --privileged"
#     args="$args -u $USER"
#     args="$args -w $HOME"
#     args="$args -e TZ=Europe/Madrid"
#     args="$args -e DISPLAY=$DISPLAY"
#     args="$args -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR"
#     args="$args -v /tmp/.X11-unix:/tmp/.X11-unix"
#     args="$args -v /etc/passwd:/etc/passwd:ro"
#     args="$args -v /etc/group:/etc/group:ro"
#     args="$args -v /etc/machine-id:/etc/machine-id"
#     args="$args -v $XDG_RUNTIME_DIR:$XDG_RUNTIME_DIR"
#     args="$args -v $HOME:$HOME"
#     args="$args --device /dev/dri"
# 
#     eval "docker run $args $image $cmd"
# }
# 
# function ubuntu() {
#     local name="ubuntu"
#     local image="ubuntu:bionic"
#     local workdir="/tmp/$USER/podman/$name"
#     local args
# 
#     # PREPARATIVES
#     mkdir -p $workdir &>/dev/null
#     podman run --rm -it --network=host -v $workdir:/workdir $image /bin/bash -c \
#         'cp /etc/passwd /workdir/passwd; cp /etc/group /workdir/group; cp /etc/shadow /workdir/shadow; chmod -R 777 /workdir/*'
# 
#     sed -i "/^$USER/d" $workdir/passwd &> /dev/null
#     cat /etc/passwd | grep mlr >> $workdir/passwd
# 
#     sed -i "/$(id -g)/d" $workdir/group &> /dev/null
#     cat /etc/group | grep "$(id -g)" >> $workdir/group
# 
#     sed -i '/^root/d' $workdir/shadow
#     echo 'root:$6$cFO3kY5u$3gcAMLzvh1P9Khweyj1IvR/jJCnyZrsyaFA9ljzDrxN6dq/h8c6zNh5tZxV97SsOSllsm62zWQHH8rw/ydyh00:18766:0:99999:7:::' >> $workdir/shadow
# 
#     args="$args --rm -it --network=host"
#     args="$args --privileged"
#     args="$args -u $USER"
#     args="$args -w $(pwd)"
#     args="$args -e TZ=Europe/Madrid"
#     args="$args -e DISPLAY=$DISPLAY"
#     args="$args -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR"
#     args="$args -v $workdir/passwd:/etc/passwd:ro"
#     args="$args -v $workdir/group:/etc/group:ro"
#     args="$args -v $workdir/shadow:/etc/shadow:ro"
#     args="$args -v $HOME:$HOME"
#     args="$args -v /tmp/.X11-unix:/tmp/.X11-unix"
#     args="$args -v $XDG_RUNTIME_DIR:$XDG_RUNTIME_DIR"
# 
#     eval "podman run $args $image /bin/bash"
# }



# ## APPS
# function sqlline() {
#     java -cp "$HOME/.local/bin/sqlline/*" sqlline.SqlLine "$@"
# }
# 
# alias vscode="code"
# function code() {
#     BINARY="$HOME/.local/bin/vscode/bin/code"
#     [ ! -e "$BINARY" ] && echo "[-] Debe instalar el binario en '$BINARY'" && return -1
# 
#     "$BINARY" --no-sandbox --unity-launch --force-device-scale-factor=1.1 --user-data-dir=$HOME/.config/vscode "$@"
# }
# 
# function sqldeveloper() {
#     BINARY="$HOME/.local/bin/sqldeveloper/sqldeveloper/bin/sqldeveloper"
#     export JAVA_HOME="$HOME/.local/bin/java/jdk-11.0.11"
#     export PATH=$JAVA_HOME/bin:$PATH
# 
#     [ ! -e "$BINARY" ] && echo "[-] Debe instalar el binario en '$BINARY'" && return -1
#     [ ! -d "$JAVA_HOME" ] && echo "[-] Debe instalar java en '$JAVA_HOME'" && return -1
# 
#     "$BINARY" "$@"
# }
# 
# function jmetter() {
#     BINARY="$HOME/.local/bin/jmetter/bin/jmeter"
#     export JAVA_HOME="$HOME/.local/bin/java/jdk-11.0.11"
#     export PATH=$JAVA_HOME/bin:$PATH
# 
#     [ ! -e "$BINARY" ] && echo "[-] Debe instalar el binario en '$BINARY'" && return -1
#     [ ! -d "$JAVA_HOME" ] && echo "[-] Debe instalar java en '$JAVA_HOME'" && return -1
# 
#     "$BINARY" "$@"
# }
# 
# function burpsuite() {
#     BINARY="$HOME/.local/bin/BurpSuiteCommunity/BurpSuiteCommunity"
# 
#     [ ! -e "$BINARY" ] && echo "[-] Debe instalar el binario en '$BINARY'" && return -1
# 
#     "$BINARY" "$@"
# }
# 
# # rclone sync -P --dry-run MyVault GoogleDrive:Obsidian/MyVault
# #function obsidian() {
# #    BINARY="$HOME/.local/bin/Obsidian.AppImage"
# #
# #    [ ! -e "$BINARY" ] && echo "[-] Debe instalar el binario en '$BINARY'" && return -1
# #
# #    "$BINARY" "$@"
# #}
# 
# #alias burpsuite="kali-linux java -jar /usr/bin/burpsuite"
# alias sngrep="kali-linux sngrep"
# ## alias geforce="GeForce.NOW-0.3.0.AppImage"
# ## alias kali-linux="terminal-app kalilinux:latest /bin/bash"
# ## alias kali-linux-user="terminal-app -u mlr kalilinux:latest /bin/bash"
# ## alias sngrep="terminal-app kalilinux:latest sngrep"
# ## # alias mvn="terminal-app maven:3.8.1-jdk-8-slim mvn"
# ## alias maven="terminal-app -u mlr -e HOME=$HOME -e USER=$USER -e MAVEN_CONFIG=$HOME/.m2 maven:3.8.1-jdk-8-slim bash"
# ## # alias sqlline="/usr/lib/jvm/java-15-openjdk/bin/java -cp '$HOME/.local/sqlline/*' -jar $HOME/.local/sqlline/sqlline-1.11.0-jar-with-dependencies.jar"
# ## # alias sqlline="/usr/lib/jvm/java-8-openjdk/bin/java -cp '$HOME/.local/sqlline/*' -jar $HOME/.local/sqlline/sqlline-1.11.0-jar-with-dependencies.jar"
# ## #alias java="terminal-app maven:3.8.1-jdk-8-slim java"
# ## #alias javac="terminal-app maven:3.8.1-jdk-8-slim javac"
# ## #alias jar="terminal-app maven:3.8.1-jdk-8-slim jar"
