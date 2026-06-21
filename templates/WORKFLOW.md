# 多专家协作工作流

## 架构概览

```
{{PROJECT_NAME}}/
├── .commander/
│   ├── prompts/              # 指挥官生成的指令文件（专家读取）
│   │   ├── backend.md        # 当前给后端专家的指令
│   │   ├── admin.md          # 当前给管理端专家的指令
│   │   └── miniapp.md        # 当前给小程序专家的指令
│   ├── contracts/            # Contract Bundle（唯一真相来源）
│   │   ├── openapi.yaml
│   │   ├── database.md
│   │   ├── permissions.md
│   │   ├── error-codes.md
│   │   ├── frontend-types.md
│   │   ├── seed-data.md
│   │   └── mock-rules.md
│   ├── status/               # 各专家状态报告
│   │   ├── backend.md        # 后端专家完成报告
│   │   ├── admin.md          # 管理端专家完成报告
│   │   └── miniapp.md        # 小程序专家完成报告
│   ├── phases/               # 阶段记录
│   │   └── phase-01.md       # 当前阶段目标与进度
│   └── system-prompts/       # 各角色系统提示词
│       ├── commander.md
│       ├── backend.md
│       ├── admin.md
│       ├── miniapp.md
│       └── qa.md
├── .skills/                  # 各角色 SKILL 规范
├── docs/
│   ├── 00-intake/            # 客户资料、需求审计、人类决策
│   ├── 01-prd/               # PRD、验收标准、需求追踪表
│   ├── 02-design/            # DESIGN.md、设计决策
│   ├── 03-architecture/      # ADR、技术栈决策
│   └── 04-qa/                # 测试报告、演示脚本
└── CLAUDE.md                 # 项目总览（可选）
```

## 人类批准关口

以下节点必须由人类批准，Commander 才能继续推进：

| Gate | 产物 | 人类要判断什么 |
|---|---|---|
| PRD | `docs/01-prd/PRD.md` | 业务范围、用户角色、主流程是否正确 |
| 设计方向 | `docs/02-design/DESIGN.md` | 产品气质、参考风格、设备优先级是否正确 |
| 技术栈 | `docs/03-architecture/adr/0001-tech-stack.md` | 是否符合交付、部署、维护约束 |
| Contract Bundle | `.commander/contracts/` | API、数据、权限、错误码、测试数据是否覆盖主流程 |
| 客户变更 | `docs/05-change-requests/CR-xxx.md` | 是否接受变更，以及是否影响工期 |
| 最终交付 | `docs/04-qa/final-acceptance-report.md` | 是否可演示、可交付 |

## 角色分工

| 终端 | 角色 | 职责 |
|------|------|------|
| 终端 1 | 指挥官 (Commander) | 需求拆解、生成指令、验收产出、分派 bug |
| 终端 2 | 后端专家 (Backend) | Go + Gin API 开发 |
| 终端 3 | 管理端专家 (Admin) | React + Ant Design 管理后台 |
| 终端 4 | 小程序专家 (Miniapp) | 微信小程序开发 |
| 终端 5 | 测试专家 (QA) | 接口测试、UI 走查、联调验证、出测试报告 |

> 按需裁剪：纯 Web 项目可去掉小程序专家，纯后端可只保留后端+测试。

## 工作流循环

```
┌─────────────────────────────────────────────────┐
│  人类                                            │
│  1. 归档客户资料                                 │
│  2. 回答 P0 问题                                 │
│  3. 批准 PRD / 设计 / ADR / Contract Bundle      │
└──────────────────────┬──────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────┐
│  指挥官                                          │
│  1. 需求审计 / PRD / 设计 / ADR / 契约             │
│  2. 通过批准关口后写入 prompts                    │
│  3. 通知专家："指令已更新，开始执行"               │
└──────────────────────┬──────────────────────────┘
                       │
         ┌─────────────┼─────────────┐
         ▼             ▼             ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│ 后端专家      │ │ 管理端专家    │ │ 小程序专家    │
│ 读取 prompt  │ │ 读取 prompt  │ │ 读取 prompt  │
│ 执行任务     │ │ 执行任务     │ │ 执行任务     │
│ 写入 status  │ │ 写入 status  │ │ 写入 status  │
└──────────────┘ └──────────────┘ └──────────────┘
         │             │             │
         └─────────────┼─────────────┘
                       ▼
              指挥官验收 → 调度测试
                       │
                       ▼
              ┌──────────────┐
              │ 测试专家      │
              │ 执行测试     │
              │ 写入测试报告  │
              └──────┬───────┘
                     ▼
              指挥官读取测试报告
              ├── 全部 PASS → 下一个 Phase
              └── 有 BUG → 生成修复指令 → 专家修复 → 回归验证
```

## 指令文件格式

### prompts/{role}.md

```markdown
# Phase {N} — {角色} 指令

> 状态: PENDING | IN_PROGRESS | DONE
> 依赖: 无 | 等待 {role} 完成
> 更新时间: {timestamp}

## 背景
为什么要做这件事

## 任务列表
1. 具体任务（附文件路径或接口定义）
2. ...

## 允许修改
- backend/...

## 禁止修改
- .commander/contracts/（除非指令明确要求）
- 其他专家负责目录

## 交付标准
- [ ] 可验证的检查项

## 参考
- 契约包: .commander/contracts/
- SKILL 规范: .skills/{role}/SKILL.md
```

### status/{role}.md

```markdown
# {角色} 状态报告

> 状态: DONE
> 完成时间: {timestamp}

## 完成内容
- 已完成的任务列表

## 修改文件
- ...

## 运行命令
- `...`

## 自检报告
- [x] 检查项 1
- [x] 检查项 2

## 契约变更
- 无 / 已更新 ...

## 问题与阻塞
- 无 / 描述遇到的问题
```

## 操作指南

### 方式一：单终端 subagent 模式（推荐）

```bash
cd {{PROJECT_NAME}}
kiro chat
```

```
你是项目总指挥，遵循 .skills/project-commander/SKILL.md 规范。
请先读取 docs/START_COMMANDER_PROMPTS.md，按阶段推进：
需求审计 → PRD 批准 → 设计/ADR 批准 → Contract Bundle 批准 → 并行开发 → QA → 交付。
```

### 方式二：多终端手动模式

```bash
# 终端 1 — 指挥官
kiro chat --system-prompt .commander/system-prompts/commander.md

# 终端 2 — 后端专家
kiro chat --system-prompt .commander/system-prompts/backend.md

# 终端 3 — 管理端专家
kiro chat --system-prompt .commander/system-prompts/admin.md

# 终端 4 — 小程序专家
kiro chat --system-prompt .commander/system-prompts/miniapp.md

# 终端 5 — 测试专家
kiro chat --system-prompt .commander/system-prompts/qa.md
```

专家启动后告诉它：
```
读取 .commander/prompts/{role}.md 开始执行
```

### 方式三：混合模型模式（省成本）

- 指挥官用强模型（Claude Opus / Sonnet）
- 专家用便宜模型（DeepSeek / 本地模型）
- 指挥官生成的指令足够详细，弱模型也能按指令完成

## 文件交互协议

```
指挥官写指令 → .commander/prompts/{role}.md
专家读指令   ← .commander/prompts/{role}.md
专家写报告   → .commander/status/{role}.md
指挥官读报告 ← .commander/status/{role}.md
契约包       ↔ .commander/contracts/
```

## 契约管理
- Contract Bundle 放在 `.commander/contracts/`
- 后端专家负责生成/更新 OpenAPI 和后端相关契约
- 前端、小程序专家只读契约，不修改
- 指挥官审核契约变更
- 人类批准 Contract Bundle 后才能并行开发
