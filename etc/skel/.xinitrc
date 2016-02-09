#!/bin/bash

if [[ ! -f  ~/.config/nitrogen/bg-saved.cfg ]]; then
  nitrogen --save --set-centered /usr/local/shared/backgrounds/openbox.png --set-color=#222222
fi

nitrogen --restore
tint2 -c /etc/tint2/panel.tint2rc &
openbox
