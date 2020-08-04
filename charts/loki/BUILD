load("//build:helm.bzl", "helm_package")

VERSION="0.1.3"
APP_VERSION="1.5.0"

helm_package(
    name = "package",
    srcs = [".helmignore", "Chart.yaml", "README.md", "requirements.lock", "requirements.yaml", "values.yaml"] + glob(["templates/**"]),
    chart_yaml = "Chart.yaml",
    version = VERSION,
    app_version = APP_VERSION,
    repos = {
        "stable": "https://kubernetes-charts.storage.googleapis.com/",
        "hashicorp": "https://helm.releases.hashicorp.com",
    },
    visibility = ["//visibility:public"],
)
