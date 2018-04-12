#!/usr/bin/env bash

# Set script to exit on any errors.
set -e

#!/bin/bash

# ==========================================================================
# Setup script for installing project dependencies.
# NOTE: Run this script while in the project root directory.
#       It will not run correctly when run from another directory.
# ==========================================================================

# Set script to exit on any errors.
set -e

ICON_DIR=capitalframework/static/icons

# Initialize project dependency directories.
init() {
  if [ -f "package-lock.json" ]; then
    DEP_CHECKSUM=$(cat package*.json | shasum -a 256)
  else
    DEP_CHECKSUM=$(cat package.json | shasum -a 256)
  fi

  if [[ "$(node -v)" != 'v8.'* ]]; then
    printf "\033[1;31mPlease install Node 8.x: 'nvm install 8'\033[0m\n"
    exit 1;
  fi

  NODE_DIR=node_modules
  echo "npm components directory: $NODE_DIR"
}

# Clean project dependencies.
clean() {
  # If the node directory already exists,
  # clear it so we know we're working with a clean
  # slate of the dependencies listed in package.json.
  if [ -d $NODE_DIR ]; then
    echo 'Removing project dependency directories… $NODE_DIR'
    rm -rf $NODE_DIR
    echo 'Project dependencies have been removed.'
  fi
}

# Install project dependencies.
install() {
  echo 'Installing front-end dependencies…'
  npm install -d --loglevel warn
}

# Add a checksum file
checksum() {
  echo -n "$DEP_CHECKSUM" > $NODE_DIR/CHECKSUM
}

# If the node directory exists, $NODE_DIR/CHECKSUM exists, and
# the contents DO NOT match the checksum of package.json, clear
# $NODE_DIR so we know we're working with a clean slate of the
# dependencies listed in package.json.
clean_and_install() {
  if [ ! -f $NODE_DIR/CHECKSUM ] ||
     [ "$DEP_CHECKSUM" != "$(cat $NODE_DIR/CHECKSUM)" ]; then
    clean
    install
    checksum
  else
    echo 'Dependencies are up to date.'
  fi
}

# Run tasks to build the project for distribution.
build() {
  echo 'Building project…'
  rm -f "$ICON_DIR/*.svg"
  cp node_modules/cf-icons/src/icons/*.svg "$ICON_DIR"
}

# Execute requested (or all) functions.
if [ "$1" == "init" ]; then
  init ""
  clean_and_install
elif [ "$1" == "clean" ]; then
  echo 'Clean'
  init ""
  clean
  clean_and_install
  build
elif [ "$1" == "build" ]; then
  build
else
  init "$1"
  echo 'Clean & Install'
  clean_and_install
  build
fi
