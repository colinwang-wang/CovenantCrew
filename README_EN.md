# Kiro Skills Collection

A universal full-stack development Skills suite built on [obra/superpowers](https://github.com/obra/superpowers) core philosophy, customized for the Kiro IDE format.

---

## File Structure

```
CovenantCrew/
├── scripts/
│   └── init-project.sh   # Project factory: creates docs/.skills/.commander scaffold
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
    │   │   ├── python-backend.md
    │   │   ├── admin.md
    │   │   ├── miniapp.md
    │   │   └── qa.md
    │   ├── prompts/          # Instruction files
    │   ├── status/           # Status reports
    │   ├── contracts/        # Contract Bundle
    │   └── phases/           # Phase records
    ├── project-start/        # Human SOP, kickoff prompts, gates, stack presets, contract templates
    └── WORKFLOW.md           # Collaboration workflow guide
```

---

## Usage

### Recommended: Project Factory

```bash
cd /Users/clwang/workspace/OutWorks/CovenantCrew
./scripts/init-project.sh ../my-project saas_admin "My Project"
```

After initialization:

1. Put customer source materials into `docs/00-intake/raw/`
2. Fill `docs/00-intake/intake-packet.md`
3. Add references to `docs/00-intake/source-links.md`
4. Send Stage A from `docs/START_COMMANDER_PROMPTS.md` to Commander

Common presets:

| Preset | Best For |
|---|---|
| `saas_admin` | SaaS, admin dashboards, CRM/ERP, data-heavy tools |
| `go_business_platform` | High-concurrency business systems and Go teams |
| `wechat_business` | WeChat Mini Program + admin + booking/membership/local service flows |
| `marketing_site` | Brand sites, product sites, landing pages |
| `custom` | Customer-mandated stacks or legacy system work |

### New Project Initialization
```bash
# Enter CovenantCrew repo
cd /Users/clwang/workspace/OutWorks/CovenantCrew

# Recommended: one-command initialization
./scripts/init-project.sh ../my-project saas_admin "My Project"

# Manual copy if needed
mkdir -p ../my-project/.skills
cp -R project-commander fullstack-planning coding-guidelines \
  go-backend python-backend web-admin-dashboard web-frontend \
  wechat-miniprogram qa-testing ../my-project/.skills/

# Copy Commander collaboration templates
cp -R templates/.commander ../my-project/.commander
cp templates/WORKFLOW.md ../my-project/WORKFLOW.md

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
- Contract-first: approve the Contract Bundle before parallel implementation
- Acceptance must verify functional correctness, not just compilation
- Every instruction includes context, dependencies, tasks, deliverables, and self-check list

### 2. fullstack-planning
**Trigger**: New feature kickoff, requirement analysis, task breakdown, tech review
**Core Rules**:
- Socratic requirement clarification (5-question boundary method)
- Phase-based breakdown: Intake audit → PRD → Design/ADR → Contract Bundle → Backend → Frontend → Acceptance
- Task granularity: 2-5 hours; anything larger must be split
- Contract Bundle is the single source of truth for frontend-backend collaboration

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
├── contracts/     # Contract Bundle (single source of truth)
└── phases/        # Phase records
```

See `WORKFLOW.md` in each project for details.

### Contract Bundle

Before parallel implementation starts, `.commander/contracts/` must be approved:

```text
openapi.yaml        # API paths, requests, responses, auth
database.md         # Tables, fields, indexes, migration rules
permissions.md      # Roles, routes, button-level permissions
error-codes.md      # Error code ranges and frontend handling
frontend-types.md   # Type generation source and commands
seed-data.md        # Local, QA, and demo data
mock-rules.md       # Allowed mock boundaries and removal conditions
```

---

## Quick Start

### 1. Initialize a New Project

```bash
cd /Users/clwang/workspace/OutWorks/CovenantCrew
./scripts/init-project.sh ../my-project wechat_business "My Project"
cd ../my-project

# Add product documents
cp ~/requirements.md docs/00-intake/raw/
cp ~/prototype.html docs/00-intake/raw/
```

### 2. Fill Intake Files

- Fill `docs/00-intake/intake-packet.md`
- Add references to `docs/00-intake/source-links.md`

### 3. Launch kiro-cli

```bash
kiro chat
```

### 4. Send Stage A

Copy Stage A from `docs/START_COMMANDER_PROMPTS.md`.

Then approve each stage:

1. PRD
2. Design direction
3. Tech stack ADR
4. Contract Bundle
5. Multi-expert parallel implementation
6. QA and final business acceptance

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
