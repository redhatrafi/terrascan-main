#!/bin/bash

set +e

# Full path to tfsec executable
TFSEC_EXECUTABLE="${WORKSPACE}/tools/tfsec"

# Run tfsec using the full path
$TFSEC_EXECUTABLE -f junit,default --out tfsec --config-file tfsec.yaml --no-color --include-passed

# Capture the exit status code
echo $? > tfsecstatus.txt
