# MCP Servers Available for the GitHub Coding Agent

This document describes the Model Context Protocol (MCP) servers available for use by the GitHub Coding Agent in this repository, along with their primary use cases and recommendations.

## 1. MS-Learn MCP Server
- **Purpose:** Provides access to the complete Microsoft Learn documentation.
- **Recommended Usage:**
  - Use when you need authoritative, up-to-date documentation or examples from Microsoft Learn.
  - Ideal for researching Microsoft technologies, AL language features, platform APIs, and best practices.
  - Recommended for deep dives, troubleshooting, or when workspace documentation is insufficient.

## 2. nab-al-tools-mcp
- **Purpose:** Used for translation workflows and AL localization support.
- **Recommended Usage:**
  - Use for extracting, managing, and synchronizing XLF files and translations.
  - Preferred for automating translation tasks, reviewing translation states, and ensuring localization consistency.

  ## 3. bc-code-intel MCP Server
  - **Purpose:** Provides comprehensive code intelligence and analysis for Business Central AL development projects.
  - **Recommended Usage:**
    - Use for deep code analysis, architecture reviews, and AL best practices validation
    - Ideal for analyzing app dependencies, object relationships, and code quality assessment
    - Recommended for performance analysis, AppSource compliance checking, and technical debt identification
    - Excellent for generating documentation, code reviews, and understanding complex AL codebases
    - Preferred for workspace-aware analysis that understands your specific AL project structure and dependencies

---

**Note:** Select the appropriate MCP server based on the task at hand. For documentation and learning, prefer MS-Learn. For translation and localization, use nab-al-tools-mcp.
