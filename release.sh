#!/bin/bash
set -o errexit -o nounset -o pipefail
cd "`dirname $0`"

auth="Authorization: token ${GITHUB_TOKEN}"
accept="Accept: application/vnd.github.v3+json"

if ! curl --fail --location --silent --show-error --header "${auth}" --header "${accept}" https://api.github.com/repos/JetBrains/skia-build/releases/tags/${release} > release.json ; then
  echo "> Creating release ${release}"
  curl --fail --location --silent --show-error --header "${auth}" --header "${accept}" --request POST \
    --data "{\"tag_name\":\"${release}\",\"name\":\"${release}\"}" \
    https://api.github.com/repos/JetBrains/skia-build/releases > release.json
else
  echo "> Release ${release} exists"
  cat release.json
fi

archive=`ls *.zip`
[[ $(cat release.json | grep '"upload_url"') =~ https://.*/assets ]]
upload_url="${BASH_REMATCH[0]}?name=${archive}"
rm release.json

echo "Uploading ${archive} to ${upload_url}"
curl --fail --location --silent --show-error --header "${auth}" --header "${accept}" --header "Content-Type: application/zip" --request POST --data-binary "@${archive}" ${upload_url}
