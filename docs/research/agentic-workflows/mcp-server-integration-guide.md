# MCP Server Integration Guide

## Overview

Model Context Protocol (MCP) servers extend agent capabilities with external tools and services beyond the core VS Code agent platform. This guide covers configuring, integrating, and creating MCP servers for agent workflows.

**Core Concept**: MCP servers provide additional tools that agents can automatically use without modification to agent definitions.

---

## What Are MCP Servers?

### Definition

An MCP server is a service that provides tools and context via the Model Context Protocol. Agents automatically gain access to MCP tools without specific configuration in `.agent.md` files.

### Common Use Cases

- **GitHub API access**: Pull requests, issues, repository management
- **Web search and research**: Finding external information
- **Database queries**: Accessing structured data
- **Slack/Teams integration**: Team communication
- **Jira integration**: Issue/project management
- **Monitoring systems**: Alert checking, log access
- **Custom domain tools**: Organization-specific integrations

---

## Configuration Locations

### VS Code Agents

**Location 1: User-level MCP configuration**
```
~/.copilot/mcp.json
```

**Location 2: Project-level MCP configuration**
```
.copilot/mcp.json
```

**Precedence**: Project-level overrides user-level

### GitHub Copilot CLI

**Location**:
```
~/.copilot/mcp.json  (user-level, shared)
.copilot/mcp.json    (project-level, takes precedence)
```

---

## MCP Configuration Format

### Basic Structure

```json
{
  "mcpServers": {
    "github": {
      "command": "node",
      "args": ["path/to/github-mcp-server.js"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "web-search": {
      "command": "python",
      "args": ["-m", "web_search_mcp"],
      "env": {
        "TAVILY_API_KEY": "${TAVILY_API_KEY}"
      }
    }
  }
}
```

### Common MCP Servers

#### GitHub MCP Server

```json
{
  "github": {
    "command": "npm",
    "args": ["exec", "@modelcontextprotocol/server-github"],
    "env": {
      "GITHUB_TOKEN": "${GITHUB_TOKEN}",
      "GITHUB_REPO": "owner/repo"
    }
  }
}
```

**Provides Tools**:
- Create/manage pull requests
- Query repository issues
- Access repository information
- Manage releases

**Authentication**: GitHub personal access token

#### Web Search MCP Server

```json
{
  "web-search": {
    "command": "npm",
    "args": ["exec", "@modelcontextprotocol/server-web-search"],
    "env": {
      "TAVILY_API_KEY": "${TAVILY_API_KEY}"
    }
  }
}
```

**Provides Tools**:
- Search the web
- Get search results with sources
- Extract content from URLs

**Authentication**: Tavily API key

#### Database MCP Server

```json
{
  "postgres": {
    "command": "node",
    "args": ["path/to/postgres-mcp-server.js"],
    "env": {
      "DATABASE_URL": "${DATABASE_URL}",
      "DATABASE_NAME": "production"
    }
  }
}
```

**Provides Tools**:
- Execute read–only queries
- Get schema information
- Analyze table structure

**Security**: Usually read-only; credentials via environment variables

---

## Environment Variable Configuration

### Best Practices

**Pattern**: Use environment variable references

```json
"env": {
  "API_KEY": "${API_KEY_NAME}",
  "SECRET": "${SECRET_TOKEN}"
}
```

**Why this works**:
- Credentials not stored in git
- Easy to manage per-environment
- Supports CI/CD secret injection

### Setting Environment Variables

**Local Development**:
```bash
export GITHUB_TOKEN="ghp_xxxxxxxxxxxx"
export TAVILY_API_KEY="tvly_xxxxxxxxxxxx"
```

**CI/CD Systems** (GitHub Actions example):
```yaml
env:
  GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  TAVILY_API_KEY: ${{ secrets.TAVILY_API_KEY }}
```

**Never**:
- Store credentials in `.json` files
- Commit credentials to git
- Include credentials in instructions

---

## Using MCP Server Tools in Agents

### Automatic Tool Availability

Once MCP server is configured, agents automatically have access to its tools:

```yaml
name: Research Agent
description: Investigates topics using web search
tools:
  # These tools come from web-search MCP server
  # No explicit configuration needed here
  # Agents automatically get access

instructions: |
  You are a research agent.

  You can use web search tools to:
  - Search for information on topics
  - Get results with sources
  - Extract content from URLs

  When researching: search → analyze → synthesize findings
```

**Key Point**: No need to list MCP tools in agent definition; they're automatically available

### Tool Usage Patterns

**Example 1: Research Agent using Web Search**

```
Agent task: "Research agentic workflow best practices"

Execution:
1. web_search("agentic workflows best practices")
2. Analyze search results
3. web_search("VS Code custom agents")
4. Analyze results
5. web_search("multi-agent orchestration patterns")
6. Synthesize all findings into structured document
```

**Example 2: DevOps Agent using GitHub MCP**

```
Agent task: "Create pull request with findings"

Execution:
1. github_create_branch("feature/agentic-workflows-docs")
2. Create documentation files
3. github_create_pull_request(
     title: "Add agentic workflows documentation",
     description: "Based on comprehensive research...",
     branch: "feature/agentic-workflows-docs"
   )
```

---

## Custom MCP Server Development

### When to Build Custom MCP Servers

**Build custom MCP server when**:
- Organization has domain-specific tools needed by agents
- Standard MCP servers don't cover your use cases
- Need integration with internal systems (Jira, Slack, proprietary APIs)

**Don't build if**:
- Existing MCP server covers use case
- Use case is simple (agents can call APIs directly for simple tasks)

### Basic MCP Server Structure

```javascript
// mcp-server-example.js
const { Server } = require("@modelcontextprotocol/sdk");

const server = new Server("example-server");

// Define a tool
server.defineTool({
  name: "query_database",
  description: "Run read-only database queries",
  inputSchema: {
    type: "object",
    properties: {
      query: { type: "string" }
    },
    required: ["query"]
  },
  execute: async (input) => {
    // Implementation here
    const results = await database.query(input.query);
    return results;
  }
});

// Define another tool
server.defineTool({
  name: "get_table_schema",
  description: "Get schema for specified table",
  inputSchema: {
    type: "object",
    properties: {
      table_name: { type: "string" }
    },
    required: ["table_name"]
  },
  execute: async (input) => {
    // Implementation
  }
});

server.start();
```

### Custom MCP Best Practices

- ✓ **Define clear tools**: Each tool has specific, defined function
- ✓ **Input validation**: Validate tool inputs before execution
- ✓ **Error handling**: Return clear errors when tools fail
- ✓ **Authentication**: Enforce authentication at server level
- ✓ **Rate limiting**: Prevent abuse
- ✗ Don't allow arbitrary command execution
- ✗ Don't bypass authentication
- ✗ Don't log sensitive information

---

## Troubleshooting MCP Integration

### Issue 1: MCP Server Not Found

**Symptom**: Agent can't access MCP tools; tools not discovered

**Diagnosis**:
1. Check MCP configuration file exists
   ```bash
   cat ~/.copilot/mcp.json  # or .copilot/mcp.json
   ```

2. Verify configuration format
   ```bash
   python -m json.tool ~/.copilot/mcp.json  # validate JSON
   ```

3. Check server process starts
   ```bash
   # Try running server command manually
   node path/to/server.js
   ```

**Solution**:
- Fix path or format in configuration
- Ensure dependencies installed
- Verify command works standalone first

### Issue 2: Authentication Failures

**Symptom**: MCP server configured but authentication fails

**Diagnosis**:
1. Check environment variables set
   ```bash
   echo $GITHUB_TOKEN  # verify token is set
   ```

2. Verify token permissions
   - GitHub tokens: Check scopes (repo, issues, PRs, etc.)
   - API keys: Verify key is valid and not expired

3. Check server logs
   ```bash
   # Run server with debug output
   DEBUG=* node path/to/server.js
   ```

**Solution**:
- Set environment variables correctly
- Regenerate tokens if expired
- Update configuration with correct environment variable names

### Issue 3: Tool Execution Slow

**Symptom**: MCP tools work but are very slow

**Diagnosis**:
- Is server responding? (try simple tool first)
- Is network latency issue?
- Is database query slow?

**Solution**:
- Consider tool complexity; batch operations when possible
- Add caching if appropriate
- Optimize database queries

---

## Integration with Agent Workflows

### Research Agent with Web Search

```yaml
name: Research Agent
description: Researches topics using web search

instructions: |
  You are a research specialist.

  When researching topics:
  1. Use web_search to find sources
  2. Extract key findings from search results
  3. Search for deeper topics as needed
  4. Synthesize findings into structured document

  Tools available:
  - web_search(query): Search web for information
  - extract_content(url): Get full content from URL

Success:
  - Findings cite sources
  - Multiple sources referenced
  - Structured and clear
```

### DevOps Agent with GitHub Integration

```yaml
name: Git Operations Agent
description: Manages git workflow and pull requests

instructions: |
  You are a git operations specialist.

  When managing git workflow:
  1. Create feature branch with descriptive name
  2. Report branch created
  3. When ready, create pull request with:
     - Clear title describing change
     - Detailed description of what changed and why
     - References to related issues/requirements
  4. Monitor PR creation confirmation

  Tools available:
  - github_create_branch(name, from)
  - github_create_pull_request(title, description, branch)
  - github_list_pull_requests(filters)

Naming conventions:
  - Branches: feature/what-it-does or fix/issue-number
  - PR titles: Conventional commit format
```

---

## References

- **Related**: [Tool Composition and Design](<./tool-composition-patterns.md>) — how agents combine tools
- **Related**: [Tool Restrictions and Safety](<./tool-restrictions-and-safety.md>) — security considerations
- **Related**: [Agent Definition and Fundamentals](<./agent-definition-and-fundamentals.md>) — agent structure
