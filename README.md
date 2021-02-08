# Automated Skia builds

This repo is dedicated to building Skia binaries for use in [Skija](https://github.com/JetBrains/skija) and [Skiko](https://github.com/JetBrains/skiko).

## Prebuilt binaries

Prebuilt binaries can be found [in releases](https://github.com/JetBrains/skia-build/releases).

## Building next version of Skia

Update `skia_branch`, `skia_commit` and `release` in [.github/workflows/build.yml](https://github.com/JetBrains/skia-build/blob/master/.github/workflows/build.yml).

## Building locally

```sh
python3 script/checkout.py --version=m89
python3 script/build.py
python3 script/archive.py
```

More options can be specified for checkout:

```sh
python3 script/checkout.py [--version VERSION] [--skia-branch SKIA_BRANCH] [--skia-commit SKIA_COMMIT]
```

To build a debug build:

```sh
python3 script/checkout.py --version=m89
python3 script/build.py --debug
python3 script/archive.py --debug
```