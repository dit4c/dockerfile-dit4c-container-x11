# DOCKER-VERSION 1.0
FROM dit4c/dit4c-container-base
MAINTAINER t.dettrick@uq.edu.au

ENV DOCKER_FIX=''

# Install
# - MESA DRI drivers for software GLX rendering
# - X11 dummy & void drivers
# - reasonable fonts for UI
# - xpra
# - dbus for xpra notifications
# - python-websockify
# - tint2
# - xterm
RUN curl -s https://winswitch.org/downloads/CentOS/winswitch.repo > /etc/yum.repos.d/winswitch.repo && \
    yum install -y \
    mesa-dri-drivers \
    xorg-x11-drv-dummy \
    xorg-x11-drv-void \
    xorg-x11-xinit \
    dejavu-sans-fonts \
    dejavu-sans-mono-fonts \
    dejavu-serif-fonts \
    xpra \
    dbus-x11 \
    python-websockify \
    tint2 \
    xterm

# Add supporting files (directory at a time to improve build speed)
COPY etc /etc
COPY var /var
COPY tmp /tmp

RUN cd / && patch -p1 -l < /tmp/xpra_client.patch

# Check nginx config is OK
RUN nginx -t
