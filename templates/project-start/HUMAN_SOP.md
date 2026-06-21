# Human Project Start SOP

> 目标：让人类只在关键决策点出现，AI 负责整理、生成、执行和验证。
> 适用：客户给出需求文档、参考链接、截图、口头需求后，启动一个新项目。

## 你的核心职责

你不是来手写 PRD、接口、代码和测试的。你的职责是：

1. 提供原始资料和真实约束
2. 确认业务边界和优先级
3. 批准设计方向和技术栈
4. 批准契约后再允许并行开发
5. 对验收结果做业务判断

## 总流程

```text
收到项目
  -> 收集资料
  -> 启动需求审计
  -> 回答 P0 问题
  -> 批准 PRD
  -> 批准设计方向
  -> 批准技术栈 ADR
  -> 批准 Contract Bundle
  -> 启动多专家并行开发
  -> 业务验收
  -> 复盘沉淀
```

## 1. 收到项目后先做什么

### 1.1 一键初始化项目

优先使用项目工厂：

```bash
cd /Users/clwang/workspace/OutWorks/CovenantCrew
./scripts/init-project.sh ../my-project saas_admin "My Project"
```

如果不确定 preset，先用 `custom`，再让 Commander 在 ADR 阶段推荐最终技术栈：

```bash
./scripts/init-project.sh ../my-project custom "My Project"
```

常用 preset 在：

```text
templates/project-start/STACK_PRESETS.yml
```

脚本会生成统一结构：

```text
my-project/
├── docs/
│   ├── 00-intake/
│   │   ├── raw/                 # 客户原始文档、截图、附件
│   │   ├── source-links.md      # 参考链接
│   │   └── intake-packet.md     # 人类填写的项目信息
│   ├── 01-prd/
│   ├── 02-design/
│   ├── 03-architecture/
│   └── 04-qa/
├── .commander/
└── .skills/
```

### 1.2 放入原始资料

你要做的是“原样归档”，不要急着总结：

- 客户需求文档放到 `docs/00-intake/raw/`
- 原型图、截图、设计稿放到 `docs/00-intake/raw/`
- 参考链接写入 `docs/00-intake/source-links.md`
- 客户口头信息写入 `docs/00-intake/intake-packet.md`
- 账号、密钥、生产数据不要直接放入仓库；只写“需要某某凭据”

### 1.3 填写 intake packet

复制：

```text
templates/project-start/PROJECT_INTAKE_PACKET.md
```

到项目：

```text
docs/00-intake/intake-packet.md
```

只填你确定的内容，不确定的写“待确认”。不要为了完整而编造。

## 2. 启动需求审计

把 `START_COMMANDER_PROMPTS.md` 里的“阶段 A：需求审计”发给 Commander。

此阶段 AI 只允许做这些事：

- 阅读客户资料
- 整理业务目标
- 找矛盾、缺口和风险
- 输出 P0/P1/P2 问题
- 生成 PRD 草稿

此阶段不允许：

- 写业务代码
- 定最终技术栈
- 开始并行开发
- 自行跳过 P0 问题

## 3. 人类需要回答哪些问题

你只需要重点回答 P0 问题。

### P0 必须回答

影响主流程、数据模型、价格、权限、交付范围的问题，例如：

- 目标用户到底是谁
- 核心业务闭环是什么
- 哪些功能首版必须有
- 哪些角色可以看哪些数据
- 是否需要支付、退款、审核、通知
- 数据从哪里来，是否要迁移旧数据
- 是否存在合规、隐私、行业监管要求
- 截止日期和上线范围是什么

### P1 尽量回答

影响体验和实现细节的问题，例如：

- 列表筛选项
- 文案语气
- 通知渠道
- 导出格式
- 管理后台统计维度

### P2 可以后置

不影响主流程的问题，例如：

- 非关键动画
- 非核心页面微交互
- 可后续配置的运营文案

## 4. 批准 PRD

你不需要逐字改 PRD，只检查 6 件事：

1. 用户角色是否正确
2. 核心流程是否闭环
3. 功能范围是否符合首版目标
4. 权限和数据边界是否清楚
5. 验收标准是否能演示
6. 未确认问题是否被明确标注

批准方式建议写入：

```text
docs/00-intake/decision-log.md
```

示例：

```markdown
# Decision Log

## DEC-001: 批准 PRD v1

- 时间: 2026-06-21
- 决策人: xxx
- 结论: 批准进入设计与架构阶段
- 条件: 支付功能放到 Phase 2，首版只保留人工确认订单
```

## 5. 批准设计方向

AI 会基于 `awesome-design-md` 给出 2-3 个设计方向，你只需要选一个主方向，最多允许一个辅助参考。

你需要提供：

- 品牌色或禁用颜色
- 是否有 logo、字体、图片素材
- 产品气质：专业、年轻、高端、效率、可信、活泼等
- 主要设备：桌面、移动端、小程序、管理后台
- 竞品或客户喜欢/不喜欢的参考链接

你要避免：

- 同时混合太多参考设计
- 只说“高级一点”“好看一点”
- 在开发中途频繁切换视觉方向

批准后，AI 应生成：

```text
docs/02-design/DESIGN.md
docs/02-design/design-decision.md
docs/02-design/prototype.html
```

## 6. 批准技术栈

技术栈不要靠临场指定，先让 AI 根据项目类型给出推荐 preset 和 ADR。

你需要确认：

- 客户是否指定技术栈
- 是否已有旧系统需要兼容
- 部署环境是什么
- 团队后续维护能力是什么
- 是否有小程序、App、管理后台、多语言要求
- 预算和上线时间是否压缩

批准后，AI 应生成：

```text
docs/03-architecture/adr/0001-tech-stack.md
```

ADR 必须写清楚：

- 选择什么
- 为什么选择
- 放弃了什么
- 风险是什么
- 后续如何扩展

## 7. 批准 Contract Bundle

这是并行开发前最重要的一步。没有契约包，不启动多专家开发。

Contract Bundle 至少包含：

```text
.commander/contracts/
├── openapi.yaml
├── database.md
├── permissions.md
├── error-codes.md
├── frontend-types.md
├── seed-data.md
└── mock-rules.md
```

你要重点检查：

- 核心对象字段是否符合业务
- 用户角色和权限是否正确
- 关键 API 是否覆盖主流程
- 错误码是否能表达业务失败
- 测试数据是否能跑通演示
- 是否明确哪些能力是 mock 或外部依赖

批准后，才允许 Commander 启动多专家并行开发。

## 8. 并行开发时人类做什么

并行开发阶段，你不要逐文件指挥。你只处理 Commander 抛出的决策问题。

你应该介入的问题：

- 范围是否砍掉或延期
- 业务规则二选一
- 外部服务无法接入
- 客户需求变化
- 数据口径不明确
- 验收时是否接受已知限制

你不应该介入的问题：

- 某个函数怎么写
- 组件怎么拆
- 文件放哪里
- 某个 lint 报错怎么修

## 9. 业务验收怎么做

让 QA 先完成自动化验收，再由你做业务验收。

你只看 5 个东西：

1. 核心 demo script 是否完整跑通
2. P0 需求是否全部有对应实现
3. 关键异常路径是否有处理
4. 已知问题是否可以接受
5. 交付物是否能给客户演示

建议让 AI 输出：

```text
docs/04-qa/final-acceptance-report.md
docs/04-qa/demo-script.md
docs/04-qa/known-issues.md
```

## 10. 客户变更需求时怎么做

不要直接让专家改代码。先让 Commander 做变更影响分析。

新增：

```text
docs/05-change-requests/CR-001.md
```

每个 CR 必须包含：

- 客户原始变更描述
- 影响的 PRD 需求
- 影响的页面/API/数据表/测试
- 工期影响
- 风险
- 建议：接受 / 拒绝 / 延后 / 拆成 Phase 2

你批准 CR 后，Commander 才能更新 PRD、契约和任务。

## 11. 项目结束后做什么

项目完成后花 10 分钟复盘，重点不是总结项目，而是更新流程资产。

记录：

- 哪类问题反复出现
- 哪个模板不够清楚
- 哪个质量门漏掉了 bug
- 哪个技术栈 preset 应该调整
- 哪个设计参考效果好

沉淀到：

```text
docs/99-retro/process-retro.md
```

如果是系统性问题，再反向更新 `CovenantCrew` 模板。

## 一句话原则

人类负责“真实世界的判断”，AI 负责“结构化、执行和验证”。没有人类批准 PRD、设计、技术栈和契约，不进入并行开发。
