---
version: 1.1
version_description: updated Questions and Answers. Added reference to local llmstxt documentation
---

## Complete end-to-end solution to integrate Skills management with your Claude Code instance:

Read and understand API usage in `/Users/maksim/repos/llmstxt/claude-code/claude.skills-api.md`

## Step 1: Create the Skills Manager Skill

Based on the documentation, here's a complete end-to-end TypeScript solution to integrate Skills management with your Claude Code instance:

## Step 1: Create the Skills Manager Skill

Create a directory structure for your Skills Manager Skill [(1)](https://docs.claude.com/en/docs/claude-code/skills#troubleshooting):

```
~/.claude/skills/skills-manager/
├── SKILL.md
└── scripts/
    ├── list_skills.ts
    └── manage_skills.ts
```

## Step 2: Create the SKILL.md File

````markdown
---
name: skills-manager
description: Manage and list available Claude Skills, including creating, updating, and organizing Skills across the workspace. Use when you need to see what Skills are available or manage your Skills collection.
version: 1.0.0
dependencies: typescript>=5.0.0, @anthropic-ai/sdk>=0.25.0
---

# Skills Manager

## Overview

This Skill provides comprehensive management capabilities for Claude Skills, including listing, creating, updating, and organizing Skills.

## Capabilities

- List all available Skills (both Anthropic and custom)
- Display Skills in numbered format
- Show Skill metadata and versions
- Manage Skill lifecycle

## Usage

Use this Skill when you need to:

- See what Skills are available
- Manage your Skills collection
- Get information about specific Skills

## Scripts

- `scripts/list_skills.ts`: Lists all available Skills via API
- `scripts/manage_skills.ts`: Provides Skills management operations

## Instructions

To list Skills, run:

```bash
ts-node scripts/list_skills.ts
```
````

To manage Skills, run:

```bash
ts-node scripts/manage_skills.ts [command]
```

## Step 3: Create the API Helper Skill

```shell

~/.claude/skills/api-helper/
├── SKILL.md
└── scripts/
└── api_client.ts

```

Create the API Helper SKILL.md [(1)](https://docs.claude.com/en/docs/claude-code/skills#troubleshooting):

````markdown
---
name: api-helper
description: Provides API integration capabilities for making authenticated requests to Claude API endpoints. Use when other Skills need to make API calls to Claude services.
version: 1.0.0
dependencies: typescript>=5.0.0, @anthropic-ai/sdk>=0.25.0
---

# API Helper

## Overview

Handles API authentication and requests to Claude services.

## Capabilities

- Authenticated API calls
- Error handling and retry logic
- Response formatting

## Usage

Use when other Skills need to make API calls to Claude services.

## Instructions

Import and use the API client:

```typescript
import { createClient } from "./scripts/api_client";
const client = createClient();
```
````

## Step 4: Create the TypeScript Scripts

Create `~/.claude/skills/skills-manager/scripts/list_skills.ts`:

```typescript
import Anthropic from "@anthropic-ai/sdk";

async function listSkills() {
  const client = new Anthropic({
    apiKey: process.env.ANTHROPIC_API_KEY,
  });

  try {
    // List all Skills
    const skills = await client.beta.skills.list({
      betas: ["skills-2025-10-02"],
    });

    console.log("Available Skills:");
    skills.data.forEach((skill, index) => {
      console.log(
        `${index + 1}. ${skill.id}: ${skill.display_title} (source: ${
          skill.source
        })`
      );
    });

    // List only custom Skills
    const customSkills = await client.beta.skills.list({
      source: "custom",
      betas: ["skills-2025-10-02"],
    });

    console.log(`\nCustom Skills (${customSkills.data.length}):`);
    customSkills.data.forEach((skill, index) => {
      console.log(`${index + 1}. ${skill.id}: ${skill.display_title}`);
    });
  } catch (error) {
    console.error("Error listing skills:", error);
  }
}

listSkills();
```

[(2)](https://docs.claude.com/en/api/skills-guide#using-skills-in-messages)

Create `~/.claude/skills/skills-manager/scripts/manage_skills.ts`:

```typescript
import Anthropic from "@anthropic-ai/sdk";

interface SkillInfo {
  id: string;
  displayTitle: string;
  source: string;
  latestVersion?: string;
}

async function getSkillDetails(skillId: string): Promise<void> {
  const client = new Anthropic({
    apiKey: process.env.ANTHROPIC_API_KEY,
  });

  try {
    const skill = await client.beta.skills.retrieve({
      skill_id: skillId,
      betas: ["skills-2025-10-02"],
    });

    console.log(`Skill: ${skill.display_title}`);
    console.log(`Latest version: ${skill.latest_version}`);
    console.log(`Created: ${skill.created_at}`);
  } catch (error) {
    console.error("Error retrieving skill:", error);
  }
}

async function listAllSkills(): Promise<SkillInfo[]> {
  const client = new Anthropic({
    apiKey: process.env.ANTHROPIC_API_KEY,
  });

  const skills = await client.beta.skills.list({
    betas: ["skills-2025-10-02"],
  });

  return skills.data.map((skill) => ({
    id: skill.id,
    displayTitle: skill.display_title,
    source: skill.source,
    latestVersion: skill.latest_version,
  }));
}

const command = process.argv[2];
const arg = process.argv[3];

switch (command) {
  case "list":
    listAllSkills().then((skills) => {
      skills.forEach((skill, index) => {
        console.log(`${index + 1}. ${skill.id}: ${skill.displayTitle}`);
      });
    });
    break;
  case "get":
    if (arg) {
      getSkillDetails(arg);
    } else {
      console.error("Please provide a skill ID");
    }
    break;
  default:
    console.log("Usage: ts-node manage_skills.ts [list|get] [skill_id]");
}
```

[(2)](https://docs.claude.com/en/api/skills-guide#using-skills-in-messages)

Create `~/.claude/skills/api-helper/scripts/api_client.ts`:

```typescript
import Anthropic from "@anthropic-ai/sdk";

export function createClient(): Anthropic {
  const apiKey = process.env.ANTHROPIC_API_KEY;

  if (!apiKey) {
    throw new Error("ANTHROPIC_API_KEY environment variable not set");
  }

  return new Anthropic({ apiKey });
}

export async function listSkillsWithClient(client: Anthropic) {
  return await client.beta.skills.list({
    betas: ["skills-2025-10-02"],
  });
}
```

[(2)](https://docs.claude.com/en/api/skills-guide#using-skills-in-messages)

## Step 5: Install Dependencies

Create a `package.json` in each Skill directory:

```bash
cd ~/.claude/skills/skills-manager
npm init -y
npm install @anthropic-ai/sdk typescript ts-node @types/node

cd ~/.claude/skills/api-helper
npm init -y
npm install @anthropic-ai/sdk typescript ts-node @types/node
```

Create `tsconfig.json` in each Skill directory:

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./scripts",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true
  },
  "include": ["scripts/**/*"],
  "exclude": ["node_modules"]
}
```

## Step 6: Install Skills in Claude Code

Skills in Claude Code are automatically loaded from the `~/.claude/skills/` directory [(1)](https://docs.claude.com/en/docs/claude-code/skills#troubleshooting):

```bash
# Personal Skills location - already created above
# Verify structure
ls -la ~/.claude/skills/skills-manager
ls -la ~/.claude/skills/api-helper
```

## Step 7: Set Up Environment Variables

Ensure your API key is available [(2)](https://docs.claude.com/en/api/skills-guide#using-skills-in-messages):

```bash
export ANTHROPIC_API_KEY="your-api-key-here"

# Add to your shell profile for persistence
echo 'export ANTHROPIC_API_KEY="your-api-key-here"' >> ~/.bashrc
# or for zsh
echo 'export ANTHROPIC_API_KEY="your-api-key-here"' >> ~/.zshrc
```

## Step 8: Test the Skills

Test the scripts directly first:

```bash
# Test listing skills
cd ~/.claude/skills/skills-manager
ts-node scripts/list_skills.ts

# Test management commands
ts-node scripts/manage_skills.ts list
```

Then test in Claude Code:

```bash
# In Claude Code, ask:
"List all my available Skills using the skills manager"
"Show me details about a specific Skill"
```

Claude will automatically load and use the Skills when relevant to your request [(1)](https://docs.claude.com/en/docs/claude-code/skills#troubleshooting)[(3)](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview#where-skills-work).

## Step 9: Create a Plugin for Team Distribution (Future Roadmap)

To share with your team, create a Claude Code plugin [(4)](https://docs.claude.com/en/docs/claude-code/plugins-reference#plugin-components-reference):

```shell
skills-management-plugin/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   ├── skills-manager/
│   │   ├── SKILL.md
│   │   ├── package.json
│   │   ├── tsconfig.json
│   │   └── scripts/
│   │       ├── list_skills.ts
│   │       └── manage_skills.ts
│   └── api-helper/
│       ├── SKILL.md
│       ├── package.json
│       ├── tsconfig.json
│       └── scripts/
│           └── api_client.ts
└── README.md
```

Create `.claude-plugin/plugin.json` [(4)](https://docs.claude.com/en/docs/claude-code/plugins-reference#plugin-components-reference):

```json
{
  "name": "skills-management",
  "version": "1.0.0",
  "description": "Skills management and listing capabilities for TypeScript",
  "author": {
    "name": "Your Team",
    "email": "team@example.com"
  },
  "keywords": ["skills", "management", "typescript"],
  "license": "MIT"
}
```

## Questions and Answers

Key Questions

1. API Access: Do you have an Anthropic API key available for testing the Skills API integration, and do
   you want me to proceed with implementing this solution?
   Answer: I do have Anthropic API key. Assume it is available as env variable `ANTHROPIC_API_KEY`. Use it for testing and development. Make sure to let me know if you have any issues with authentication
2. Implementation Scope: Are you looking for me to create the complete skill structure as outlined, or
   would you prefer a simplified version focused on just the listing functionality first?
   Answer: simplified version focused on just the listing functionality
3. Environment: Should I create these skills in your personal ~/.claude/skills/ directory, or do you
   want them created in the current project repository for development and testing.
   Answer: I want them created in the current project repository folder /Users/maksim/repos/superpowers-skills/skills/meta/skills-manager. It will be used  by Claude Code plugin https://github.com/MaksimZinovev/superpowers
4. Step 9: Do you want implement skill-manager plugin.
   Answer: no. Not now.

## Permanent Integration Notes

- Skills placed in `~/.claude/skills/` are automatically available [(1)](https://docs.claude.com/en/docs/claude-code/skills#troubleshooting)
- Claude loads Skills automatically when relevant to requests [(1)](https://docs.claude.com/en/docs/claude-code/skills#troubleshooting)[(3)](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview#where-skills-work)
- Skills can compose together - Claude coordinates their use [(2)](https://docs.claude.com/en/api/skills-guide#using-skills-in-messages)
- You can use up to 8 Skills per request [(2)](https://docs.claude.com/en/api/skills-guide#using-skills-in-messages)
- The TypeScript scripts run in the code execution environment when invoked [(3)](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview#where-skills-work)

The Skills will be permanently available in your Claude Code instance and will activate automatically based on the context of your questions [(1)](https://docs.claude.com/en/docs/claude-code/skills#troubleshooting)[(3)](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview#where-skills-work).
