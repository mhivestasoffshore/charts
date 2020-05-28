"""Collection of Helm related rules"""

load(
    "//build:copy.bzl",
    "copy",
)

def helm_repos(ctx, srcs, repos):
    info = ctx.toolchains["//build/toolchains/helm:toolchain_type"].helminfo
    repo_config = ctx.actions.declare_file("repositories-%s.yaml" % ctx.label.name)
    if ctx.attr.is_windows:
        bat = ctx.actions.declare_file("helm-add-repo-%s.bat" % ctx.label.name)
        content = ""
        for name,url in repos.items():
            content += "@%s repo add --repository-config=%s %s %s\r\n" % (
                info.tool_path.path.replace("/", "\\"),
                repo_config.path.replace("/", "\\"),
                name,
                url,
            )
        ctx.actions.write(
            content = content,
            is_executable = True,
            output = bat,
        )
        ctx.actions.run(
            progress_message = "Adding Helm repositories for %s" % ctx.label.package,
            inputs = srcs,
            outputs = [repo_config],
            tools = [bat],
            executable = "cmd.exe",
            arguments = ["/C", bat.path.replace("/", "\\")],
            use_default_shell_env = True,
        )
    else:
        command = ""
        for name,url in repos.items():
            command += "./%s repo add --repository-config=%s %s %s\n" % (
                info.tool_path.path,
                repo_config.path,
                name,
                url,
            )
        ctx.actions.run_shell(
            progress_message = "Adding Helm repositories for %s" % ctx.label.package,
            inputs = srcs,
            outputs = [repo_config],
            command = command,
            use_default_shell_env = True,
        )

    return repo_config

def _helm_package_impl(ctx):
    package = ctx.label.package.split("/")
    chart_name = package[len(package) - 1]
    info = ctx.toolchains["//build/toolchains/helm:toolchain_type"].helminfo

    deps = []
    if ctx.attr.repos:
        repo_config = helm_repos(ctx, ctx.files.srcs, ctx.attr.repos)
        dep_out = ctx.actions.declare_directory("deps-%s.out" % ctx.label.name)
        ctx.actions.run(
            progress_message = "Resolving dependencies for %s" % ctx.label.package,
            inputs = ctx.files.srcs + [repo_config],
            outputs = [dep_out],
            executable = info.tool_path,
            arguments = ["dependency", "build", ctx.file.chart_yaml.dirname, "--repository-config=%s" % repo_config.path],
        )
        deps += [dep_out]

    out_file = ctx.actions.declare_file("%s-%s.tgz" % (chart_name, ctx.attr.version))
    args = ctx.actions.args()
    args.add("package")
    args.add("--version=%s" % ctx.attr.version)
    args.add("--app-version=%s" % ctx.attr.app_version)
    args.add("-d")
    args.add(out_file.dirname)
    args.add(ctx.file.chart_yaml.dirname)
    ctx.actions.run(
        progress_message = "Running Helm package for %s" % ctx.label.package,
        inputs = ctx.files.srcs + deps,
        outputs = [out_file],
        executable = info.tool_path,
        arguments = [args],
    )
    return [DefaultInfo(files = depset([out_file]))]

_helm_package = rule(
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
        "repos": attr.string_dict(
            allow_empty = True,
            doc = "Chart repositories for dependencies",
            mandatory = False,
        ),
        "is_windows": attr.bool(mandatory = True),
    },
    toolchains = ["//build/toolchains/helm:toolchain_type"],
)

def helm_package(srcs, chart_yaml, version, app_version, repos = {}, **kwargs):
    _helm_package(
        srcs = srcs,
        chart_yaml = chart_yaml,
        version = version,
        app_version = app_version,
        repos = repos,
        is_windows = select({
                "@bazel_tools//src/conditions:host_windows": True,
                "//conditions:default": False,
            }),
        **kwargs,
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
