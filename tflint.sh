#!/bin/bash

set -e
set -x

INSTALL_DIR="$1"

# Debugging: Print the contents of the installation directory
ls -l "$INSTALL_DIR"

# Run tflint with the correct path
"${INSTALL_DIR}/tflint" --init
"${INSTALL_DIR}/tflint" --recursive --config "$(pwd)/.tflint.hcl"
