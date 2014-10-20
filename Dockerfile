# DOCKER-VERSION 1.0
FROM dit4c/dit4c-container-base
MAINTAINER t.dettrick@uq.edu.au

# Install real systemd so we can install Xorg server binary
RUN yum swap -y -- remove fakesystemd -- install systemd systemd-libs

# Install
# - MESA DRI drivers for software GLX rendering
# - X11 dummy & void drivers
# - X11 xinit binary
# - x11vnc
# - python-websockify
# - openbox
# - urxvt
RUN yum install -y \
  mesa-dri-drivers \
  xorg-x11-drv-dummy \
  xorg-x11-drv-void \
  xorg-x11-xinit \
  dejavu-sans-fonts \
  dejavu-sans-mono-fonts \
  dejavu-serif-fonts \
  x11vnc \
  python-websockify \
  openbox \
  rxvt-unicode

# Get the last good build of noVNC
RUN git clone https://github.com/kanaka/noVNC.git /opt/noVNC && \
    cd /opt/noVNC && \
    git checkout fb64ed213584423475a262631b6be2e2a157c628

# Add supporting files (directory at a time to improve build speed)
COPY etc /etc
COPY var /var
# Chowned to root, so reverse that change
RUN chown -R researcher /var/log/{easydav,supervisor}

# Check nginx config is OK
RUN nginx -t
