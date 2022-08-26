#!/usr/bin/env bash

DEBIAN_VERSION_FILE=playbook/versions.yml

function extract_version() {
  local pkg=$1

  sed -n "/$pkg:/ s/.*: // p" $DEBIAN_VERSION_FILE
}

function check_debian_image() {
  local DEBIAN_RELEASE
  local current
  local latest
  local newest

  DEBIAN_RELEASE=$(extract_version debian)
  current=$(sed -n '/docker/ s/.*: // p' $DEBIAN_VERSION_FILE)
  latest=$(http GET "https://download.docker.com/linux/debian/dists/${DEBIAN_RELEASE}/stable/binary-amd64/Packages" | sed -n '/Package: docker-ce$/,/Version:/ s/Version: // p' | sort --version-sort --reverse | head -1)
  newest=$(cat << EOT | sort --version-sort --reverse | head -1
$current
$latest
EOT
)

  clr=$([[ $current != "$newest" ]] && echo clr_brown || echo clr_green)

  echo "$(clr_blue "Digital Ocean image / Debian / Docker CE:")   current = $($clr "$current")   latest = $latest"

  current=$(sed -n '/glusterfs/ s/.*: // p' $DEBIAN_VERSION_FILE)
  latest=$(http GET "http://deb.debian.org/debian/dists/${DEBIAN_RELEASE}/main/binary-amd64/Packages.gz" | gunzip | sed -n '/Package: glusterfs-server$/,/Version:/ s/Version: // p')
  clr=$([[ $current < $latest ]] && echo clr_brown || echo clr_green)

  echo "$(clr_blue "Digital Ocean image / Debian / GlusterFS server:")   current = $($clr "$current")   latest = $latest"
}

source "$(dirname "$0")/.bashrc.d/color_loader.sh"

require http
require jq
require pup

load_colors
check_debian_image
