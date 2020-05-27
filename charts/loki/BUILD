load("//build:helm.bzl", "helm_package")

VERSION="0.0.2"
APP_VERSION="1.4.1"

helm_package(
    name = "package",
    srcs = [".helmignore", "Chart.yaml", "README.md", "requirements.lock", "requirements.yaml", "values.yaml"] + glob(["templates/**"]),
    chart_yaml = "Chart.yaml",
    version = VERSION,
    app_version = APP_VERSION,
    visibility = ["//visibility:public"],
)
