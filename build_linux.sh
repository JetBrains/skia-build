#!/bin/bash
set -o errexit -o nounset -o pipefail
cd "`dirname $0`"

if [ ! -d "depot_tools" ]; then
  git clone 'https://chromium.googlesource.com/chromium/tools/depot_tools.git'
fi
export PATH="${PWD}/depot_tools:${PATH}"

version=`cat version`
branch="chrome/${version}"

if [ -d "skia" ]; then
  pushd skia
  if [ -n "$(git branch --list ${branch})" ]; then
    echo "Advancing ${branch}"
    git checkout -B ${branch}
    git fetch
    git reset --hard origin/${branch}
  else
    echo "Fetching ${branch}"
    git fetch origin ${branch}:remotes/origin/${branch}
    git checkout -b ${branch}
  fi
else
  echo "Cloning ${branch}"
  git clone https://skia.googlesource.com/skia --quiet --depth 1 --branch ${branch}
  pushd skia
fi

python2 tools/git-sync-deps
gn gen out/Release-x64 --args="is_debug=false is_official_build=true skia_use_system_expat=false skia_use_system_icu=false \
  skia_use_system_libjpeg_turbo=false skia_use_system_libpng=false skia_use_system_libwebp=false skia_use_system_zlib=false \
  skia_use_sfntly=false skia_use_freetype=true skia_use_harfbuzz=true skia_pdf_subset_harfbuzz=true \
  skia_use_system_freetype2=false skia_use_system_harfbuzz=false skia_enable_gpu=true skia_use_gl=true \
  target_cpu=\"x64\" extra_cflags_cc=[\"-frtti\"] cxx=\"g++-9\""
ninja -C out/Release-x64 skia modules

zip --recurse-paths --quiet ../Skia-${version}-linux-Release-x64.zip \
  out/Release-x64/*.a \
  include \
  modules/particles/include/*.h \
  modules/skottie/include/*.h \
  modules/skparagraph/include/*.h \
  modules/skplaintexteditor/include/*.h \
  modules/skresources/include/*.h \
  modules/sksg/include/*.h \
  modules/skshaper/include/*.h \
  src/core/*.h \
  src/gpu/gl/*.h \
  third_party/externals/angle2/LICENSE \
  third_party/externals/angle2/include \
  third_party/externals/freetype/docs/FTL.TXT \
  third_party/externals/freetype/docs/GPLv2.TXT \
  third_party/externals/freetype/docs/LICENSE.TXT \
  third_party/externals/freetype/include \
  third_party/externals/libpng/LICENSE \
  third_party/externals/libpng/*.h \
  third_party/externals/libwebp/COPYING \
  third_party/externals/libwebp/PATENTS \
  third_party/externals/libwebp/src/dec/*.h \
  third_party/externals/libwebp/src/dsp/*.h \
  third_party/externals/libwebp/src/enc/*.h \
  third_party/externals/libwebp/src/mux/*.h \
  third_party/externals/libwebp/src/utils/*.h \
  third_party/externals/libwebp/src/webp/*.h \
  third_party/externals/harfbuzz/COPYING \
  third_party/externals/harfbuzz/src/*.h \
  third_party/externals/swiftshader/LICENSE.txt \
  third_party/externals/swiftshader/include \
  third_party/externals/zlib/LICENSE \
  third_party/externals/zlib/*.h
