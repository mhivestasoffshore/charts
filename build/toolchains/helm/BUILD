load(":helm_toolchain.bzl", "helm_toolchain")

# By convention, toolchain_type targets are named "toolchain_type" and
# distinguished by their package path. So the full path for this would be
# //build/toolschains/helm:toolchain_type.
toolchain_type(
    name = "toolchain_type",
    visibility = ["//visibility:public"],
)

helm_toolchain(
    name = "helm_windows",
    tool_path = "@helm_windows_dist//:helm",
)

helm_toolchain(
    name = "helm_linux",
    tool_path = "@helm_linux_dist//:helm",
)

toolchain(
    name = "helm_window_toolchain",
    exec_compatible_with = [
        "@platforms//os:windows",
        "@platforms//cpu:x86_64",
    ],
    target_compatible_with = [
        "@platforms//os:windows",
        "@platforms//cpu:x86_64",
    ],
    toolchain = ":helm_windows",
    toolchain_type = ":toolchain_type",
)

toolchain(
    name = "helm_linux_toolchain",
    exec_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    target_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    toolchain = ":helm_linux",
    toolchain_type = ":toolchain_type",
)
