#!/usr/bin/env bash
# Claude Code status line

input=$(cat)

model=$(echo "$input"    | jq -r '.model.display_name // empty')
ctx=$(echo "$input"      | jq -r '.context_window.used_percentage // empty')
effort=$(echo "$input"   | jq -r '.effort.level // empty')
five_h=$(echo "$input"   | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_d=$(echo "$input"  | jq -r '.rate_limits.seven_day.used_percentage // empty')

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
RESET='\033[0m'

color_pct() {
    local val="$1"
    local int
    int=$(printf "%.0f" "$val")
    if   [ "$int" -ge 80 ]; then printf "${RED}%s%%${RESET}" "$int"
    elif [ "$int" -ge 50 ]; then printf "${YELLOW}%s%%${RESET}" "$int"
    else                         printf "${GREEN}%s%%${RESET}" "$int"
    fi
}

out=""

[ -n "$model" ] && out="$model"

if [ -n "$effort" ]; then
    out="${out:+$out | }effort:$effort"
fi

if [ -n "$ctx" ]; then
    seg="ctx:$(color_pct "$ctx")"
    out="${out:+$out | }$seg"
fi

if [ -n "$five_h" ] || [ -n "$seven_d" ]; then
    seg=""
    [ -n "$five_h" ]  && seg="5h:$(color_pct "$five_h")"
    [ -n "$seven_d" ] && seg="${seg:+$seg }7d:$(color_pct "$seven_d")"
    out="${out:+$out | }$seg"
fi

printf "%s" "$out"
