FROM ghcr.io/ublue-os/bluefin:gts

# Custom packages
# RUN dnf5 install -y <pkg>... && dnf5 clean all

# Custom configs
# COPY default/<file> /etc/<file>

RUN ostree container commit

CMD ["/sbin/init"]
