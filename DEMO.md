# CovenantCrew 使用 Demo

## 0. 新项目初始化（推荐）

```bash
cd /Users/clwang/workspace/OutWorks/CovenantCrew
./scripts/init-project.sh ../my-project saas_admin "My Project"
cd ../my-project
```

然后做人类动作：

1. 把客户原始文档、截图、原型放进 `docs/00-intake/raw/`
2. 填写 `docs/00-intake/intake-packet.md`
3. 把参考链接写进 `docs/00-intake/source-links.md`
4. 启动 Commander 做阶段 A

## 方式一：单终端模式（推荐）

一个终端搞定，但前面四个关键节点必须由人类批准：PRD、设计方向、技术栈 ADR、Contract Bundle。

```bash
cd my-project
kiro chat
```

### 阶段 A：需求审计

```
你是项目总指挥，遵循 .skills/project-commander/SKILL.md 和 .skills/fullstack-planning/SKILL.md。

当前只做“需求审计与 PRD 草稿”，不要写代码，不要启动多专家开发。

项目资料：
- 客户原始资料：docs/00-intake/raw/
- 参考链接：docs/00-intake/source-links.md
- 人类填写的信息：docs/00-intake/intake-packet.md

请完成：
1. 输出 docs/00-intake/requirement-audit.md
2. 输出 docs/00-intake/assumptions.md
3. 输出 docs/01-prd/PRD.draft.md
4. 输出 docs/01-prd/acceptance-criteria.draft.md
5. 输出 docs/01-prd/traceability-matrix.draft.md

完成后停止，等待我回答 P0 问题并批准 PRD。
```

### 阶段 B-D：批准 PRD、设计/ADR、Contract Bundle

直接复制 `docs/START_COMMANDER_PROMPTS.md` 中的阶段 B、C、D。每个阶段完成后，人类确认再继续。

### 阶段 E：并行开发

Contract Bundle 批准后，再复制 `docs/START_COMMANDER_PROMPTS.md` 的阶段 E：

```
Contract Bundle 已批准。现在可以启动多专家并行开发。

你是项目总指挥，遵循 .skills/project-commander/SKILL.md。

请按 docs/01-prd/traceability-matrix.md 拆分 Phase，生成 .commander/phases/phase-XX.md 和 .commander/prompts/{role}.md。
每份专家指令必须包含背景、依赖、允许修改文件、禁止修改文件、任务列表、交付标准、自检清单。
每个 Phase 结束后调度 QA，QA 未 PASS 不进入下一 Phase。

请自动推进，遇到业务范围、技术栈、外部服务、数据口径、客户变更相关问题时停止并向我提问。
```

---

## 方式二：多终端模式（手动协调）

适合想精细控制每一步的场景。

### 终端 1 — 指挥官

```bash
kiro chat
```

```
你是项目总指挥。阅读 docs/ 下产品文档，
按 .skills/fullstack-planning/SKILL.md 先做需求审计、PRD、设计、ADR、Contract Bundle。
没有人类批准 Contract Bundle 前，不生成专家开发指令。
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
1. 对照 docs/QUALITY_GATES.md
2. 读取 .commander/status/ 下所有报告
3. 对照 docs/01-prd/traceability-matrix.md 检查需求覆盖
4. 判定通过/不通过
5. 通过则生成下一 Phase 指令
6. 不通过则生成修复指令
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
契约包       ↔ .commander/contracts/
```

---

## 快速选择

| 场景 | 推荐方式 |
|------|----------|
| 个人开发，想省事 | 方式一（单终端 subagent） |
| 想看每一步过程 | 方式二（多终端手动） |
| 想省 API 费用 | 方式三（混合模型） |
| 团队 CI/CD | 方式四（脚本自动化） |
