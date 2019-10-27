load("@bazel_ipfs//:archive.bzl", _ipfs_archive = "ipfs_archive")
load("@bazel_ipfs//:pin.bzl", _ipfs_pin = "ipfs_pin")
load("@bazel_ipfs//:tools_repo.bzl", _ipfs_tools_repository = "ipfs_tools_repository")

ipfs_archive = _ipfs_archive
ipfs_pin = _ipfs_pin
ipfs_tools_repository = _ipfs_tools_repository
