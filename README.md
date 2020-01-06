# bazel_ipfs

Tested bazel versions:
- 0.29.1
- 1.0.0
- 1.0.1
- 1.1.0
- 1.2.1
- 2.0.0

Tested oses:
- macOS-10.14
- ubuntu-18.04
- ubuntu-16.04
- arch linux

## WORKSPACE

### Quickstart

```bzl
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "bazel_ipfs",
    sha256 = "b39a930da4239beef7d4bb1761cdc7e227a7f05299c075be7e7580886cba30ce",
    urls = ["https://github.com/n0izn0iz/bazel_ipfs/releases/download/v0.0.2/bazel_ipfs.tar.gz"],
)

load("@bazel_ipfs//:index.bzl", "ipfs_archive", "ipfs_tools_repository")

ipfs_tools_repository(name = "bazel_ipfs_tools")
```

You can run `ipfs init` with `bazel run @bazel_ipfs_tools//:ipfs -- init`

### ipfs_tools_repository

#### What

Downloads ipfs for your platform and make it available to bazel in a repository

#### How

Also takes a "version" argument

```bzl
ipfs_tools_repository(
    name = "bazel_ipfs_tools",
    version = "v0.4.22",
)
```

### ipfs_archive

#### What
Pull an archive hosted on ipfs by ref and make it available to bazel as a repository

#### How

```bzl
ipfs_archive(
    name = "hello_ipfs",
    extension = "tar.gz",
    ref_file = "//:archive.ref",
)

# same as above if archive.ref contains ref
ipfs_archive(
    name = "hello_ipfs_str_ref",
    extension = "tar.gz",
    ref = "QmcLRC75TFap4UrMd1QUuTatEMazxhE8yV7PCYJZg6guMW",
)
```

Then you could use `@hello_ipfs//:some_target`

`bazel run @hello_ipfs//:hello_world`

```
INFO: Analyzed target @hello_ipfs//:hello_world (13 packages loaded, 67 targets configured).
INFO: Found 1 target...
Target @hello_ipfs//:hello_world up-to-date:
  bazel-bin/external/hello_ipfs/hello_world
INFO: Elapsed time: 15.263s, Critical Path: 0.18s
INFO: 2 processes: 2 processwrapper-sandbox.
INFO: Build completed successfully, 6 total actions
INFO: Build completed successfully, 6 total actions
Hello world!
```

## BUILD

### ipfs_pin

#### What

Pin a file to ipfs and print the ref to stdout

#### How

```bzl
load("@bazel_ipfs//:index.bzl", "ipfs_pin")
load("@rules_pkg//:pkg.bzl", "pkg_tar")

cc_binary(
    name = "hello_world",
    srcs = ["main.c"],
)

pkg_tar(
    name = "archive",
    srcs = [
        "BUILD.bazel",
        "main.c",
    ],
    extension = "tar.gz",
)

ipfs_pin(
    name = "pin",
    file = ":archive",
)
```

`bazel run pin`

```
INFO: Analyzed target //:pin (18 packages loaded, 89 targets configured).
INFO: Found 1 target...
Target //:pin up-to-date:
  bazel-bin/archive.tar.gz
INFO: Elapsed time: 14.083s, Critical Path: 0.29s
INFO: 1 process: 1 processwrapper-sandbox.
INFO: Build completed successfully, 10 total actions
INFO: Build completed successfully, 10 total actions
QmUt7H3xzwwbYDuQnQ6igcFfk4dxSvbvhdejCPrhwZ9FwR
```
