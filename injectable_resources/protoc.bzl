def _protoc_exec_impl(ctx):
    f = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.run_shell(
            inputs = depset(transitive = [ctx.attr.binary_file.files]),
            outputs = [f],
            command = "cp %s %s" % (ctx.attr.binary_file.files.to_list()[0].path, f.path),
    )
    runfiles = ctx.runfiles(files = [f])
    return [DefaultInfo(runfiles = runfiles, executable = f)]

protoc_exec = rule(
    implementation = _protoc_exec_impl,
    attrs = {
        "binary_file": attr.label(
            mandatory=True,
            allow_single_file=True
        ),
    },
    executable = True
)

def get_proto_binaries():
  protoc_exec(name = "protoc",
      binary_file = select(
     {

          "//protoc_binaries:osx_plat": "@com_google_protobuf//protoc_binaries:protoc-macos",
          "//protoc_binaries:linux_plat": "@com_google_protobuf//protoc_binaries:protoc-linux",
          "//conditions:default": ":protoc_cc",
      }),
  visibility=["//visibility:public"])
