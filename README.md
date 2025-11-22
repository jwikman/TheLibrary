# DirectionsWebinar2025
Directions Webinar: Benefitting from Open Source 2025-11-25

TODO: Add description etc.

## Setup GitHub Copilot Coding Agent

Add the path to the BaseApp translation files to _Custom allowlist_:
`https://nabaltools.file.core.windows.net/shared/base_app_lang_files`

Configure the MCP Servers for the Copilot Coding Agent by using the following MCP Configuration:

```json
{
    "mcpServers": {
        "MS-Learn": {
            "type": "http",
            "url": "https://learn.microsoft.com/api/mcp",
            "tools": [
                "*"
            ]
        },
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
        },
        "bc-code-intel": {
            "type": "local",
            "command": "npx",
            "args": [
                "-y",
                "bc-code-intelligence-mcp"
            ],
            "tools": [
                "*"
            ]
        }
    }
}
```
