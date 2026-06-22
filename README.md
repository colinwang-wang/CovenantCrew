# Skills Collection

基于 [obra/superpowers](https://github.com/obra/superpowers) 核心思想，针对 Kiro IDE 格式定制的一套通用全栈开发 Skills。

---

## 文件结构

```
CovenantCrew/
├── scripts/
│   └── init-project.sh   # 新项目工厂：生成 docs/.skills/.commander 骨架
├── project-commander/
│   └── SKILL.md          # 项目总指挥规范（调度、验收、质量把控）
├── fullstack-planning/
│   └── SKILL.md          # 全栈项目规划（需求澄清 + 任务拆解）
├── go-backend/
│   └── SKILL.md          # Go 后端 API 开发规范（Gin/go-zero + 契约优先）
├── python-backend/
│   └── SKILL.md          # Python 后端 API 开发规范（FastAPI + 契约优先）
├── web-admin-dashboard/
│   └── SKILL.md          # Web 管理端规范（RBAC + 中后台最佳实践）
├── web-frontend/
│   └── SKILL.md          # Web 用户端规范（i18n + 响应式）
├── wechat-miniprogram/
│   └── SKILL.md          # 微信小程序规范（合规 + 性能）
├── qa-testing/
│   └── SKILL.md          # 测试专家规范（验证 + 报告 + 回归）
└── templates/            # 多专家协作模板（Commander 协议）
    ├── .commander/
    │   ├── system-prompts/   # 各角色系统提示词模板
    │   │   ├── commander.md
    │   │   ├── backend.md
    │   │   ├── python-backend.md
    │   │   ├── admin.md
    │   │   ├── miniapp.md
    │   │   └── qa.md
    │   ├── prompts/          # 指令文件目录
    │   ├── status/           # 状态报告目录
    │   ├── contracts/        # Contract Bundle 目录
    │   └── phases/           # 阶段记录目录
    ├── project-start/        # 人类 SOP、启动提示词、质量门、技术栈预设、契约模板
    └── WORKFLOW.md           # 协作工作流说明
```

---

## 使用方式

### 人类项目启动 SOP

当拿到一个新项目时，先按 `templates/project-start/HUMAN_SOP.md` 执行。这个流程把人类动作限定在资料归档、P0 问题确认、PRD 批准、设计方向批准、技术栈 ADR 批准、Contract Bundle 批准和最终业务验收。

配套模板：

- `templates/project-start/PROJECT_INTAKE_PACKET.md`：客户资料收集表
- `templates/project-start/START_COMMANDER_PROMPTS.md`：分阶段启动 Commander 的可复制提示词
- `templates/project-start/QUALITY_GATES.md`：从需求到交付的质量门清单
- `templates/project-start/STACK_PRESETS.yml`：技术栈预设
- `templates/project-start/contract-bundle/`：API、数据库、权限、错误码、类型、测试数据、mock 边界模板

### 推荐：项目工厂初始化

```bash
cd /Users/clwang/workspace/OutWorks/CovenantCrew
./scripts/init-project.sh ../my-project saas_admin "My Project"
```

生成后你只需要：

1. 把客户资料放进 `docs/00-intake/raw/`
2. 填写 `docs/00-intake/intake-packet.md`
3. 把参考链接写到 `docs/00-intake/source-links.md`
4. 把 `docs/START_COMMANDER_PROMPTS.md` 里的“阶段 A：需求审计”发给 Commander

常用 preset：

| Preset | 适用场景 |
|---|---|
| `saas_admin` | SaaS、中后台、CRM/ERP、数据密集管理系统 |
| `go_business_platform` | 高并发业务系统、Go 团队、清晰 API 边界 |
| `wechat_business` | 小程序 + 管理后台 + 预约/会员/本地服务 |
| `marketing_site` | 品牌站、产品官网、营销页 |
| `custom` | 客户指定技术栈或旧系统改造 |

### 新项目初始化
```bash
# 进入 CovenantCrew 仓库
cd /Users/clwang/workspace/OutWorks/CovenantCrew

# 推荐：一键初始化
./scripts/init-project.sh ../my-project saas_admin "My Project"

# 如需手动复制 skills 规范
mkdir -p ../my-project/.skills
cp -R project-commander fullstack-planning coding-guidelines \
  go-backend python-backend web-admin-dashboard web-frontend \
  wechat-miniprogram qa-testing ../my-project/.skills/

# 复制 Commander 协作模板
cp -R templates/.commander ../my-project/.commander
cp templates/WORKFLOW.md ../my-project/WORKFLOW.md

# 编辑 system-prompts 中的 {{PROJECT_NAME}} 和 {{PROJECT_DESCRIPTION}}
```

### 按需选择
不是每个项目都需要全部 skill，按技术栈选择：

| 项目类型 | 选择的 Skills |
|----------|--------------|
| Go + 小程序 + 管理端 | project-commander, fullstack-planning, go-backend, web-admin-dashboard, wechat-miniprogram, qa-testing |
| Python + Web 全栈 | project-commander, fullstack-planning, python-backend, web-frontend, web-admin-dashboard, qa-testing |
| 纯后端 API | project-commander, go-backend / python-backend, qa-testing |
| 纯前端 | fullstack-planning, web-frontend / web-admin-dashboard |

### 自动激活
Kiro 会根据对话内容自动匹配并加载 skill：
- 提到"写个 Go 接口" → 自动加载 `go-backend`
- 提到"写个 Python 接口" → 自动加载 `python-backend`
- 提到"用户端页面" → 自动加载 `web-frontend`
- 提到"管理后台权限" → 自动加载 `web-admin-dashboard`
- 提到"拆解需求" → 自动加载 `fullstack-planning`
- 提到"分配任务/验收" → 自动加载 `project-commander`
- 提到"小程序" → 自动加载 `wechat-miniprogram`
- 提到"测试/验收/bug" → 自动加载 `qa-testing`

---

## Skill 详解

### 1. project-commander
**触发场景**：协调多角色协同开发、分配任务、验收产出、管理开发节奏
**核心规则**：
- 人做决策，AI 做执行；指挥官不写代码
- 契约优先，先定 Contract Bundle 再并行开发
- 验收必须验证功能可用性，不只看编译通过
- 每份指令包含背景、依赖、任务、交付标准、自检清单

### 2. fullstack-planning
**触发场景**：新功能启动、需求分析、任务拆解、技术评审
**核心规则**：
- 苏格拉底式需求澄清（5 个问题边界法）
- 按 Phase 拆解：需求审计 → PRD → 设计/ADR → Contract Bundle → 后端 → 前端 → 验收
- 任务粒度 2-5 工时，超过必须拆分
- Contract Bundle 是前后端协作的唯一真相来源

### 3. go-backend
**触发场景**：编写 Go API、设计数据库、实现 handler/service/repository
**核心规则**：
- Gin / go-zero 框架，接口契约优先
- 分层约束：api / service / repository / model 四层分离
- TDD：先写测试再写实现
- 统一响应 `{code, message, data}`，错误码规范

### 4. python-backend
**触发场景**：编写 Python API、设计数据库、写单元测试
**核心规则**：
- FastAPI 框架，接口契约优先（Pydantic Schema → OpenAPI → 生成前端类型）
- 分层约束：api / services / repositories / models 四层分离
- asyncio 异步编程，统一错误码响应格式
- Alembic 数据库迁移

### 5. web-admin-dashboard
**触发场景**：开发管理后台、权限控制、数据看板
**核心规则**：
- RBAC 权限模型，权限到按钮级
- 动态菜单 + 路由守卫
- 列表/表单/详情/看板四类页面规范
- 类型安全，禁止 `any`

### 6. web-frontend
**触发场景**：开发用户端网站、响应式页面、国际化
**核心规则**：
- i18n 国际化支持，禁止硬编码文案
- 响应式设计（移动端 + 桌面端）
- 统一 API 封装，Token 过期处理
- 组件化 + 路由懒加载

### 7. wechat-miniprogram
**触发场景**：开发微信小程序、处理隐私合规、提审前检查
**核心规则**：
- 隐私接口必须适配 `requirePrivacyAuthorize`
- 敏感数据走后端，前端禁止本地存储
- 主包不超过 2MB，分包加载
- 提审前输出合规检查清单

### 8. qa-testing
**触发场景**：接口测试、UI 走查、端到端验证、回归测试
**核心规则**：
- 只报告不修复，标注严重程度和分派建议
- 验证层次：构建 → 接口 → 功能 → 数据一致性
- 每个 bug 必须包含复现步骤
- 对照产品文档逐项验证，不遗漏

---

## 多专家协作模式

配合 `.commander/` 目录使用，实现指挥官调度多专家并行开发：

```
.commander/
├── prompts/       # 指挥官 → 专家（当前任务指令）
├── status/        # 专家 → 指挥官（完成报告）
├── contracts/     # Contract Bundle（唯一真相来源）
└── phases/        # 阶段记录
```

详见各项目中的 `WORKFLOW.md`。

### Contract Bundle

并行开发前必须先批准 `.commander/contracts/`：

```text
openapi.yaml        # API 路径、请求、响应、鉴权
database.md         # 表、字段、索引、迁移规则
permissions.md      # 角色、路由、按钮级权限
error-codes.md      # 错误码范围和前端处理
frontend-types.md   # 类型生成来源和命令
seed-data.md        # 本地、测试、演示数据
mock-rules.md       # 允许 mock 的边界和移除条件
```

---

## 快速上手 Demo

### 1. 初始化新项目

```bash
cd /Users/clwang/workspace/OutWorks/CovenantCrew
./scripts/init-project.sh ../my-project wechat_business "My Project"
cd ../my-project

# 放入产品文档
cp ~/产品需求.md docs/00-intake/raw/
cp ~/原型.html docs/00-intake/raw/
```

### 2. 填写资料

- 填写 `docs/00-intake/intake-packet.md`
- 写入参考链接到 `docs/00-intake/source-links.md`

### 3. 启动 kiro-cli

```bash
kiro chat
```

### 4. 发送阶段 A 指令

复制 `docs/START_COMMANDER_PROMPTS.md` 里的“阶段 A：需求审计”。

之后按阶段批准：

1. PRD
2. 设计方向
3. 技术栈 ADR
4. Contract Bundle
5. 多专家并行开发
6. QA 与最终业务验收

### 5. 启动项目

```bash
make seed    # 初始化数据库
make dev     # 前后端同时启动
```

---

## 实战案例：元力熊运动康复

使用本 Skills 套件完成的完整项目，6 个 Phase 自动交付：

| Phase | 耗时 | 产出 |
|-------|------|------|
| 1. 契约与骨架 | ~3min | Go 项目 + React 骨架 + 小程序骨架 + OpenAPI |
| 2. 核心功能 | ~5min | 认证/预约/会员 全栈实现 |
| 3. 全量模块 | ~5min | 11 个管理页 + 5 个小程序页 + 全部 API |
| 4. 测试修复 | ~3min | 12 个 bug 发现并修复 |
| 5. 前后端联调 | ~4min | mock 替换真实 API + 登录 + 路由守卫 |
| 6. 查漏补缺 | ~5min | MySQL 切换 + 缺失功能补全 → 100% 还原 |

最终产出：89 个测试用例全部通过，功能点 100% 还原产品规格。

---

*适配：Kiro IDE / Kiro CLI*
