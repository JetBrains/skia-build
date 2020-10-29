#!/bin/bash
set -o errexit -o nounset -o pipefail
cd "`dirname $0`"

auth="Authorization: token ${GITHUB_TOKEN}"
accept="Accept: application/vnd.github.v3+json"

if ! curl --fail --location --silent --show-error --header "${auth}" --header "${accept}" https://api.github.com/repos/JetBrains/skia-build/releases/tags/${release} > release.json ; then
  exit 0
fi

if grep -q "Skia-${release}-${platform}-${build_type}-x64.zip" release.json; then
    echo "> Artifact \"Skia-${release}-${platform}-${build_type}-x64.zip\" exists, stopping"
    rm release.json
    exit 1
fi

rm release.json