load("//build:helm.bzl", "helm_package")

helm_package(
    name = "package",
    srcs = [".helmignore", "Chart.yaml", "README.md", "requirements.lock", "requirements.yaml", "values.yaml"] + glob(["templates/**"]),
    chart_yaml = "Chart.yaml",
)
