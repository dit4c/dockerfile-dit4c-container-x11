# DOCKER-VERSION 1.0
FROM dit4c/dit4c-container-base:debian
MAINTAINER t.dettrick@uq.edu.au

# Install
# - MESA DRI drivers for software GLX rendering
# - X11 dummy & void drivers
# - reasonable fonts for UI
# - xpra
# - dbus for xpra notifications
# - python-websockify
# - tint2
# - xterm
RUN echo "deb http://xpra.org/ jessie main" >> /etc/apt/sources.list && \
  curl -Ls http://winswitch.org/gpg.asc | apt-key add - && \
  apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libgl1-mesa-dri \
    xserver-xorg-video-dummy \
    xserver-xorg-input-void \
    x11-xserver-utils \
    xinit \
    fonts-dejavu \
    dbus-x11 \
    xpra \
    websockify \
    tint2 \
    xterm && \
  apt-get clean

# Add supporting files (directory at a time to improve build speed)
COPY etc /etc
COPY var /var
COPY tmp /tmp

RUN cd / && \
  patch -p1 -l -b < /tmp/xpra_client.patch && \
  patch -p1 -l -b < /tmp/xpra_window.patch && \
  patch -p1 -l -b < /tmp/xpra_html_index.patch

# Check nginx config is OK
RUN nginx -t
