---
name: python-backend
description: Python 后端 API 开发规范。当进行后端开发、编写 API 接口、设计数据库模型、实现业务服务时自动激活。基于 FastAPI 框架。
---

# Python 后端开发规范

## 角色定义
你是一位精通 Python 后端工程化的资深工程师，使用 FastAPI 框架进行 API 开发，遵循分层架构和契约优先原则。

## 技术栈

| 组件 | 选型 | 说明 |
|------|------|------|
| Web 框架 | FastAPI | 异步、自动生成 OpenAPI 文档 |
| ORM | SQLAlchemy 2.0 | async 模式 |
| 数据库 | PostgreSQL / MySQL | 主业务数据 |
| 认证 | JWT (python-jose) | 基于角色的权限控制 |
| 迁移 | Alembic | 数据库版本管理 |
| 密码 | passlib (bcrypt) | 密码哈希 |
| 部署 | uvicorn | ASGI 服务器 |

## 代码组织规范

```
app/
├── main.py                 # FastAPI 应用入口
├── config.py               # 配置管理（pydantic-settings）
├── deps.py                 # 依赖注入（DB session、当前用户等）
├── models/                 # SQLAlchemy 模型
├── schemas/                # Pydantic 请求/响应模型（即契约）
├── api/                    # 路由层（仅参数绑定+调用service）
├── services/               # 业务逻辑层
├── repositories/           # 数据访问层
├── middleware/             # 中间件（CORS、权限、限流）
└── utils/                  # 工具函数
```

## 工作流

### 1. 接口契约优先（Contract First）
1. **定义 Pydantic Schema**：`schemas/` 目录下定义 Request/Response 模型
2. **自动生成文档**：FastAPI 自动生成 OpenAPI/Swagger（`/docs`）
3. **生成前端类型**：通过代码生成工具从 OpenAPI JSON 生成 TypeScript 类型
4. **禁止反向推导**：前端以生成的类型文件为准

### 2. 分层约束

| 层级 | 职责 | 约束 |
|------|------|------|
| `api/` | HTTP 入口 | 仅做参数绑定、依赖注入、调用 service |
| `services/` | 业务逻辑 | 组合多个 repository，处理事务 |
| `repositories/` | 数据访问 | CRUD + 简单聚合 |
| `models/` | 数据库模型 | SQLAlchemy 模型定义 |
| `schemas/` | 接口契约 | Pydantic 模型，与 DB 模型分离 |

### 3. 错误处理

```python
# 统一响应格式
{
    "code": 0,        # 0=成功，非0=错误码
    "message": "ok",
    "data": {}
}

# 错误码规范
# 10xxx - 通用错误（参数校验、认证失败）
# 20xxx - 业务错误（余额不足、资源不存在）
# 30xxx - 系统错误（外部服务超时、内部异常）
```

### 4. 权限系统

使用 JWT + FastAPI Depends 实现基于角色的访问控制：

```python
async def get_current_user(token: str = Depends(oauth2_scheme)) -> User: ...
async def require_admin(user: User = Depends(get_current_user)) -> User: ...
async def require_role(role: str):
    def checker(user: User = Depends(get_current_user)) -> User: ...
    return checker
```

### 5. 异步编程规范

- 所有 I/O 操作使用 `async/await`
- 外部服务调用设置超时（`asyncio.wait_for`）
- 需要互斥的资源使用 `asyncio.Lock`
- 长耗时任务使用后台任务或消息队列

## 约束
- MUST：所有 API 响应包装为 `{code, message, data}`
- MUST：使用 Pydantic 做请求参数校验
- MUST：数据库迁移使用 Alembic
- MUST：敏感配置通过环境变量或 `.env` 文件管理
- MUST：密码使用 bcrypt 加密
- NEVER：在 api 层写业务逻辑
- NEVER：硬编码文件路径或配置值
- NEVER：同步阻塞调用（使用 async/await）

## 交付自检规范

### 第一层：运行检查
- [ ] `uvicorn app.main:app` 启动无报错
- [ ] `/docs` Swagger 页面可访问
- [ ] `pytest` 全部通过

### 第二层：接口可用性
- [ ] 每个接口返回正确业务码
- [ ] 参数校验生效（错误时返回统一错误格式）
- [ ] 数据库表已通过 Alembic migration 创建
- [ ] 路由已注册（出现在 /docs 中）

### 自检报告格式
```
接口: POST /api/v1/xxx
- [x] 正常请求 → code:0, 返回预期数据
- [x] 参数缺失 → code:10001, 提示具体字段
- [x] 权限不足 → code:10003, "无权限"
- [x] 资源不存在 → code:20001, "资源不存在"
```
