#!/usr/bin/env bash
# Claude Code status line — mirrors Starship prompt configuration
# Format: user hostname cwd  branch git_status | context%

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# ANSI color codes (will render dimmed in Claude Code status line)
BOLD_BLUE='\033[1;34m'
BOLD_RED='\033[1;31m'
BOLD_PURPLE='\033[1;35m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
BOLD_WHITE='\033[1;37m'
RESET='\033[0m'

# --- username (bold blue) ---
user=$(whoami)

# --- hostname (bold red), trim at .companyname.com ---
host=$(hostname -s)

# --- directory: show last 5 components ---
if [ -n "$cwd" ]; then
    dir="$cwd"
else
    dir=$(pwd)
fi
# Replace $HOME with ~
home="$HOME"
dir="${dir/#$home/~}"
# Keep last 5 path components
dir=$(echo "$dir" | awk -F'/' '{
    n=NF; start=n-4;
    if(start<1) start=1;
    out="";
    for(i=start;i<=n;i++){
        if(out!="") out=out"/";
        out=out$i
    }
    print out
}')

# --- git branch and status (bold purple / colored counts) ---
git_branch=""
git_status_str=""
if git -C "${cwd:-$(pwd)}" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "${cwd:-$(pwd)}" symbolic-ref --short HEAD 2>/dev/null \
             || git -C "${cwd:-$(pwd)}" rev-parse --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        git_branch=" $branch "
    fi

    # Porcelain status counts
    staged_count=0
    deleted_count=0
    modified_count=0
    untracked_count=0
    while IFS= read -r line; do
        xy="${line:0:2}"
        x="${xy:0:1}"
        y="${xy:1:1}"
        if [ "$xy" = "??" ]; then
            untracked_count=$((untracked_count + 1))
        else
            [ "$x" != " " ] && [ "$x" != "?" ] && staged_count=$((staged_count + 1))
            [ "$y" = "D" ] || [ "$x" = "D" ] && deleted_count=$((deleted_count + 1))
            [ "$y" = "M" ] && modified_count=$((modified_count + 1))
        fi
    done < <(git -C "${cwd:-$(pwd)}" status --porcelain 2>/dev/null)

    parts=""
    [ "$staged_count" -gt 0 ]    && parts="${parts}$(printf "${BOLD_GREEN}${staged_count} ${RESET}")"
    [ "$deleted_count" -gt 0 ]   && parts="${parts}$(printf "${BOLD_RED}${deleted_count} ${RESET}")"
    [ "$modified_count" -gt 0 ]  && parts="${parts}$(printf "${BOLD_BLUE}${modified_count} ${RESET}")"
    [ "$untracked_count" -gt 0 ] && parts="${parts}$(printf "${BOLD_YELLOW}${untracked_count} ${RESET}")"
    git_status_str="$parts"
fi

# --- context window ---
ctx_str=""
if [ -n "$remaining" ]; then
    remaining_int=$(printf "%.0f" "$remaining")
    ctx_str=" | ctx:${remaining_int}%"
fi

# --- rate limits (Claude.ai subscription usage) ---
rate_str=""
if [ -n "$five_hour" ]; then
    five_int=$(printf "%.0f" "$five_hour")
    rate_str="${rate_str} 5h:${five_int}%"
fi
if [ -n "$seven_day" ]; then
    seven_int=$(printf "%.0f" "$seven_day")
    rate_str="${rate_str} 7d:${seven_int}%"
fi
[ -n "$rate_str" ] && rate_str=" |${rate_str}"

# --- model ---
model_str=""
[ -n "$model" ] && model_str=" | $model"

# Build the line
printf "${BOLD_BLUE}%s${RESET} ${BOLD_RED}%s${RESET} %s " "$user" "$host" "$dir"
if [ -n "$git_branch" ]; then
    printf "${git_status_str}${BOLD_PURPLE}%s${RESET}" "$git_branch"
fi
printf "%s%s%s" "$ctx_str" "$rate_str" "$model_str"
