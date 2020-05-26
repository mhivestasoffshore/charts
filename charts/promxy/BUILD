load("//build:helm.bzl", "helm_package")

helm_package(
    name = "package",
    srcs = ["Chart.yaml", "README.md", "values.yaml"] + glob(["templates/**"]),
    chart_yaml = "Chart.yaml",
)
