#!/usr/bin/env bash

if [ -n "${UNIVERSAL2_PYTHON_SUFFIX}" ]; then
  before_install 'PREFIX="${PYENV_ROOT}/versions/${UNIVERSAL2_PYTHON_SUFFIX}"; echo "Installing at ${PREFIX}"'
fi