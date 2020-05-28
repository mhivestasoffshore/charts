"""Collection of Helm related rules"""

load(
    "//build:copy.bzl",
    "copy",
)

def _helm_package_impl(ctx):
    package = ctx.label.package.split("/")
    chart_name = package[len(package) - 1]
    info = ctx.toolchains["//build/toolchains/helm:toolchain_type"].helminfo
    out_file = ctx.actions.declare_file("%s-%s.tgz" % (chart_name, ctx.attr.version))
    print ("path: %s" % info.tool_path)
    args = ctx.actions.args()
    args.add("package")
    args.add("--version=%s" % ctx.attr.version)
    args.add("--app-version=%s" % ctx.attr.app_version)
    args.add("-d")
    args.add(out_file.dirname)
    args.add(ctx.file.chart_yaml.dirname)
    ctx.actions.run(
        progress_message = "Running Helm package for %s" % ctx.label.package,
        inputs = ctx.files.srcs,
        outputs = [out_file],
        executable = info.tool_path,
        arguments = [args],
    )
    return [DefaultInfo(files = depset([out_file]))]

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
        ),
        "version": attr.string(
            doc = "Chart version",
            mandatory = True,
        ),
        "app_version": attr.string(
            doc = "App version",
            mandatory = True,
        ),
    },
    toolchains = ["//build/toolchains/helm:toolchain_type"],
)

def _helm_index_impl(ctx):
    inputs = []
    out = []
    for f in ctx.files.packages:
        out_file = ctx.actions.declare_file("%s/%s" % (ctx.label.name, f.basename))
        copy(ctx, f, out_file)
        inputs += [f]
        out += [out_file]

    args = ctx.actions.args()
    args.add("repo")
    args.add("index")
    if ctx.file.index:
        args.add("--merge=%s" % ctx.file.index.path)
        inputs += [ctx.file.index]
    if ctx.attr.url:
        args.add("--url=%s" % ctx.attr.url)
    index_file = ctx.actions.declare_file("%s/index.yaml" % ctx.label.name)
    out += [index_file]
    args.add(index_file.dirname)

    info = ctx.toolchains["//build/toolchains/helm:toolchain_type"].helminfo
    ctx.actions.run(
        progress_message = "Running Helm index for %s" % ctx.label.package,
        inputs = inputs,
        outputs = [index_file],
        executable = info.tool_path,
        arguments = [args]
    )
    return [DefaultInfo(files = depset(out))]

helm_index = rule(
    implementation = _helm_index_impl,
    attrs = {
        "packages": attr.label_list(
            allow_files = True,
            doc = "List of packages to be included in index",
            mandatory = True,
        ),
        "url": attr.string(
            doc = "URL of the chart repository",
            mandatory = False,
        ),
        "index": attr.label(
            allow_single_file = True,
            doc = "Generated index file",
            mandatory = False,
        ),
    },
    toolchains = ["//build/toolchains/helm:toolchain_type"],
)
