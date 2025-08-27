# Serena MCP Configuration for VS Code

This guide shows you how to configure Serena MCP (Model Context Protocol) to work with VS Code using various MCP-compatible extensions.

## Prerequisites

✅ **Already completed:**
- UV package manager installed
- Serena project configuration created (`.serena/project.yml`)
- Global Serena configuration exists (`~/.serena/serena_config.yml`)
- Project added to Serena's project list

## VS Code Extension Options

### Option 1: Cline Extension (Recommended)

**Cline** (formerly Claude Dev) is the most popular and well-maintained MCP extension for VS Code.

#### Installation:
1. Open VS Code
2. Go to Extensions (Ctrl+Shift+X / Cmd+Shift+X)
3. Search for "Cline" and install it
4. The configuration is already set in `.vscode/settings.json`

#### Configuration:
The project already has the correct configuration in `.vscode/settings.json`:

```json
{
    "cline.mcpServers": {
        "serena": {
            "command": "/Users/huu/.local/bin/uvx",
            "args": [
                "--from",
                "git+https://github.com/oraios/serena",
                "serena",
                "start-mcp-server",
                "--context",
                "ide-assistant",
                "--project",
                "/Users/huu/Documents/MY_VIBE/BI_DA"
            ]
        }
    }
}
```

### Option 2: Roo-Code Extension

**Roo-Code** is another good MCP-compatible extension.

#### Installation:
1. Install the Roo-Code extension from VS Code marketplace
2. Use the configuration from `.vscode/roo-code-config.json`

### Option 3: Continue Extension

**Continue** also supports MCP servers and can be configured similarly.

## How to Use

### After Installation:

1. **Restart VS Code** after installing the extension
2. **Open the extension panel** (usually appears in the sidebar)
3. **The extension should automatically detect** the Serena MCP server
4. **Start coding!** You can now ask the AI assistant to help with your Java Spring Boot + Flutter project

### Available Serena Tools in IDE Context:

When using the `ide-assistant` context, Serena provides these tools:
- `find_symbol` - Find symbols in your codebase
- `get_symbols_overview` - Get overview of symbols in files
- `find_referencing_symbols` - Find references to symbols
- `replace_symbol_body` - Replace entire symbol definitions
- `insert_after_symbol` / `insert_before_symbol` - Insert code around symbols
- `list_dir` / `find_file` - File system operations
- `search_for_pattern` - Search for patterns in code
- Memory management tools for project context

## Testing the Setup

You can test if Serena is working by asking the AI assistant questions like:
- "Show me the structure of this project"
- "Find all the Spring Boot controllers"
- "What Flutter apps are in this project?"
- "Help me understand the project architecture"

## Troubleshooting

### If the extension doesn't detect Serena:
1. Check that UV is installed: `which uvx`
2. Verify the path in settings.json matches your UV installation
3. Restart VS Code completely
4. Check the extension's output/logs for errors

### If you get permission errors:
1. Make sure UV is executable: `chmod +x /Users/huu/.local/bin/uvx`
2. Check that the project path is correct and accessible

### Web Dashboard:
Serena also provides a web dashboard at `http://127.0.0.1:24282/dashboard/index.html` when running, which shows logs and tool usage.

## Project Context

Your project is configured as:
- **Language**: Java (primary, for Spring Boot backend)
- **Project Name**: BI_DA
- **Project Path**: `/Users/huu/Documents/MY_VIBE/BI_DA`
- **Context**: `ide-assistant` (optimized for IDE integration)

The project includes:
- Java Spring Boot backend
- Flutter apps (admin_web, staff_app, user_app)
- Shared packages (api_client, core_domain, core_data, core_ui)

## Next Steps

1. Install your preferred MCP extension (Cline recommended)
2. Restart VS Code
3. Start using the AI assistant with Serena's powerful semantic code analysis tools!

The AI assistant will now have deep understanding of your codebase structure and can help with both the Java backend and Flutter frontend development.
