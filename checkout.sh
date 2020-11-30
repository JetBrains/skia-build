#!/bin/bash
set -o errexit -o nounset -o pipefail
cd "`dirname $0`"

if [ "${checkout:-true}" != "false" ]; then

  if [ ! -d "depot_tools" ]; then
    git clone 'https://chromium.googlesource.com/chromium/tools/depot_tools.git'
  fi
  export PATH="${PWD}/depot_tools:${PATH}"

  skia_branch=${skia_branch:-chrome/${version}}

  if [ -d "skia" ]; then
    pushd skia > /dev/null
    if [ -n "$(git branch --list ${skia_branch})" ]; then
      echo "> Advancing ${skia_branch}"
      git checkout -B ${skia_branch}
      git fetch
      git reset --hard origin/${skia_branch}
    else
      echo "> Fetching ${skia_branch}"
      git fetch origin ${skia_branch}:remotes/origin/${skia_branch}
      git checkout ${skia_branch}
    fi
  else
    echo "> Cloning ${skia_branch}"
    time git clone https://skia.googlesource.com/skia --quiet --branch ${skia_branch}
    pushd skia > /dev/null
  fi

  if [ -n "${skia_commit:-}" ]; then
    echo "> Checking out ${skia_commit}"
    git -c advice.detachedHead=false checkout ${skia_commit}
  else
    echo "> Using $(git rev-parse HEAD)"
  fi

else
  pushd skia > /dev/null
fi

git reset --hard
for patch in ../patches/*.patch; do
  git apply $patch
done

if [ -z "${release:-}" ]; then
  release="${version}-$(git rev-parse --short HEAD)"
  echo "> Release ${release}"
fi
