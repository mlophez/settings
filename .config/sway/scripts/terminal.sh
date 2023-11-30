#!/bin/sh

SHELL="$HOME/.config/sway/scripts/terminal.sh shell"

if [ -z "${1}" ]; then
  type alacritty &>/dev/null && exec alacritty -e "zsh"
  type foot &>/dev/null && exec foot
else
  echo hola
fi


