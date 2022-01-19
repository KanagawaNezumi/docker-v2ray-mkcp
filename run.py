import os
import uuid
import requests
from collections import namedtuple
from build import V2RAY_BINARY_DIR
from functools import partial
import json
import random

V2RAY_BINARY_PATH = os.path.join(V2RAY_BINARY_DIR, 'v2ray')
V2RAY_SERVER_CONFIG_PATH = os.path.join(V2RAY_BINARY_DIR, 'config.json')
V2RAY_USER_CONFIG_PATH = os.path.join(V2RAY_BINARY_DIR, 'user.config.json')
INITIAL_TAG_PATH = '/kanaganezumi'

print = partial(print, flush=True)

def _get_external_ipaddr() -> str:
    return requests.get('https://checkip.amazonaws.com').text.strip()

def _parse_config() -> namedtuple:
    fields = ('addr', 'port', 'uid', 'header_type', 'uplink_capacity', 'downlink_capacity')
    defaults = (_get_external_ipaddr(), random.randint(3000, 30000), uuid.uuid1(), 'none', 100, 100 )
    Config = namedtuple('Config', fields, defaults=defaults)
    kwrags = {field: os.getenv(field.upper()) for field in fields}
    config = Config(**{key: value for key, value in kwrags.items() if value})
    return config

def _rewrite(config: namedtuple, original: str, target: str) -> None:
    with open(original, 'r', encoding='utf-8') as fo:
        text = fo.read()
        for field in config._fields:
            text = text.replace(f'${field}', str(getattr(config, field)))
        with open(target, 'w+', encoding='utf-8') as ft:
            ft.write(text)

def _apply_config(config) -> None:
    _rewrite(config, 'config/v2ray.server.json', V2RAY_SERVER_CONFIG_PATH)
    _rewrite(config, 'config/v2ray.user.json', V2RAY_USER_CONFIG_PATH)

def _initialize():
    config = _parse_config()
    print('-' * 70)
    print('Using config:')
    _config = {field: str(getattr(config, field)) for field in config._fields}
    print(json.dumps(_config, indent=4))
    print('-' * 70)
    _apply_config(config)
    open(INITIAL_TAG_PATH, 'w+').close()
    os.system(f'cat {V2RAY_USER_CONFIG_PATH}')
    print('-' * 70)

if __name__ == '__main__':
    if not os.path.exists(INITIAL_TAG_PATH):
        _initialize()
    os.system(f'{V2RAY_BINARY_PATH} -config {V2RAY_SERVER_CONFIG_PATH}')