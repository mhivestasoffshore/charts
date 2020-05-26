def _helm_package_impl(ctx):
    info = ctx.toolchains["//build/toolchains/helm:toolchain_type"].helminfo
    out_dir = ctx.actions.declare_directory("%s" % ctx.label.name)
    ctx.actions.run(
        progress_message = "Running Helm package for %s" % ctx.label.name,
        inputs = ctx.files.srcs,
        outputs = [out_dir],
        executable = "%s" % info.tool_path,
        arguments = ["package", "--save=false", "-d", out_dir.path, ctx.file.chart_yaml.dirname],
    )
    return [DefaultInfo(files = depset([out_dir]))]

helm_package = rule(
    implementation = _helm_package_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = True,
            mandatory = True,
            doc = "Chart source files",
        ),
        "chart_yaml": attr.label(
            allow_single_file = True,
            mandatory = True,
            doc = "Chart yaml descriptor",
        )
    },
    toolchains = ["//build/toolchains/helm:toolchain_type"],
)
