# Automated Skia builds

This repo is dedicated to building Skia binaries for use in [Skija](https://github.com/JetBrains/skija) and [Skiko](https://github.com/JetBrains/skija).

## Prebuilt binaries

Prebuilt binaries can be found [in releases](https://github.com/JetBrains/skia-build/releases).

## Building next version of Skia

Update `skia_branch`, `skia_commit` and `release` in [.github/workflows/build.yml](https://github.com/JetBrains/skia-build/blob/master/.github/workflows/build.yml).

## Building locally

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

To build a zip archive at the end:

```sh
archive=true version=m87 ./build_macos.sh
```

To skip checkout (e.g. for builds with local changes):

```sh
checkout=false version=m87 ./build_macos.sh
```