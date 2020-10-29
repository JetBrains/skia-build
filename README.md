# Automated Skia builds

This repo is dedicated to building Skia binaries for use in [Skija](https://github.com/JetBrains/skija) and [Skiko](https://github.com/JetBrains/skija).

## Prebuilt binaries

Prebuilt binaries can be found [in releases](https://github.com/JetBrains/skia-build/releases).

## Building next version of Skia

Update `skia_branch`, `skia_commit` and `release` in [.github/workflows/build.yml](https://github.com/JetBrains/skia-build/blob/master/.github/workflows/build.yml).

## Building from scratch

This script will:

- check out `depot_tools`,
- check out `skia` (latest commit from `chrome/$version` branch),
- update submodules,
- build shared library with `skshaper` and `skparagraph` modules,
- produce redistributable zip.

```sh
version=m87 ./build_macos.sh
```

If you want to specify exact commit to build:

```sh
skia_branch=chrome/m87 skia_commit=a0c82f08df58dcd0e1d143db9ccab38f8d823b95 release=m87-a0c82f0 ./build_macos.sh
```

To build debug version:

```sh
build_type=Debug version=m87 ./build_macos.sh
```

### Building step-by-step

Install `depot_tools` somewhere:

```sh
git clone 'https://chromium.googlesource.com/chromium/tools/depot_tools.git'
export PATH="${PWD}/depot_tools:${PATH}"
```

Check out `skia`:

```sh
git clone https://skia.googlesource.com/skia
cd skia
git checkout chrome/m87
```

Build Skia (macOS):

`gn` and `ninja` requires `python2` for successful work 

So next configuration command would be useful if you have several python distribution installed

```sh
echo 'script_executable = "python2"' >> ./third_party/skia/.gn
```

Run build:

```sh
python2 tools/git-sync-deps
gn gen out/Release-x64 --args="is_debug=false is_official_build=true skia_use_system_expat=false skia_use_system_icu=false skia_use_system_libjpeg_turbo=false skia_use_system_libpng=false skia_use_system_libwebp=false skia_use_system_zlib=false skia_use_sfntly=false skia_use_freetype=true skia_use_harfbuzz=true skia_pdf_subset_harfbuzz=true skia_use_system_freetype2=false skia_use_system_harfbuzz=false target_cpu=\"x64\" extra_cflags=[\"-stdlib=libc++\", \"-mmacosx-version-min=10.9\"] extra_cflags_cc=[\"-frtti\"]"
ninja -C out/Release-x64 skia modules
```