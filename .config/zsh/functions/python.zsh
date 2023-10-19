#!/user/bin/zsh

function python_pip_setup() {
  [ -d "${PYTHONVENV}" ] && return
  command python -m venv "${PYTHONVENV}"
}

function pip() {
  python_pip_setup
  $PYTHONVENV/bin/pip "$@"
}
