"""
This module implements the helm toolchain rule.
"""

HelmInfo = provider(
    doc = "Information on Helm command line tool",
    fields = {
        "tool_path": "Path to the helm executable",
    }
)

def _helm_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        helminfo = HelmInfo(
            tool_path = ctx.file.tool_path.path,
        ),
    )
    environment_info = platform_common.TemplateVariableInfo({
        "HELM_CMD": ctx.file.tool_path.path,
    })
    return [toolchain_info, environment_info]

helm_toolchain = rule(
    implementation = _helm_toolchain_impl,
    attrs = {
        "tool_path": attr.label(
            allow_single_file = True,
        ),
    },
)
