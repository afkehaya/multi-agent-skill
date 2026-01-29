# Multi-Agent Development Skill for Claude Code

Automated parallel development workflow using Claude's Task system and specialized subagents. Transform a PRD into working software with multiple agents building in parallel.

## Features

- **PRD-First Workflow** - Start with requirements, get automatic technical planning
- **Parallel Execution** - Multiple specialized agents work simultaneously
- **Git Worktree Isolation** - Each agent works in its own branch, no conflicts
- **Dependency Tracking** - Tasks execute in the right order automatically
- **Progress Monitoring** - Real-time status across all agents

## Quick Start

```bash
# Clone and install globally
git clone https://github.com/afkehaya/multi-agent-skill.git
cd multi-agent-skill
./install.sh

# Then in any project:
/multi-agent init
# Fill out docs/PRD.md
/multi-agent plan docs/PRD.md
/multi-agent build
```

## Installation

### Option 1: Global Installation (recommended)

```bash
./install.sh
```

Installs to `~/.claude/` - available in all projects.

### Option 2: Per-Project Installation

```bash
cd your-project
/path/to/install.sh --project
```

Installs to `./.claude/` - only available in that project.

### Manual Installation

1. Copy `.claude/commands/` and `.claude/skills/` to your target directory
2. Add subagent definitions from `settings.template.json` to your Claude settings

## Configuration

After installing, add the subagent definitions to your Claude settings:

**For global install:** `~/.claude/settings.json`
**For project install:** `.claude/settings.local.json`

Copy the `subagents` block from `settings.template.json`:

```json
{
  "subagents": {
    "backend-agent": { ... },
    "frontend-agent": { ... },
    "qa-agent": { ... },
    "docs-agent": { ... }
  }
}
```

## Usage

### `/multi-agent init`

Initializes a new project with:
- `docs/PRD.md` - Product requirements template
- `CLAUDE.md` - Project rules for agents

### `/multi-agent plan docs/PRD.md`

Reads your PRD and generates:
- `docs/TECHNICAL.md` - Tech stack, architecture, data models
- TaskList with dependencies and parallel execution waves

### `/multi-agent build`

Executes the TaskList:
1. Creates git worktrees for isolated agent work
2. Spawns parallel agents for independent tasks
3. Monitors progress and merges completed work
4. Continues until all tasks complete

### `/multi-agent status`

Shows current build progress:
- Active agents and their tasks
- Completed tasks
- Queued tasks waiting on dependencies

## How It Works

### Task Waves

Tasks are organized into waves based on dependencies:

```
Wave 1 (parallel): [SETUP] Initialize project, Configure environment
Wave 2 (parallel): [BACKEND] Data models, [FRONTEND] Component library
Wave 3 (parallel): [BACKEND] API endpoints, [FRONTEND] Pages
Wave 4: [INTEGRATION] Connect frontend to backend
Wave 5 (parallel): [QA] Tests, [DOCS] API documentation
```

### Specialist Agents

| Agent | Focus Area | Works On |
|-------|------------|----------|
| backend-agent | API, database, services | `src/api/`, `src/models/` |
| frontend-agent | UI, components, state | `src/components/`, `src/pages/` |
| qa-agent | Tests, validation | `tests/`, `__tests__/` |
| docs-agent | Documentation | `docs/`, `README.md` |

### Git Worktree Isolation

Each agent works in its own worktree branch:

```
.worktrees/
├── backend-agent/    → branch: agent/backend
├── frontend-agent/   → branch: agent/frontend
└── qa-agent/         → branch: agent/qa
```

Work merges to main after each task completes.

### Agent Communication

Agents share progress via scratchpad files:

```
.worktrees/.scratchpad/
├── backend-agent.md   # Backend progress & artifacts
├── frontend-agent.md  # Frontend progress & artifacts
├── qa-agent.md        # QA progress & artifacts
└── blockers.md        # Cross-agent blockers
```

## Best Practices Implemented

Based on community research from Reddit, X, and engineering blogs:

1. **PRD-First Architecture** - Requirements before code
2. **The 3-Task Rule** - Skip orchestration for simple projects
3. **Specialist Separation** - Agents focus on one domain
4. **Dependency Mapping** - Auto-detect parallelizable work
5. **Scratchpad Communication** - Reduces context degradation
6. **Git Worktree Isolation** - Prevents merge conflicts

## File Structure

```
multi-agent-skill/
├── .claude/
│   ├── commands/
│   │   └── multi-agent.md        # Slash command router
│   └── skills/
│       └── multi-agent/
│           ├── skill.md          # Main workflow (450+ lines)
│           └── templates/
│               ├── PRD-TEMPLATE.md       # Requirements template
│               └── CLAUDE-PROJECT.md     # Project CLAUDE.md
├── settings.template.json        # Subagent definitions to copy
├── install.sh                    # Installation script
├── LICENSE                       # MIT license
└── README.md                     # This file
```

## Troubleshooting

### Merge conflicts during build

Build pauses automatically. Resolve conflicts manually, then run `/multi-agent build` to resume.

### Agent failures

Failed tasks are marked as blocked. Check `.worktrees/.scratchpad/blockers.md` for details.

### Cleanup worktrees

```bash
git worktree remove .worktrees/backend-agent
git worktree remove .worktrees/frontend-agent
git worktree remove .worktrees/qa-agent
rm -rf .worktrees
```

## Contributing

1. Fork this repo
2. Make changes
3. Test with a sample project
4. Submit PR

## License

MIT - see [LICENSE](LICENSE)

## Credits

Built with insights from the Claude Code community on Reddit and X.
