# Automated Skia builds

This repo is dedicated to building Skia binaries for use in [Skija](https://github.com/JetBrains/skija) and [Skiko](https://github.com/JetBrains/skiko).

## Prebuilt binaries

Prebuilt binaries can be found [in releases](https://github.com/JetBrains/skia-build/releases).

## Building next version of Skia

Update `version` in [.github/workflows/build.yml](https://github.com/JetBrains/skia-build/blob/master/.github/workflows/build.yml).

## Building locally

```sh
python3 script/checkout.py --version m91-b99622c05a
python3 script/build.py
python3 script/archive.py
```

To build a debug build:

```sh
python3 script/checkout.py --version m91-b99622c05a
python3 script/build.py --build-type Debug
python3 script/archive.py --build-type Debug
```