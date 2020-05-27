load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = 'helm_windows_dist',
    url = 'https://get.helm.sh/helm-v3.2.1-windows-amd64.zip',
    build_file = '//:helm-windows.BUILD',
    sha256 = "dbd30c03f5ba110348a20ffb5ed8770080757937c157987cce59287507af79dd",
    strip_prefix = "windows-amd64",
)

http_archive(
    name = 'helm_linux_dist',
    url = 'https://get.helm.sh/helm-v3.2.1-linux-amd64.tar.gz',
    build_file = '//:helm-linux.BUILD',
    sha256 = "018f9908cb950701a5d59e757653a790c66d8eda288625dbb185354ca6f41f6b",
    strip_prefix = "linux-amd64",
)

register_toolchains(
    "//build/toolchains/helm:helm_window_toolchain",
    "//build/toolchains/helm:helm_linux_toolchain",
)
