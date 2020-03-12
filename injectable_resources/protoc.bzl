def _protoc_exec_impl(ctx):
    ctx.actions.run_shell(
            inputs = depset(transitive = [ctx.attr.binary_file.files]),
            outputs = [ctx.outputs.exe],
            command = "cp %s %s" % (ctx.attr.binary_file.files.to_list()[0].path, ctx.outputs.exe.path),
    )
    runfiles = ctx.runfiles(files = [ctx.outputs.exe])
    return [DefaultInfo(runfiles = runfiles, executable = ctx.outputs.exe)]

protoc_exec = rule(
    implementation = _protoc_exec_impl,
    attrs = {
        "binary_file": attr.label(
            mandatory=True,
            allow_single_file=True
        ),
    },
    executable = True,
    outputs = {"exe": "protoc"}
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
