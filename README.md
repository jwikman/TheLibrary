# The Library

This repository was created for the Directions Webinar: Benefitting from Open Source 2025-11-25

It contains a sample AL project that demonstrates how to use the GitHub Copilot Coding Agent with NAB AL Tools, either locally or with GitHub Copilot Coding Agent in the Cloud.

## Setup GitHub Copilot Coding Agent

Configure the NAB AL Tools MCP Server for the Copilot Coding Agent by using the following MCP Configuration in your repository settings on GitHub:

```json
{
    "mcpServers": {
        "nab-al-tools-mcp": {
            "type": "local",
            "command": "npx",
            "args": [
                "-y",
                "@nabsolutions/nab-al-tools-mcp"
            ],
            "tools": [
                "*"
            ]
        }
    }
}
```

Add the path to the BaseApp translation files to _Custom allowlist_:
`https://nabaltools.file.core.windows.net/shared/base_app_lang_files`
