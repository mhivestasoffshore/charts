load("//build:helm.bzl", "helm_package")

VERSION="0.1.1"
APP_VERSION="0.0.60"

helm_package(
    name = "package",
    srcs = ["Chart.yaml", "README.md", "values.yaml"] + glob(["templates/**"]),
    version = VERSION,
    app_version = APP_VERSION,
    chart_yaml = "Chart.yaml",
    visibility = ["//visibility:public"],
)
