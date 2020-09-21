load("//build:helm.bzl", "helm_package")

VERSION="0.3.1"
APP_VERSION="3.27.0"

helm_package(
    name = "package",
    srcs = [".helmignore", "Chart.yaml", "README.md", "values.yaml"] + glob(["templates/**"]),
    version = VERSION,
    app_version = APP_VERSION,
    chart_yaml = "Chart.yaml",
    visibility = ["//visibility:public"],
)
