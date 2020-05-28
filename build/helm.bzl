"""Collection of Helm related rules"""

load(
    "//build:copy.bzl",
    "copy",
)

load(
    "@rules_pkg//:path.bzl",
    "dest_path",
)

def helm_repos(ctx, srcs, repos):
    """Add the given Helm repositories returning the resulting configuration file"""
    info = ctx.toolchains["//build/toolchains/helm:toolchain_type"].helminfo
    repo_config = ctx.actions.declare_file("repositories-%s.yaml" % ctx.label.name)
    if repos:
        if ctx.attr.is_windows:
            content = [
                "@%s repo add --repository-config=%s %s %s" % (
                    info.cmd.path.replace("/", "\\"),
                    repo_config.path.replace("/", "\\"),
                    name,
                    url,
                )
                for name, url in repos.items()
            ]
            bat = ctx.actions.declare_file("helm-add-repo-%s.bat" % ctx.label.name)
            ctx.actions.write(
                content = "\r\n".join(content),
                is_executable = True,
                output = bat,
            )
            ctx.actions.run(
                progress_message = "Adding Helm repositories for %s" % ctx.label.package,
                inputs = srcs,
                outputs = [repo_config],
                tools = [bat,info.cmd],
                executable = "cmd.exe",
                arguments = ["/C", bat.path.replace("/", "\\")],
                use_default_shell_env = True,
            )
        else:
            command = ""
            for name,url in repos.items():
                command += "$(location %s) repo add --repository-config=%s %s %s\n" % (
                    info.tool.label,
                    repo_config.path,
                    name,
                    url,
                )
            command = ctx.expand_location(command, [info.tool])
            ctx.actions.run_shell(
                progress_message = "Adding Helm repositories for %s" % ctx.label.package,
                inputs = srcs,
                outputs = [repo_config],
                command = command,
                tools = [info.cmd],
                use_default_shell_env = True,
            )
    else:
        ctx.actions.write(
            content = "",
            output = repo_config,
        )

    return repo_config

def _dirname(path):
    last_pkg = path.rfind("/")
    if last_pkg == -1:
        return ""
    return path[:last_pkg]

def helm_dependencies(ctx, chart_yaml, srcs, repos):
    """Resolve dependencies for a specific Helm chart returning directory with resolved chart"""
    info = ctx.toolchains["//build/toolchains/helm:toolchain_type"].helminfo    
    repo_config = helm_repos(ctx, srcs, repos)
    resolved_chart = ctx.actions.declare_directory("resolved-%s" % ctx.label.name)
    if ctx.attr.is_windows:
        content = []
        for src in srcs:
            dst = "%s%s" % (resolved_chart.path, dest_path(src, chart_yaml.dirname))
            dst_dir = _dirname(dst).replace("/", "\\")
            content += [
                "@if not exist \"%s\" mkdir %s >NUL" % (dst_dir, dst_dir),
                "@copy /Y %s %s >NUL" % (src.path.replace("/", "\\"), dst.replace("/", "\\")),
            ]
        content += ["@%s dependency build %s --repository-config=%s" % (info.cmd.path.replace("/", "\\"), resolved_chart.path, repo_config.path)]
        bat = ctx.actions.declare_file("helm-build-deps-%s.bat" % ctx.label.name)
        ctx.actions.write(
            content = "\r\n".join(content),
            is_executable = True,
            output = bat,
        )
        ctx.actions.run(
            progress_message = "Resolving dependencies for %s" % ctx.label.package,
            inputs = srcs + [repo_config],
            outputs = [resolved_chart],
            tools = [bat,info.cmd],
            executable = "cmd.exe",
            arguments = ["/C", bat.path.replace("/", "\\")],
            use_default_shell_env = True,
        )
    else:
        command = []
        for src in srcs:
            dst = "%s%s" % (resolved_chart.path, dest_path(src, chart_yaml.dirname))
            command += [
                "mkdir -p \"%s\"" % _dirname(dst),
                "cp -f \"%s\" \"%s\"\n" % (src.path, dst)
            ]
        command += ["$(location %s) dependency build %s --repository-config=%s" % (info.tool.label, resolved_chart.path, repo_config.path)]
        cmd = ctx.expand_location("\n".join(command), [info.tool])
        ctx.actions.run_shell(
            progress_message = "Resolving dependencies for %s" % ctx.label.package,
            inputs = srcs + [repo_config],
            outputs = [resolved_chart],
            command = cmd,
            tools = [info.cmd],
            use_default_shell_env = True,
        )

    return resolved_chart

def _helm_package_impl(ctx):
    package = ctx.label.package.split("/")
    chart_name = package[len(package) - 1]
    info = ctx.toolchains["//build/toolchains/helm:toolchain_type"].helminfo

    resolved_chart = helm_dependencies(ctx, ctx.file.chart_yaml, ctx.files.srcs, ctx.attr.repos)

    out_file = ctx.actions.declare_file("%s-%s.tgz" % (chart_name, ctx.attr.version))
    args = ctx.actions.args()
    args.add("package")
    args.add("--version=%s" % ctx.attr.version)
    args.add("--app-version=%s" % ctx.attr.app_version)
    args.add("-d")
    args.add(out_file.dirname)
    args.add(resolved_chart.path)
    ctx.actions.run(
        progress_message = "Running Helm package for %s" % ctx.label.package,
        inputs = [resolved_chart],
        outputs = [out_file],
        executable = info.cmd,
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
        executable = info.cmd,
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
