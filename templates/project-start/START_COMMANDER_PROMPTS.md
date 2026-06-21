# Start Commander Prompts

> 使用方式：按阶段复制给 Commander。每个阶段完成后，由人类批准再进入下一阶段。

## 阶段 A：需求审计

```text
你是项目总指挥，遵循 .skills/project-commander/SKILL.md 和 .skills/fullstack-planning/SKILL.md。

当前只做“需求审计与 PRD 草稿”，不要写代码，不要启动多专家开发。

项目资料：
- 客户原始资料：docs/00-intake/raw/
- 参考链接：docs/00-intake/source-links.md
- 人类填写的信息：docs/00-intake/intake-packet.md

请完成：
1. 阅读所有资料，整理业务目标、用户角色、核心流程
2. 输出 docs/00-intake/requirement-audit.md
   - 缺失信息
   - 矛盾信息
   - 风险点
   - P0/P1/P2 待确认问题
3. 输出 docs/00-intake/assumptions.md
   - 只记录合理假设，不要把假设当事实
4. 输出 docs/01-prd/PRD.draft.md
5. 输出 docs/01-prd/acceptance-criteria.draft.md
6. 输出 docs/01-prd/traceability-matrix.draft.md

完成后停止，等待我回答 P0 问题并批准 PRD。
```

## 阶段 B：PRD 定稿

```text
我已经回答了 P0 问题，并批准进入 PRD 定稿阶段。

请基于：
- docs/00-intake/requirement-audit.md
- docs/00-intake/assumptions.md
- docs/00-intake/decision-log.md
- docs/01-prd/PRD.draft.md

生成正式版本：
1. docs/01-prd/PRD.md
2. docs/01-prd/acceptance-criteria.md
3. docs/01-prd/traceability-matrix.md
4. docs/01-prd/out-of-scope.md

要求：
- 每个需求必须有 REQ ID
- 每个核心流程必须有验收标准
- 未确认内容必须单独标注，不能混入已确认范围
- 完成后停止，等待我批准设计和技术栈阶段
```

## 阶段 C：设计方向与技术栈 ADR

```text
PRD 已批准。现在进入设计方向和技术栈决策阶段。

请完成：
1. 基于项目类型和 docs/00-intake/source-links.md，参考 /Users/clwang/workspace/OpenSource/awesome-design-md 中合适的 DESIGN.md
2. 给出 2-3 个设计方向候选，写入 docs/02-design/design-options.md
3. 推荐一个主设计方向，写入 docs/02-design/design-decision.draft.md
4. 生成项目自己的 docs/02-design/DESIGN.draft.md
5. 根据项目约束推荐技术栈，写入 docs/03-architecture/adr/0001-tech-stack.draft.md

要求：
- 不要混合过多视觉参考
- 技术栈必须说明选择理由、放弃选项、风险和扩展方式
- 完成后停止，等待我批准设计方向和技术栈
```

## 阶段 D：契约包

```text
设计方向和技术栈已批准。现在进入 Contract Bundle 阶段。

请先创建或更新 .commander/contracts/，输出：
1. .commander/contracts/openapi.yaml
2. .commander/contracts/database.md
3. .commander/contracts/permissions.md
4. .commander/contracts/error-codes.md
5. .commander/contracts/frontend-types.md
6. .commander/contracts/seed-data.md
7. .commander/contracts/mock-rules.md

要求：
- 优先使用 templates/project-start/contract-bundle/ 中的结构作为模板
- 以 docs/01-prd/traceability-matrix.md 为依据
- 覆盖 P0 主流程
- 明确字段命名、分页格式、错误码、权限规则
- 标注外部服务和 mock 边界
- 完成后停止，等待我批准进入并行开发
```

## 阶段 E：启动多专家并行开发

```text
Contract Bundle 已批准。现在可以启动多专家并行开发。

你是项目总指挥，遵循 .skills/project-commander/SKILL.md。

请完成：
1. 按 docs/01-prd/traceability-matrix.md 拆分 Phase
2. 为每个 Phase 生成 .commander/phases/phase-XX.md
3. 为相关专家生成 .commander/prompts/{role}.md
4. 每份专家指令必须包含：
   - 背景
   - 依赖
   - 允许修改的文件范围
   - 禁止修改的文件范围
   - 任务列表
   - 交付标准
   - 自检清单
5. 调度专家并行执行
6. 每个 Phase 结束后读取 status 报告并调度 QA
7. QA 未 PASS 不进入下一 Phase

请自动推进，遇到业务范围、技术栈、外部服务、数据口径、客户变更相关问题时停止并向我提问。
```

## 阶段 F：客户变更请求

```text
客户提出了变更请求。不要直接改代码。

请创建 docs/05-change-requests/CR-XXX.md，并完成变更影响分析：
1. 客户原始变更描述
2. 影响的 PRD 需求
3. 影响的页面/API/数据表/测试
4. 对工期和风险的影响
5. 建议处理方式：接受 / 拒绝 / 延后 / 拆到 Phase 2

完成后停止，等待我批准是否执行。
```
