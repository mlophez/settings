FROM quay.io/toolbx/arch-toolbox:latest

LABEL com.github.containers.toolbox="true"

COPY ./archlinux.lst /root/archlinux.lst

RUN pacman -Syu --noconfirm && \
    pacman --needed --noconfirm -S reflector && \
    reflector --verbose --latest 5 --sort rate --protocol https --save /etc/pacman.d/mirrorlist && \
    pacman --needed --noconfirm -Sy $(cat /root/archlinux.lst | grep -v -e "^ *#" -e "aur.archlinux.org" | tr '\n' ' ') && \
    pacman -Scc --noconfirm

RUN sed 's/^.*en_US.UTF-8.*$/en_US.UTF-8 UTF-8/g' -i /etc/locale.gen && \
    echo 'LANG=en_US.UTF-8' > /etc/locale.conf && \
    ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime && \
    locale-gen

RUN ln -sf /usr/bin/distrobox-host-exec /usr/bin/distrobox && \
    ln -sf /usr/bin/distrobox-host-exec /usr/bin/podman && \
    ln -sf /usr/bin/distrobox-host-exec /usr/bin/docker && \
    ln -sf /usr/bin/distrobox-host-exec /usr/bin/rpm-ostree

# RUN chown -R mlr:mlr /nix

#RUN useradd "ab" --system --shell /usr/bin/nologin --create-home --home-dir "/var/ab" && \
#    passwd --lock "ab" && \
#    echo "ab ALL=(ALL) NOPASSWD: /usr/bin/pacman" > "/etc/sudoers.d/allow_ab_to_pacman"

CMD ["/bin/bash"]

