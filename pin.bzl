load("@bazel_ipfs//:tools_repo.bzl", "attr_ipfs")

def _ipfs_pin_impl(ctx):
    f = ctx.file.file
    p = f.short_path
    ipfs = ctx.file._ipfs
    content = """#!/bin/sh
{0} add --pin --dereference-args -Q "{1}"
""".format(ipfs.short_path, p)
    script = ctx.actions.declare_file("ipfs-upload-" + str(hash(p)) + ".sh")
    ctx.actions.write(
        script,
        content,
    )
    return DefaultInfo(
        executable = script,
        runfiles = ctx.runfiles(files = [f, ipfs]),
        files = ctx.attr.file.files,
    )

ipfs_pin = rule(
    implementation = _ipfs_pin_impl,
    attrs = {
        "file": attr.label(
            mandatory = True,
            allow_single_file = True,
        ),
        "_ipfs": attr_ipfs(attr),
    },
    executable = True,
)
