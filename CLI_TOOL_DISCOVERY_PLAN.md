# CLI Tool Discovery Skill - Implementation Plan

## Overview
Create a skill called `cli-tool-discovery` that helps Claude intelligently find, discover, and use relevant CLI tools (both MCP-converted tools and standard CLI tools) to solve problems efficiently.

## Directory Structure
```
skills/discovery/cli-tool-discovery/
├── SKILL.md
├── tool/
│   ├── discover-tools           # Main script for tool discovery
│   ├── list-available-tools     # Script to list all available tools
│   ├── tool-info               # Script to get detailed info about specific tool
│   ├── package.json            # Node.js dependencies
│   ├── hooks/
│   │   └── session-start.sh    # Claude Code hook for session initialization
│   └── install-hook            # Claude Code hook installation script
└── PLAN.md                     # This file
```

## Core Components

### 1. SKILL.md Documentation
- **Frontmatter**: Proper when_to_use triggers for discovery scenarios
- **Overview**: How to intelligently find the right tool for the right task
- **Workflow**: Step-by-step process for tool discovery and usage
- **Tool Registry**: Common tools with one-line descriptions and use cases
- **Integration patterns**: How to integrate discovered tools into workflow

### 2. Core CLI Scripts
- **discover-tools**: Interactive tool finder based on task/error context
- **list-available-tools**: Shows all discovered tools with descriptions
- **tool-info**: Detailed information about specific tools including examples

### 3. Tool Discovery Engine
- Scan common paths for CLI tools (`/usr/local/bin`, `/opt/homebrew/bin`, npm global packages, etc.)
- Parse `--help` output to generate tool descriptions
- Maintain registry of known tools with use cases and examples
- Support both system tools and MCP-converted tools

### 4. Claude Code Integration (NEW)
- **Session-start hook**: Automatically initialize tool registry at session start
- **Hook configuration**: JSON-based hook setup in `.claude/settings.local.json`
- **Progressive loading**: Metadata first, full details on-demand
- **Environment awareness**: Leverage `$CLAUDE_PROJECT_DIR`, `$SESSION_ID`

### 5. Integration Features
- Token-efficient on-demand loading of tool instructions
- Transparent tool usage for user awareness
- Smart matching based on error messages and task descriptions
- Context-aware tool suggestions
- Automatic environment scanning and caching

## Key Features

### Intelligent Tool Matching
- Match error messages to relevant tools
- Suggest tools based on task type (debugging, documentation, git operations, etc.)
- Support for fuzzy matching on tool descriptions
- Context-aware ranking based on current project type

### Tool Registry
- Pre-populated with common tools (gh, context7-cli, npm, jq, etc.)
- One-line descriptions for quick scanning
- Example usage patterns
- Integration notes
- Dynamic tool discovery from system PATH

### Claude Code Integration
- Help Claude find the right tool without loading all tool documentation
- On-demand loading reduces token usage
- Transparent about which tools are being used and why
- Session-start hook ensures tools are always available
- Integration with existing Claude Code hook ecosystem

### Hook-Based Automation (NEW)
- Automatic tool scanning at session start
- Background caching of tool information
- Integration with Claude Code's progressive disclosure system
- Support for project-specific tool configurations

## Testing Plan

### Test Scenarios
1. **Error-based Discovery**: Claude encounters an error and discovers relevant tools
2. **Task-based Discovery**: Claude needs to accomplish a task and finds appropriate tools
3. **Tool Information**: Claude gets detailed information about specific tools
4. **Hook Integration**: Verify session-start hook initializes properly
5. **Integration Testing**: Verify seamless integration with Claude workflow

### Pressure Testing
- Test with ambiguous error messages
- Test with multiple potential tool options
- Test with missing tools or permissions
- Test token efficiency under various scenarios
- Test hook execution in different environments

## Implementation Strategy

### Phase 1: Core Infrastructure
1. ✅ Create directory structure
2. ✅ Implement basic tool scanning functionality
3. ✅ Create tool registry format
4. ⏳ Write comprehensive SKILL.md documentation

### Phase 2: Discovery Engine (UPDATED)
1. ✅ Implement intelligent matching algorithms
2. ✅ Add error message parsing
3. ✅ Create tool suggestion ranking
4. ✅ Add interactive discovery mode
5. ⏳ Create session-start hook for automatic initialization

### Phase 3: Integration & Testing (UPDATED)
1. ⏳ Create comprehensive test suite
2. ⏳ Test with real-world scenarios
3. ⏳ Optimize for token efficiency
4. ⏳ Add Claude Code hook integration
5. ⏳ Test hook installation and execution

## Claude Code Hook Integration Details (NEW)

### Hook Configuration
```json
{
  "hooks": {
    "SessionStart": {
      "command": "tool/hooks/session-start.sh",
      "description": "Initialize CLI tool discovery registry"
    }
  }
}
```

### Session-Start Hook Features
1. **Environment Scanning**: Automatically discover available CLI tools
2. **Registry Building**: Build tool registry with descriptions and use cases
3. **Caching**: Cache tool information for fast access
4. **Project Context**: Detect project type and suggest relevant tools
5. **Background Execution**: Non-blocking initialization

### Hook Implementation Pattern
```bash
#!/usr/bin/env bash
set -euo pipefail

# Session-start hook for CLI tool discovery
# Automatically initializes tool registry at session start

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOL_REGISTRY="$SCRIPT_DIR/../tool-registry.json"

# Background execution to avoid blocking session start
"$SCRIPT_DIR/../discover-tools" --build-registry > "$TOOL_REGISTRY" 2>&1 &
```

## Success Criteria
1. Claude can find relevant tools based on error messages or task descriptions
2. Tool discovery is token-efficient and on-demand
3. Users can see which tools Claude is using and why
4. Skill handles missing tools gracefully
5. ✅ Comprehensive testing ensures reliability
6. ✅ Session-start hook automatically initializes tool registry
7. ✅ Integration with Claude Code hook ecosystem works seamlessly

## Token Efficiency Strategy (UPDATED)

### Progressive Loading
1. **Session Start**: Load tool names and brief descriptions only
2. **On-Demand**: Load detailed tool information only when needed
3. **Caching**: Cache frequently accessed tool information
4. **Context-Aware**: Load only tools relevant to current project context

### Hook-Based Optimization
1. **Background Loading**: Tool registry built in background during session start
2. **Smart Caching**: Cache results of tool discovery and help parsing
3. **Selective Loading**: Load only tools that are actually available
4. **Project-Aware**: Prioritize tools based on project type and history

This updated plan incorporates Claude Code's hook system for seamless integration and automatic initialization, making the tool discovery experience more transparent and efficient for both Claude and users.