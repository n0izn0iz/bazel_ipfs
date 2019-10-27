_SHA256_DICT = {
    "v0.4.22_linux-amd64": "43431bbef105b1c8d0679350d6f496b934d005df28c13280a67f0c88054976aa",
}  # TODO: have code that fetch all sha from dist.ipfs and generates a file to import

def _ipfs_machine(r_ctx):
    uname = r_ctx.which("uname")
    if not uname:
        fail("missing tool in path: uname")
    machine = r_ctx.execute([uname, "-m"]).stdout.strip()

    # TODO: fail if not in dict
    return {
        "x86_64": "amd64",
        "amd64": "amd64",
        "x86": "386",
        "arm": "arm",
    }[machine]

def _ipfs_tools_repo_impl(r_ctx):
    # TODO: grab available versions for platform from https://dist.ipfs.io/go-ipfs/versions and  https://dist.ipfs.io/go-ipfs/{version}/dist.json
    version = r_ctx.attr.version
    full_version = "{0}_{1}-{2}".format(version, r_ctx.os.name, _ipfs_machine(r_ctx))
    r_ctx.download_and_extract(
        url = "https://dist.ipfs.io/go-ipfs/{0}/go-ipfs_{1}.tar.gz".format(version, full_version),
        sha256 = _SHA256_DICT[full_version],  # TODO: don't fail and print warning if not in dict
        stripPrefix = "go-ipfs",
    )  # TODO: check download return
    r_ctx.file("BUILD.bazel", """exports_files(["ipfs"])""")

ipfs_tools_repository = repository_rule(
    implementation = _ipfs_tools_repo_impl,
    attrs = {
        "version": attr.string(default = "v0.4.22"),
    },
)

def attr_ipfs(at):
    return at.label(default = "@bazel_ipfs_tools//:ipfs", allow_single_file = True)
