# Kiro Skills Collection

A universal full-stack development Skills suite built on [obra/superpowers](https://github.com/obra/superpowers) core philosophy, customized for the Kiro IDE format.

---

## File Structure

```
skills/
├── project-commander/
│   └── SKILL.md          # Project Commander (orchestration, acceptance, quality)
├── fullstack-planning/
│   └── SKILL.md          # Full-stack Planning (requirement clarification + task breakdown)
├── go-backend/
│   └── SKILL.md          # Go Backend API (Gin/go-zero + contract-first)
├── python-backend/
│   └── SKILL.md          # Python Backend API (FastAPI + contract-first)
├── web-admin-dashboard/
│   └── SKILL.md          # Web Admin Dashboard (RBAC + best practices)
├── web-frontend/
│   └── SKILL.md          # Web Frontend (i18n + responsive)
├── wechat-miniprogram/
│   └── SKILL.md          # WeChat Mini Program (compliance + performance)
├── qa-testing/
│   └── SKILL.md          # QA Testing (verification + reporting + regression)
└── templates/            # Multi-expert collaboration templates (Commander protocol)
    ├── .commander/
    │   ├── system-prompts/   # Role-specific system prompt templates
    │   │   ├── commander.md
    │   │   ├── backend.md
    │   │   ├── admin.md
    │   │   ├── miniapp.md
    │   │   └── qa.md
    │   ├── prompts/          # Instruction files
    │   ├── status/           # Status reports
    │   ├── contracts/        # API contracts
    │   └── phases/           # Phase records
    └── WORKFLOW.md           # Collaboration workflow guide
```

---

## Usage

### New Project Initialization
```bash
# Copy skills specs into your project
cp -r skills/ my-project/.skills/
rm -rf my-project/.skills/.git my-project/.skills/templates

# Copy Commander collaboration templates
cp -r skills/templates/.commander my-project/.commander
cp skills/templates/WORKFLOW.md my-project/WORKFLOW.md

# Edit {{PROJECT_NAME}} and {{PROJECT_DESCRIPTION}} in system-prompts
```

### Choose by Tech Stack

| Project Type | Skills to Use |
|-------------|---------------|
| Go + Mini Program + Admin | project-commander, fullstack-planning, go-backend, web-admin-dashboard, wechat-miniprogram, qa-testing |
| Python + Web Full-stack | project-commander, fullstack-planning, python-backend, web-frontend, web-admin-dashboard, qa-testing |
| Backend API Only | project-commander, go-backend / python-backend, qa-testing |
| Frontend Only | fullstack-planning, web-frontend / web-admin-dashboard |

### Auto-activation
Kiro automatically matches and loads skills based on conversation content:
- Mention "Go API" → loads `go-backend`
- Mention "Python API" → loads `python-backend`
- Mention "user-facing page" → loads `web-frontend`
- Mention "admin dashboard" → loads `web-admin-dashboard`
- Mention "break down requirements" → loads `fullstack-planning`
- Mention "assign tasks / acceptance" → loads `project-commander`
- Mention "mini program" → loads `wechat-miniprogram`
- Mention "test / QA / bug" → loads `qa-testing`

---

## Skill Details

### 1. project-commander
**Trigger**: Coordinating multi-role development, task assignment, acceptance review, managing dev cadence
**Core Rules**:
- Humans decide, AI executes; commander never writes code
- Contract-first: define interfaces before implementation
- Acceptance must verify functional correctness, not just compilation
- Every instruction includes context, dependencies, tasks, deliverables, and self-check list

### 2. fullstack-planning
**Trigger**: New feature kickoff, requirement analysis, task breakdown, tech review
**Core Rules**:
- Socratic requirement clarification (5-question boundary method)
- Phase-based breakdown: Contract → Backend → Frontend → Acceptance
- Task granularity: 2-5 hours; anything larger must be split
- Contract is the single source of truth for frontend-backend collaboration

### 3. go-backend
**Trigger**: Writing Go APIs, database design, implementing handler/service/repository
**Core Rules**:
- Gin / go-zero framework, contract-first
- Layer separation: api / service / repository / model
- TDD: write tests before implementation
- Unified response `{code, message, data}` with error code standards

### 4. python-backend
**Trigger**: Writing Python APIs, database design, unit tests
**Core Rules**:
- FastAPI framework, contract-first (Pydantic Schema → OpenAPI → generate frontend types)
- Layer separation: api / services / repositories / models
- asyncio async programming, unified error response format
- Alembic database migrations

### 5. web-admin-dashboard
**Trigger**: Admin dashboard development, permission control, data dashboards
**Core Rules**:
- RBAC permission model, down to button-level
- Dynamic menu + route guards
- Four page types: list / form / detail / dashboard
- Type-safe, no `any` allowed

### 6. web-frontend
**Trigger**: User-facing website, responsive pages, internationalization
**Core Rules**:
- i18n support, no hardcoded text
- Responsive design (mobile + desktop)
- Unified API wrapper with token expiry handling
- Component-based + route lazy loading

### 7. wechat-miniprogram
**Trigger**: WeChat Mini Program development, privacy compliance, pre-submission checks
**Core Rules**:
- Privacy APIs must use `requirePrivacyAuthorize`
- Sensitive data via backend only, no local storage on client
- Main package under 2MB, use subpackage loading
- Output compliance checklist before submission

### 8. qa-testing
**Trigger**: API testing, UI walkthrough, E2E verification, regression testing
**Core Rules**:
- Report only, never fix; tag severity and assignment suggestions
- Verification layers: build → API → functionality → data consistency
- Every bug must include reproduction steps
- Verify against product docs item by item

---

## Multi-Expert Collaboration

Use with the `.commander/` directory to orchestrate parallel expert development:

```
.commander/
├── prompts/       # Commander → Expert (task instructions)
├── status/        # Expert → Commander (completion reports)
├── contracts/     # API contracts (single source of truth)
└── phases/        # Phase records
```

See `WORKFLOW.md` in each project for details.

---

## Quick Start

### 1. Initialize a New Project

```bash
mkdir my-project && cd my-project
git init

# Copy skills specs (remove unused ones as needed)
cp -r /path/to/skills .skills && rm -rf .skills/.git

# Create collaboration directories
mkdir -p .commander/{prompts,status,contracts,phases} docs scripts

# Add product documents
cp ~/requirements.md docs/
cp ~/prototype.html docs/
```

### 2. Launch kiro-cli

```bash
kiro chat
```

### 3. Send the Kickoff Prompt

```
You are the Project Commander, following .skills/project-commander/SKILL.md spec.

Project info:
- Product docs are in docs/
- Tech stack: Go+Gin / React+AntD / WeChat Mini Program
- Database: MySQL root/root123456

Auto-proceed:
1. Read all product docs in docs/
2. Do requirement analysis and Phase breakdown per fullstack-planning spec
3. Generate expert instructions for each Phase into .commander/prompts/
4. Use subagent to orchestrate parallel expert execution
5. Acceptance (run build + read status reports)
6. Orchestrate QA expert verification
7. If bugs found, dispatch fixes; if PASS, proceed to next Phase
8. Loop until all features are complete
```

### 4. Wait for Completion

The commander will automatically loop through all Phases. You only need to intervene for decisions.

### 5. Run the Project

```bash
make seed    # Initialize database
make dev     # Start frontend and backend
```

---

## Case Study: YuanLi Bear Sports Rehabilitation

A complete project delivered using this Skills suite, 6 Phases auto-delivered:

| Phase | Duration | Output |
|-------|----------|--------|
| 1. Contracts & Scaffolding | ~3min | Go project + React scaffold + Mini Program scaffold + OpenAPI |
| 2. Core Features | ~5min | Auth / Booking / Membership full-stack |
| 3. All Modules | ~5min | 11 admin pages + 5 mini program pages + all APIs |
| 4. Testing & Fixes | ~3min | 12 bugs found and fixed |
| 5. Frontend-Backend Integration | ~4min | Mock → real API + login + route guards |
| 6. Gap Filling | ~5min | MySQL switch + missing features → 100% spec coverage |

Final output: 89 test cases all passing, 100% product spec coverage.

---

*Compatible with: Kiro IDE / Kiro CLI*
