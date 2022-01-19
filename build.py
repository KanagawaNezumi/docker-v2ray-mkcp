import requests
from functools import partial
import os
import zipfile
import stat

V2RAY_VERSION = '4.44.0'
V2RAY_BINARY_DIR = '/v2ray'
print = partial(print, flush=True)

def _http_downlaod(url: str, filepath: str, session: requests.Session = None) -> str:
    with session or requests.Session() as session:
        with session.get(url, stream=True) as resp:
            with open(filepath, 'wb+') as f:
                for chunk in resp.iter_content(chunk_size=8192):
                    chunk and f.write(chunk)
    return int(resp.headers.get('Content-Length'))

def _download_v2ray(version: str = V2RAY_VERSION):
    addr_tmpl = 'https://github.com/v2fly/v2ray-core/releases/download/v%s/v2ray-linux-64.zip'
    size = _http_downlaod(addr_tmpl % version, v2ray_zip_path:=os.path.basename(addr_tmpl))
    with zipfile.ZipFile(v2ray_zip_path, 'r') as zip:
        zip.extractall(V2RAY_BINARY_DIR)
        os.chmod(os.path.join(V2RAY_BINARY_DIR, 'v2ray'), stat.S_IXUSR)
    os.remove(v2ray_zip_path)
    return size

if __name__ == '__main__':
    print('Downloading v2ray...', end='')
    size = _download_v2ray(V2RAY_VERSION)
    print(f'done({round(size/1024/1024, 1)} MB).')