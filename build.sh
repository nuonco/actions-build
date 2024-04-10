#!/bin/bash

set -e
set -o pipefail

nuon builds create -j -c $COMPONENT_ID | tee output.txt
jq -r '"BUILD_ID=\(.id)"' output.txt >> $GITHUB_OUTPUT
