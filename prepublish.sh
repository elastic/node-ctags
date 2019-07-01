#!/bin/bash
# Copyright (c) Facebook, Inc. and its affiliates. All Rights Reserved.

set -e

if [[ -n "$npm_config_argv" ]]; then
  # See https://github.com/npm/npm/issues/3059
  npm_first_arg=$(node -p 'JSON.parse(process.env.npm_config_argv).original[0]')
  [[ $npm_first_arg != "publish" ]] && exit
fi

VERSION=$(node -p 'require("./package.json").version')
BINARY_HOST_MIRROR="https://github.com/elastic/node-ctags/releases/download/v${VERSION}/"

TARGETS=(
  "--target_platform=linux --runtime=node --target=10.15.2"

  "--target_platform=darwin --runtime=node --target=10.15.2"

  "--target_platform=win32 --runtime=node --target=10.15.2"
)

MODULE_NAMES=(
  "ctags"
)

for module_name in "${MODULE_NAMES[@]}"; do
  pushd "$module_name"
    npm install
    for target in "${TARGETS[@]}"; do
      env "npm_config_${module_name}_binary_host_mirror="$BINARY_HOST_MIRROR"" \
        ./node_modules/.bin/node-pre-gyp install $target
    done
  popd
done
