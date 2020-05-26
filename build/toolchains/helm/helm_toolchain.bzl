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
            tool_path = ctx.attr.tool_path,
        ),
    )
    environment_info = platform_common.TemplateVariableInfo({
        "HELM_CMD": ctx.attr.tool_path,
    })
    return [toolchain_info, environment_info]

helm_toolchain = rule(
    implementation = _helm_toolchain_impl,
    attrs = {
        "tool_path": attr.string(),
    },
)
