#! /usr/bin/env python3

import common, json, os, re, sys, urllib.request

def main():
  os.chdir(os.path.join(os.path.dirname(__file__), os.pardir, 'skia'))
  release = common.release()
  build_type = common.build_type()
  os.chdir(os.pardir)

  zip = 'Skia-' + release + '-' + common.system + '-' + build_type + '-' + common.machine + '.zip'
  if not os.path.exists(zip):
    print('Can\'t find "' + zip + '"')
    return 1

  headers = common.github_headers()

  try:
    resp = urllib.request.urlopen(urllib.request.Request('https://api.github.com/repos/JetBrains/skia-build/releases/tags/' + release, headers=headers)).read()
  except urllib.error.URLError as e:
    data = '{"tag_name":"' + release + '","name":"' + release + '"}'
    resp = urllib.request.urlopen(urllib.request.Request('https://api.github.com/repos/JetBrains/skia-build/releases', data=data.encode('utf-8'), headers=headers)).read()
  upload_url = re.match('https://.*/assets', json.loads(resp.decode('utf-8'))['upload_url']).group(0)

  print('Uploading', zip, 'to', upload_url)
  headers['Content-Type'] = 'application/zip'
  headers['Content-Length'] = os.path.getsize(zip)
  with open(zip, 'rb') as data:
    urllib.request.urlopen(urllib.request.Request(upload_url + '?name=' + zip, data=data, headers=headers))

  return 0

if __name__ == '__main__':
  sys.exit(main())
