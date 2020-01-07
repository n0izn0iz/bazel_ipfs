load("@bazel_ipfs//:tools_repo.bzl", "attr_ipfs")

EXIT_SUCCESS = 0

def _ref(r_ctx):
    if (not (r_ctx.attr.ref or r_ctx.attr.ref_file)):
        fail("must specify one of ref or ref_file")
    if (r_ctx.attr.ref and r_ctx.attr.ref_file):
        fail("ref and ref_file are mutually exclusive")
    return r_ctx.attr.ref if r_ctx.attr.ref else r_ctx.read(r_ctx.attr.ref_file).strip()

def _ipfs_archive_impl(r_ctx):
    ipfs = r_ctx.path(r_ctx.attr._ipfs)
    ref = _ref(r_ctx)
    archive = ref + "." + r_ctx.attr.extension
    command = [str(ipfs), "get", "-o", archive, ref]
    e_res = r_ctx.execute(command)
    if e_res.return_code != EXIT_SUCCESS:
        fail(" ".join(command) + " failed: " + e_res.stderr)
    r_ctx.extract(archive)
    r_ctx.delete(archive)

ipfs_archive = repository_rule(
    implementation = _ipfs_archive_impl,
    attrs = {
        "ref": attr.string(),
        "ref_file": attr.label(),
        "extension": attr.string(mandatory = True),
        "_ipfs": attr_ipfs(attr),
    },
)
