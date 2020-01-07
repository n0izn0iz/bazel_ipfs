load("@bazel_ipfs//:versions.bzl", "GO_IPFS_DIST_DICT")

def _ipfs_machine(r_ctx):
    uname = r_ctx.which("uname")
    if not uname:
        fail("missing tool in path: uname")
    machine = r_ctx.execute([uname, "-m"]).stdout.strip()

    # TODO: fail if not in dict
    return {
        "x86_64": "amd64",
        "amd64": "amd64",
    }[machine]

def _ipfs_os(r_ctx):
    return {
        "linux": "linux",
        "mac os x": "darwin",
        "darwin": "darwin",
    }[r_ctx.os.name]

def _ipfs_tools_repo_impl(r_ctx):
    version = r_ctx.attr.version
    dist_info = GO_IPFS_DIST_DICT[_ipfs_os(r_ctx)][_ipfs_machine(r_ctx)][version]
    r_ctx.download_and_extract(
        url = dist_info["url"],
        integrity = dist_info["sri"],
        stripPrefix = "go-ipfs",
    )
    r_ctx.file("BUILD.bazel", """exports_files(["ipfs"])""")

ipfs_tools_repository = repository_rule(
    implementation = _ipfs_tools_repo_impl,
    attrs = {
        "version": attr.string(default = "v0.4.22"),
    },
)

def attr_ipfs(at):
    return at.label(default = "@bazel_ipfs_tools//:ipfs", allow_single_file = True)
