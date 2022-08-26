#!/usr/bin/env bash

function require() {
  local cmd=$1

  if ! command -v $cmd &> /dev/null
  then
    echo "$(clr_red !!!) $cmd not found"
    exit 1
  fi
}

function load_colors() {
  local BASHRC_D=$(dirname ${BASH_SOURCE[0]})
  local BASH_COLORS=$BASHRC_D/bash_colors.sh
  mkdir -p $BASHRC_D

  if [[ ! -f $BASH_COLORS ]]
  then
    require curl
    curl -o $BASH_COLORS https://raw.githubusercontent.com/mercuriev/bash_colors/master/bash_colors.sh
  fi

  source $BASH_COLORS
}

load_colors
