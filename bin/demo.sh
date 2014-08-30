#!/usr/bin/env sh

xinit ./bin/xinitrc -- \
  /usr/local/bin/Xephyr :42 -ac -br -noreset -screen 1600x500
