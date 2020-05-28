"""
This module implements the helm toolchain rule.
"""

HelmInfo = provider(
    doc = "Information on Helm command line tool",
    fields = {
        "tool": "Target pointing to Helm executable",
        "cmd": "File pointing to Helm executable"
    }
)

def _helm_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        helminfo = HelmInfo(
            tool = ctx.attr.tool_path,
            cmd = ctx.executable.tool_path,
        ),
    )
    return [toolchain_info]

helm_toolchain = rule(
    implementation = _helm_toolchain_impl,
    attrs = {
        "tool_path": attr.label(
            allow_single_file = True,
            cfg = "host",
            executable = True,            
        ),
    },
)
