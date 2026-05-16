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
├── python-backend/
│   └── SKILL.md          # Python 后端 API 开发规范（FastAPI + 契约优先）
├── web-admin-dashboard/
│   └── SKILL.md          # Web 管理端规范（RBAC + 中后台最佳实践）
├── web-frontend/
│   └── SKILL.md          # Web 用户端规范（i18n + 响应式）
└── wechat-miniprogram/
    └── SKILL.md          # 微信小程序规范（合规 + 性能）
```

---

## 使用方式

### 自动激活
Kiro 会根据对话内容自动匹配并加载 skill：
- 提到"写个接口" → 自动加载 `python-backend`
- 提到"用户端页面" → 自动加载 `web-frontend`
- 提到"管理后台权限" → 自动加载 `web-admin-dashboard`
- 提到"拆解需求" → 自动加载 `fullstack-planning`
- 提到"分配任务/验收" → 自动加载 `project-commander`
- 提到"小程序" → 自动加载 `wechat-miniprogram`

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

### 3. python-backend
**触发场景**：编写 Python API、设计数据库、写单元测试
**核心规则**：
- FastAPI 框架，接口契约优先（Pydantic Schema → OpenAPI → 生成前端类型）
- 分层约束：api / services / repositories / models 四层分离
- asyncio 异步编程，统一错误码响应格式
- Alembic 数据库迁移

### 4. web-admin-dashboard
**触发场景**：开发管理后台、权限控制、数据看板
**核心规则**：
- RBAC 权限模型，权限到按钮级
- 动态菜单 + 路由守卫
- 列表/表单/详情/看板四类页面规范
- 类型安全，禁止 `any`

### 5. web-frontend
**触发场景**：开发用户端网站、响应式页面、国际化
**核心规则**：
- i18n 国际化支持，禁止硬编码文案
- 响应式设计（移动端 + 桌面端）
- 统一 API 封装，Token 过期处理
- 组件化 + 路由懒加载

### 6. wechat-miniprogram
**触发场景**：开发微信小程序、处理隐私合规、提审前检查
**核心规则**：
- 隐私接口必须适配 `requirePrivacyAuthorize`
- 敏感数据走后端，前端禁止本地存储
- 主包不超过 2MB，分包加载
- 提审前输出合规检查清单

---

*适配：Kiro IDE / Kiro CLI*
