#! /usr/bin/env python3

import argparse, common, os, pathlib, platform, subprocess, sys

def main():
  os.chdir(os.path.join(os.path.dirname(__file__), os.pardir))
  
  parser = argparse.ArgumentParser()
  parser.add_argument('--version', default='m89')
  parser.add_argument('--skia-branch')
  parser.add_argument('--skia-commit')
  args = parser.parse_args()

  # Clone depot_tools
  if not os.path.exists("depot_tools"):
    subprocess.check_call(["git", "clone", "https://chromium.googlesource.com/chromium/tools/depot_tools.git", "depot_tools"])

  # Clone Skia
  skia_branch = args.skia_branch or ("chrome/" + args.version)
  if os.path.exists("skia"):
    os.chdir("skia")
    if subprocess.check_output(["git", "branch", "--list", skia_branch]):
      print("> Advancing", skia_branch)
      subprocess.check_call(["git", "checkout", "-B", skia_branch])
      subprocess.check_call(["git", "fetch"])
      subprocess.check_call(["git", "reset", "--hard", "origin/" + skia_branch])
    else:
      print("> Fetching", skia_branch)
      subprocess.check_call(["git", "fetch", "origin", skia_branch + ":remotes/origin/" + skia_branch])
      subprocess.check_call(["git", "reset", "--hard"])
      subprocess.check_call(["git", "checkout", skia_branch])
  else:
    print("> Cloning", skia_branch)
    subprocess.check_call(["git", "clone", "https://skia.googlesource.com/skia", "--quiet", "--branch", skia_branch, "skia"])
    os.chdir("skia")

  # Checkout commit
  if args.skia_commit:
    print("> Checking out", args.skia_commit)
    subprocess.check_call(["git", "-c", "advice.detachedHead=false", "checkout", args.skia_commit])
  else:
    commit = subprocess.check_output(["git", "rev-parse", "HEAD"]).decode('utf-8')
    print("> Using", commit)

  # Apply patches
  subprocess.check_call(["git", "reset", "--hard"])
  for x in pathlib.Path(os.pardir, 'patches').glob('*.patch'):
    print("> Applying", x)
    subprocess.check_call(["git", "apply", str(x)])

  # git deps
  if 'windows' == common.system:
    env = os.environ.copy()
    env['PYTHONHTTPSVERIFY']='0'
    subprocess.run(["python", "tools/git-sync-deps"], check=True, env=env)
  else:
    subprocess.check_call(["python2", "tools/git-sync-deps"])

  return 0

if __name__ == '__main__':
  sys.exit(main())
