# Kiro Skills Collection

基于 [obra/superpowers](https://github.com/obra/superpowers) 核心思想，针对 Kiro IDE 格式定制的一套通用全栈开发 Skills。

---

## 文件结构

```
skills/
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
    │   │   ├── admin.md
    │   │   ├── miniapp.md
    │   │   └── qa.md
    │   ├── prompts/          # 指令文件目录
    │   ├── status/           # 状态报告目录
    │   ├── contracts/        # 接口契约目录
    │   └── phases/           # 阶段记录目录
    └── WORKFLOW.md           # 协作工作流说明
```

---

## 使用方式

### 新项目初始化
```bash
# 复制 skills 规范到项目中
cp -r skills/ my-project/.skills/
rm -rf my-project/.skills/.git my-project/.skills/templates

# 复制 Commander 协作模板
cp -r skills/templates/.commander my-project/.commander
cp skills/templates/WORKFLOW.md my-project/WORKFLOW.md

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
- 契约优先，先定接口再开发
- 验收必须验证功能可用性，不只看编译通过
- 每份指令包含背景、依赖、任务、交付标准、自检清单

### 2. fullstack-planning
**触发场景**：新功能启动、需求分析、任务拆解、技术评审
**核心规则**：
- 苏格拉底式需求澄清（5 个问题边界法）
- 按 Phase 拆解：契约 → 后端 → 前端 → 验收
- 任务粒度 2-5 工时，超过必须拆分
- 契约是前后端协作的唯一真相来源

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
├── contracts/     # 接口契约（唯一真相来源）
└── phases/        # 阶段记录
```

详见各项目中的 `WORKFLOW.md`。

---

## 快速上手 Demo

### 1. 初始化新项目

```bash
mkdir my-project && cd my-project
git init

# 复制 skills 规范（按需删除不用的）
cp -r /path/to/skills .skills && rm -rf .skills/.git

# 创建协作目录
mkdir -p .commander/{prompts,status,contracts,phases} docs scripts

# 放入产品文档
cp ~/产品需求.md docs/
cp ~/原型.html docs/
```

### 2. 启动 kiro-cli

```bash
kiro chat
```

### 3. 发送启动指令

```
你是项目总指挥，遵循 .skills/project-commander/SKILL.md 规范。

项目信息：
- 产品文档在 docs/ 目录
- 技术栈：Go+Gin / React+AntD / 微信小程序
- 数据库：MySQL root/root123456

请自动推进：
1. 阅读 docs/ 下所有产品文档
2. 按 fullstack-planning 规范做需求分析和 Phase 拆解
3. 每个 Phase 生成各专家指令到 .commander/prompts/
4. 用 subagent 调度专家并行执行
5. 验收（跑构建 + 读 status 报告）
6. 调度测试专家验证
7. 有 bug 则分派修复，PASS 则进入下一 Phase
8. 循环直到全部功能完成
```

### 4. 等待完成

指挥官会自动循环执行所有 Phase，你只需要在遇到问题时介入决策。

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
