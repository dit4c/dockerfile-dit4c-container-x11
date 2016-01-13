# DOCKER-VERSION 1.0
FROM dit4c/dit4c-container-base
MAINTAINER t.dettrick@uq.edu.au

ENV DOCKER_FIX=''

# Install
# - MESA DRI drivers for software GLX rendering
# - X11 dummy & void drivers
# - X11 xinit binary
# - reasonable fonts for UI
# - x11vnc
# - python-websockify
# - openbox
# - tint2
# - xterm
RUN rpm --rebuilddb && \
    yum install -y \
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
    tint2 \
    xterm && \
  rm -f /usr/share/applications/x11vnc.desktop

# Get the last good build of noVNC
RUN git clone https://github.com/kanaka/noVNC.git /opt/noVNC && \
    cd /opt/noVNC && \
    git checkout 8f3c0f6b9b5e5c23a7dc7e90bd22901017ab4fc7

# Install latest lxrandr from RPM and icons from Yum
# (Rebuild icon cache to be slower but much smaller)
RUN rpm --rebuilddb && \
  yum localinstall -y https://dl.fedoraproject.org/pub/fedora/linux/development/rawhide/x86_64/os/Packages/l/lxrandr-0.3.0-1.fc23.x86_64.rpm && \
  yum install -y gnome-icon-theme && \
  gtk-update-icon-cache --force --index-only /usr/share/icons/gnome

# Add supporting files (directory at a time to improve build speed)
COPY etc /etc
COPY var /var

# Check nginx config is OK
RUN nginx -t
