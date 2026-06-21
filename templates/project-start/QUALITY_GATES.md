# Quality Gates

> 使用方式：复制到新项目 `docs/QUALITY_GATES.md`，每个阶段完成后由 Commander/QA 勾选。

## Gate 0：资料完整性

- [ ] 项目已通过 `scripts/init-project.sh` 初始化，或手动创建了同等结构
- [ ] `.skills/` 已存在
- [ ] `.commander/` 已存在
- [ ] `docs/START_COMMANDER_PROMPTS.md` 已存在
- [ ] 客户原始文档已归档到 `docs/00-intake/raw/`
- [ ] 参考链接已写入 `docs/00-intake/source-links.md`
- [ ] 人类已填写 `docs/00-intake/intake-packet.md`
- [ ] 账号、密钥、生产数据没有直接提交到仓库

通过标准：资料足够让 AI 做需求审计。

## Gate 1：需求审计

- [ ] 已输出 `docs/00-intake/requirement-audit.md`
- [ ] 已输出 `docs/00-intake/assumptions.md`
- [ ] P0/P1/P2 问题已分级
- [ ] P0 问题已由人类回答或明确延期
- [ ] 矛盾需求已记录处理结论

通过标准：没有未处理的 P0 阻塞问题。

## Gate 2：PRD 批准

- [ ] 已输出 `docs/01-prd/PRD.md`
- [ ] 每个核心需求都有 REQ ID
- [ ] 每个核心流程都有验收标准
- [ ] 已输出 `docs/01-prd/traceability-matrix.md`
- [ ] 已输出 `docs/01-prd/out-of-scope.md`
- [ ] 人类已在 `decision-log.md` 批准 PRD

通过标准：需求范围可开发、可验收、可追踪。

## Gate 3：设计批准

- [ ] 已输出 `docs/02-design/design-options.md`
- [ ] 已输出 `docs/02-design/design-decision.md`
- [ ] 已输出项目自己的 `docs/02-design/DESIGN.md`
- [ ] 设计方向只保留一个主参考，最多一个辅助参考
- [ ] 人类已批准设计方向

通过标准：视觉方向明确，不在开发中途重新摇摆。

## Gate 4：技术栈批准

- [ ] 已输出 `docs/03-architecture/adr/0001-tech-stack.md`
- [ ] ADR 说明了选择理由
- [ ] ADR 说明了放弃选项
- [ ] ADR 说明了风险和扩展方式
- [ ] 人类已批准技术栈

通过标准：后续开发、部署、维护团队都能接受。

## Gate 5：Contract Bundle 批准

- [ ] `.commander/contracts/openapi.yaml` 已完成
- [ ] `.commander/contracts/database.md` 已完成
- [ ] `.commander/contracts/permissions.md` 已完成
- [ ] `.commander/contracts/error-codes.md` 已完成
- [ ] `.commander/contracts/frontend-types.md` 已完成
- [ ] `.commander/contracts/seed-data.md` 已完成
- [ ] `.commander/contracts/mock-rules.md` 已完成
- [ ] 人类已批准契约包

通过标准：前后端、小程序、QA 可以基于同一契约并行。

## Gate 6：Phase 开发验收

- [ ] Phase 文件已生成到 `.commander/phases/`
- [ ] 专家指令已生成到 `.commander/prompts/`
- [ ] 每个专家指令包含允许/禁止修改范围
- [ ] 每个专家已提交 `.commander/status/{role}.md`
- [ ] 构建通过
- [ ] 类型检查通过
- [ ] 单元测试通过
- [ ] 契约一致性检查通过

通过标准：当前 Phase 的实现可以进入 QA。

## Gate 7：QA 验收

- [ ] QA 已输出测试报告
- [ ] P0 主路径 E2E 通过
- [ ] 至少覆盖 3 个异常路径
- [ ] 接口返回业务码已验证
- [ ] 权限边界已验证
- [ ] 空状态、加载状态、错误状态已验证
- [ ] 没有阻塞级 bug

通过标准：QA 结论为 PASS，或人类明确接受剩余已知问题。

## Gate 8：交付验收

- [ ] 已输出 `docs/04-qa/final-acceptance-report.md`
- [ ] 已输出 `docs/04-qa/demo-script.md`
- [ ] 已输出 `docs/04-qa/known-issues.md`
- [ ] Demo script 可完整跑通
- [ ] 已知问题均有处理结论
- [ ] 客户演示所需账号、数据、环境已准备

通过标准：可以对客户演示或交付。

## Gate 9：复盘沉淀

- [ ] 已输出 `docs/99-retro/process-retro.md`
- [ ] 记录了本项目暴露的流程问题
- [ ] 记录了可复用的设计/技术/契约经验
- [ ] 系统性问题已反向更新到 CovenantCrew 模板

通过标准：下一个项目会因为本项目变得更稳。
