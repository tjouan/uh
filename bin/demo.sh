#!/usr/bin/env sh

if [ -n "$XINERAMA" ]; then
  xinit ./bin/xinitrc -- \
    /usr/local/bin/Xephyr :42 -ac -br -noreset +xinerama \
    -origin 0,0 -screen 960x500 \
    -origin 960,0 -screen 960x500
else
  xinit ./bin/xinitrc -- \
    /usr/local/bin/Xephyr :42 -ac -br -noreset -screen 1600x500
fi
