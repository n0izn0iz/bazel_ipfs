import requests
import codecs
import pprint


def get_dist_json(version):
    return requests.get(DIST_URL + "{}/dist.json".format(version)).json()


def hexToB64(hex):
    return codecs.encode(codecs.decode(hex, 'hex'), 'base64').decode().replace('\n', '')


DIST_URL = "https://dist.ipfs.io/go-ipfs/"

versions = requests.get(DIST_URL + "versions").text.split()

# TODO: parallelize
dist_jsons = [get_dist_json(version) for version in versions]

# Supported by bazel_ipfs
PLATFORMS_SUPPORTED = ["darwin", "linux"]
ARCHS_SUPPORTED = ["amd64"]

result = {}

for dist_json in dist_jsons:
    platforms = dist_json["platforms"]
    platforms_names = platforms.keys()
    if len(platforms_names) < 1:
        continue
    version = dist_json["version"]
    for pltfrm in platforms_names:
        if pltfrm not in PLATFORMS_SUPPORTED:
            continue
        archs = platforms[pltfrm]["archs"]
        archs_names = archs.keys()
        for arch_name in archs_names:
            if arch_name not in ARCHS_SUPPORTED:
                continue
            arch = archs[arch_name]
            if not 'sha512' in arch:
                continue
            # Add to result
            if not pltfrm in result:
                result[pltfrm] = {}
            pr = result[pltfrm]
            if not arch_name in pr:
                pr[arch_name] = {}
            pr[arch_name][version] = {
                "sri": "sha512-" + hexToB64(arch["sha512"]),
                "url": DIST_URL + "{}{}".format(version, arch["link"])
            }

bzl = """GO_IPFS_DIST_DICT = {}""".format(
    pprint.pformat(result, indent=4))

print(bzl)
