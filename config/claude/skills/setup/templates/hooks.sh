#!/usr/bin/env bash
# Tooling commands for the agent validation hooks. THIS IS THE ONLY FILE TO EDIT when the
# formatter, linter, build command, test command or protected paths of this project change.
#
# It is sourced by the scripts in scripts/agent/, which hold the hook logic and nothing else.
# Requirements: bash 3.2+, and jq for guard.sh and validate.sh.
# shellcheck shell=bash

# --- Per-file commands -------------------------------------------------------
# Both functions receive one absolute file path and run the tool on that file.
# Return 3 when there is no tool for the file type: the caller then skips it silently.

format_file() {
  local file="$1"
  case "$file" in
    # *.py)              ruff format -- "$file" ;;
    # *.go)              gofmt -w -- "$file" ;;
    # *.ts|*.tsx|*.json) npx --yes prettier --write -- "$file" ;;
    # *.tf)              terraform fmt -- "$file" ;;
    *) return 3 ;;
  esac
}

lint_file() {
  local file="$1"
  case "$file" in
    # *.py)       ruff check -- "$file" ;;
    # *.go)       golangci-lint run -- "$file" ;;
    # *.ts|*.tsx) npx --yes eslint -- "$file" ;;
    # *.sh)       shellcheck -- "$file" ;;
    *) return 3 ;;
  esac
}

# --- Project-wide commands ---------------------------------------------------
# Used by validate.sh, in this order, from the repository root.
# Return 3 to skip a step entirely (not configured for this project).

run_lint()  { return 3; }   # e.g. ruff check .
run_build() { return 3; }   # e.g. go build ./...
run_test()  { return 3; }   # e.g. pytest -q

# --- Guard configuration -----------------------------------------------------
# Glob patterns matched against the repository-relative path. Editing a matching
# file is denied outright. Add this project's lockfiles and generated directories.
PROTECTED_PATHS=(
  ".env"
  ".env.*"
  "*.pem"
  "*.key"
  "*.p12"
  "*.jks"
  # "package-lock.json"
  # "poetry.lock"
  # "generated/*"
)

# Extended regex: content matching it is escalated to the user instead of written.
SECRET_PATTERNS='-----BEGIN [A-Z ]*PRIVATE KEY-----|AKIA[0-9A-Z]{16}|gh[pousr]_[A-Za-z0-9]{20,}'
SECRET_PATTERNS="$SECRET_PATTERNS"'|xox[abpr]-[A-Za-z0-9-]{10,}'
SECRET_PATTERNS="$SECRET_PATTERNS"'|(api[_-]?key|secret|password|passwd|token)[[:space:]]*[:=][[:space:]]*.?[A-Za-z0-9/+=_-]{12,}'
