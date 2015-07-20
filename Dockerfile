# DOCKER-VERSION 1.0
FROM dit4c/dit4c-container-base:latest
MAINTAINER t.dettrick@uq.edu.au

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
RUN rpm --rebuilddb && fsudo yum install -y \
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
  xterm

# Get the last good build of noVNC
RUN git clone https://github.com/kanaka/noVNC.git /opt/noVNC && \
    cd /opt/noVNC && \
    git checkout 8f3c0f6b9b5e5c23a7dc7e90bd22901017ab4fc7

# Add supporting files (directory at a time to improve build speed)
COPY etc /etc
COPY var /var

# Because COPY doesn't respect USER...
USER root
RUN chown -R researcher:researcher /etc /var
USER researcher

# Check nginx config is OK
RUN nginx -t
