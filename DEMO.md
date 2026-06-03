# CovenantCrew 使用 Demo

## 方式一：单终端模式（推荐）

一个终端搞定，指挥官通过 subagent 自动调度专家。

```bash
cd my-project
kiro chat
```

```
你是项目总指挥，遵循 .skills/project-commander/SKILL.md 规范。

项目信息：
- 产品文档：docs/
- 技术栈：Go+Gin / React+AntD / 微信小程序
- 数据库：MySQL root/root123456

工作方式：
1. 阅读 docs/ 做需求分析
2. 生成各专家指令到 .commander/prompts/
3. 用 subagent 并行调度专家执行
4. 验收 → 测试 → 修复 → 循环
5. 全部完成后输出总结

开始。
```

> 然后等它自动跑完所有 Phase。

---

## 方式二：多终端模式（手动协调）

适合想精细控制每一步的场景。

### 终端 1 — 指挥官

```bash
kiro chat
```

```
你是项目总指挥。阅读 docs/ 下产品文档，
按 .skills/fullstack-planning/SKILL.md 做需求分析和 Phase 1 任务拆解，
生成各专家指令到 .commander/prompts/
```

等指令文件生成后，去其他终端启动专家。

### 终端 2 — 后端专家

```bash
kiro chat
```

```
你是 Go 后端专家，遵循 .skills/go-backend/SKILL.md。
读取 .commander/prompts/backend.md，按指令执行。
完成后写状态报告到 .commander/status/backend.md。
```

### 终端 3 — 前端专家

```bash
kiro chat
```

```
你是管理端专家，遵循 .skills/web-admin-dashboard/SKILL.md。
读取 .commander/prompts/admin.md，按指令执行。
完成后写状态报告到 .commander/status/admin.md。
```

### 终端 4 — 小程序专家

```bash
kiro chat
```

```
你是小程序专家，遵循 .skills/wechat-miniprogram/SKILL.md。
读取 .commander/prompts/miniapp.md，按指令执行。
完成后写状态报告到 .commander/status/miniapp.md。
```

### 回到终端 1 — 验收

```
各专家已完成，请验收：
1. 跑 scripts/verify.sh
2. 读取 .commander/status/ 下所有报告
3. 判定通过/不通过
4. 通过则生成下一 Phase 指令
5. 不通过则生成修复指令
```

---

## 方式三：混合模型模式（省成本）

指挥官用强模型，专家用便宜模型。

### 终端 1 — 指挥官（Claude/GPT-4o）

```bash
kiro chat --model claude-sonnet
```

```
你是项目总指挥。用 subagent 调度专家时，专家会自动执行。
你负责：需求分析、任务拆解、验收、分派修复。
开始阅读 docs/ 并规划 Phase 1。
```

### 终端 2-4 — 专家（DeepSeek V4 / 本地模型）

```bash
kiro chat --model deepseek-v4
```

```
你是 Go 后端专家。读取 .commander/prompts/backend.md 执行任务。
```

> 指挥官生成的指令足够详细，弱模型也能按指令完成。

---

## 方式四：CI/CD 集成模式

把指挥官写成脚本，自动化流水线。

```bash
#!/bin/bash
# scripts/auto-dev.sh

echo "Phase 1: 生成指令"
kiro chat --non-interactive --prompt "
你是指挥官。读取 docs/，生成 Phase 1 各专家指令到 .commander/prompts/
"

echo "Phase 1: 执行"
kiro chat --non-interactive --prompt "
你是后端专家。读取 .commander/prompts/backend.md 执行。
" &

kiro chat --non-interactive --prompt "
你是前端专家。读取 .commander/prompts/admin.md 执行。
" &

wait

echo "验收"
kiro chat --non-interactive --prompt "
你是指挥官。跑 scripts/verify.sh，读取 status 报告，判定是否通过。
"
```

---

## 文件交互协议

无论哪种方式，核心都是通过文件通信：

```
指挥官写指令 → .commander/prompts/{role}.md
专家读指令   ← .commander/prompts/{role}.md
专家写报告   → .commander/status/{role}.md
指挥官读报告 ← .commander/status/{role}.md
契约文件     ↔ .commander/contracts/api-v1.yaml
```

---

## 快速选择

| 场景 | 推荐方式 |
|------|----------|
| 个人开发，想省事 | 方式一（单终端 subagent） |
| 想看每一步过程 | 方式二（多终端手动） |
| 想省 API 费用 | 方式三（混合模型） |
| 团队 CI/CD | 方式四（脚本自动化） |
