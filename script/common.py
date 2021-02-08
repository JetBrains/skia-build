#! /usr/bin/env python3

import argparse, base64, os, platform, re, subprocess

system = {'Darwin': 'macos', 'Linux': 'linux', 'Windows': 'windows'}[platform.system()]
machine = {'AMD64': 'x64', 'x86_64': 'x64', 'arm64': 'arm64'}[platform.machine()]

def release():
  parser = argparse.ArgumentParser()
  parser.add_argument('--debug', action='store_true')
  parser.add_argument('--release')
  parser.add_argument('--version', default='m89')
  parser.add_argument('--skia-branch')
  parser.add_argument('--skia-commit')
  args = parser.parse_args()
  
  if args.release:
    return args.release

  if args.skia_branch:
    version = re.match("chrome/(m\\d+)", args.skia_branch).group(1)
  elif args.version:
    version = args.version
  else:
    branches = subprocess.check_output(['git', 'branch', '--contains', 'HEAD']).decode('utf-8')
    for match in re.finditer('chrome/(m\\d+)', branches):
      version = match.group(1)

  if args.skia_commit:
    revision = args.skia_commit
  else:
    revision = subprocess.check_output(['git', 'rev-parse', 'HEAD']).decode('utf-8')

  build_type = 'Debug' if args.debug else 'Release'
  return version + '-' + revision.strip()[:10]

def build_type():
  parser = argparse.ArgumentParser()
  parser.add_argument('--debug', action='store_true')
  (args, _) = parser.parse_known_args()
  return 'Debug' if args.debug else 'Release'
  
def github_headers():
  if os.environ.get('GITHUB_BASIC'):
    auth = 'Basic ' + base64.b64encode(os.environ.get('GITHUB_BASIC').encode('utf-8')).decode('utf-8')
  else:
    auth = 'token ' + os.environ.get('GITHUB_TOKEN')
  return {
    'Accept': 'application/vnd.github.v3+json',
    'Authorization': auth
  }