# AI 智能需求问询示例 (AI Intelligent Requirements Questioning)

## 📚 实际对话示例

### 场景：用户请求添加"降雨机率"功能

---

## 💬 完整对话流程

### Step 1: 用户提出需求（简单）

```
用户: "我想在天气警报系统中增加地区下雨机率"
```

---

### Step 2: AI 识别复杂性并开始问询

```
AI 响应:

✅ 我理解你的需求。这个功能会影响多个 Layer（1-4）。

为了正确实现，我需要澄清几个关键问题。
让我按阶段提问:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【Phase 1: 需求澄清】

❓ 问题 1: "下雨机率"具体指什么？

  a) 📊 降水概率 (0-100% 百分比)
     例: "Taipei: 45% 降水概率"
  
  b) 📈 降水等级 (分类数据)
     例: "Taipei: 小雨, Tokyo: 大雨"
  
  c) 💧 降水量预测 (毫米)
     例: "Taipei: 12mm, Dubai: 0mm"

请选择 (a/b/c 或自定义)?
```

用户回答：`a) 百分比`

```
✅ 已选择: 降水概率 (百分比, 0-100%)

❓ 问题 2: 这个信息应该显示在哪里？

  a) 📍 在现有城市卡片中添加
     ┌─────────────────┐
     │ Taipei          │
     │ 🌡️ 29.1°C       │
     │ ☔ 45% 降水      │ ← 新
     │ 🌤️ Normal       │
     └─────────────────┘
  
  b) 📊 创建独立的降雨卡片/摘要
     ┌─────────────────┐
     │ ☔ 降雨概况      │
     │ Taipei: 45%     │
     │ Dubai: 5%       │
     │ Tokyo: 68%      │
     └─────────────────┘
  
  c) 🎯 两者都显示

请选择 (a/b/c)?
```

用户回答：`c) 两者都显示`

```
✅ 已选择: 在卡片和独立摘要中都显示

❓ 问题 3: 是否需要降雨警报？

  a) ❌ 不需要，仅显示数据
  
  b) ⚠️ 需要，降水 > 70% 时触发警报
  
  c) ⚠️ 需要多个级别
     • 30-50%: 轻度降雨
     • 50-70%: 中度降雨
     • >70%: 高风险降雨

请选择 (a/b/c)?
```

用户回答：`b) 降水 > 70% 时触发警报`

```
✅ 已收集所有需求信息
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### Step 3: AI 评估架构影响

```
AI 响应:

📊 【基于你的答案，以下是架构影响分析】

这个需求涉及所有 5 个 Layer:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📍 Layer 1 - Skill (数据获取)
  当前: weather-fetcher (仅获取温度)
  修改: 扩展以获取降水概率
  数据源: Open-Meteo API 已支持
  ✓ 无需新 Skill，仅扩展现有

📍 Layer 2 - Agent (数据分析)
  当前: weather-analyzer-agent
  修改: 添加降雨分析逻辑
  新逻辑:
    • 降水 > 70% → rainfall_alert = true
    • 温度 > 35°C AND 降水 > 70% → extreme_conditions
  ✓ 扩展现有 Agent，支持组合告警

📍 Layer 3 - Command (用户接口)
  当前: /weather-alert (仅分析温度)
  修改: 扩展城市列表配置
  新字段: rainfall_alert_threshold: 70
  ✓ 修改 .claude/commands/weather-alert.md

📍 Layer 4a - Config (配置管理)
  当前: practice/layer-4-orchestration/config.json
  修改: 添加全局和本地降水阈值
  格式:
  {
    "thresholds": {
      "heat_wave": 35,
      "rainfall_alert": 70,  ← 新增
      "cold_warning": 0
    }
  }
  ✓ 修改 config.json

📍 Layer 4b - HTML (报告生成)
  当前: 城市卡片 + 温度 + 统计摘要
  修改: 
    1. 在每个城市卡片添加降水百分比
    2. 添加新的"降雨概况"卡片
    3. 更新统计摘要（显示降雨风险城市数）
  ✓ 修改 weather-alert-report.html

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

❓ 问题 4: 数据更新频率？

  a) 与温度相同 (每 6 小时)
  b) 更频繁 (每小时)
  c) 实时 (每次查询时)

推荐: a) 保持一致的更新周期

请确认吗? [y/n]
```

用户回答：`y`

```
✅ 已确认: 每 6 小时更新一次

❓ 问题 5: 是否需要保存历史降雨数据？

  a) 否，仅显示最新值
  b) 是，存储完整历史（用于趋势分析）
  c) 是，但仅保留 7 天数据

推荐: c) 平衡存储和分析需求

请选择?
```

用户回答：`c) 7天数据`

```
✅ 已确认: 保留 7 天历史数据
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### Step 4: AI 总结实施计划

```
AI 响应:

📋 【最终实施计划】

基于以上需求分析，这是完整的实施流程:

步骤 1️⃣ : 扩展 Skill 层
  文件: .claude/skills/weather-fetcher/SKILL.md
  操作: 添加 fetchRainfallProbability() 函数
  数据: 从 Open-Meteo 获取降水概率
  结果: { temperature, rainfall_probability }

步骤 2️⃣ : 扩展 Agent 层
  文件: .claude/agents/weather-analyzer-agent.md
  操作: 添加降雨分析逻辑
  新告警:
    - rainfall_alert: 降水 > 70%
    - extreme_conditions: 热浪 + 降雨同时
  结果: 返回 { temp_status, rainfall_status, combined_status }

步骤 3️⃣ : 修改 Command 层
  文件: .claude/commands/weather-alert.md
  操作: 添加降水阈值配置
  新配置: rainfall_alert_threshold: 70

步骤 4️⃣ : 更新 Config 层
  文件: practice/layer-4-orchestration/config.json
  操作: 
    - 添加全局 rainfall_alert: 70
    - 每个城市可覆盖此阈值
  修改示例:
  {
    "thresholds": {
      "heat_wave": 35,
      "rainfall_alert": 70,  ← 新
      "cold_warning": 0
    },
    "cities": [
      {
        "name": "Taipei",
        "rainfall_threshold": 70  // 可选覆盖
      }
    ]
  }

步骤 5️⃣ : 更新 HTML 层
  文件: weather-alert-report.html
  操作 A: 修改城市卡片
    ┌──────────────────┐
    │ Taipei           │
    │ 🌡️ 29.1°C        │
    │ ☔ 45% 降水       │ ← 新
    │ 🌤️ Normal        │
    └──────────────────┘
  
  操作 B: 添加降雨摘要卡片
    ┌──────────────────┐
    │ ☔ 降雨概况       │
    │ 高风险 (>70%):   │
    │  • Tokyo: 75%    │
    │  • Seoul: 85%    │
    │ 中等 (50-70%):   │
    │  • Bangkok: 52%  │
    └──────────────────┘
  
  操作 C: 更新统计
    原: 正常/热浪/寒冷 城市数
    新: 添加降雨风险城市数

步骤 6️⃣ : 改进验证脚本
  文件: scripts/verify-weather-layers.sh
  新增检查:
    ✓ 所有城市都有降水概率
    ✓ 概率值在 0-100% 范围内
    ✓ 告警阈值一致
    ✓ HTML 显示与数据一致
    ✓ 历史数据完整性

步骤 7️⃣ : 测试
  运行: /weather-alert
  验证: 所有 5 个城市显示温度和降水
  检查: 降水 > 70% 的城市正确标记为警报

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 【预期结果】

执行后，系统将:
  ✅ 显示每个城市的降水概率
  ✅ 当降水 > 70% 时触发"降雨预警"
  ✅ 在 HTML 中显示降雨概况
  ✅ 保存 7 天历史数据用于趋势分析
  ✅ 自动验证所有 Layer 同步

⏱️ 【实施时间估计】

  - Skill 扩展: 5-10 分钟
  - Agent 扩展: 5-10 分钟
  - Command 修改: 2-3 分钟
  - Config 更新: 2-3 分钟
  - HTML 更新: 10-15 分钟
  - 验证脚本: 5-10 分钟
  - 测试与调整: 10-15 分钟
  
  总计: 45-70 分钟

准备开始实施吗? [Y/n]
```

用户回答：`Y`

---

### Step 5: AI 执行实施（与 Step 2-4 相同）

```
AI 开始执行:

📝 Step 1/7: 扩展 Skill 层...
  ✓ 修改 .claude/skills/weather-fetcher/SKILL.md
  ✓ 添加 fetchRainfallProbability() 函数
  ✓ 验证 Open-Meteo API 支持

📝 Step 2/7: 扩展 Agent 层...
  ✓ 修改 weather-analyzer-agent.md
  ✓ 添加降雨分析逻辑
  ✓ 新增 rainfall_alert 告警类型

... (类似步骤 3-7)

✅ 所有步骤完成！

运行验证脚本...
  ✓ 降水数据完整性: 通过
  ✓ 概率范围有效: 通过
  ✓ 告警阈值一致: 通过
  ✓ HTML 显示: 通过

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✨ 实施完成！

已修改文件:
  1. .claude/skills/weather-fetcher/SKILL.md
  2. .claude/agents/weather-analyzer-agent.md
  3. .claude/commands/weather-alert.md
  4. practice/layer-4-orchestration/config.json
  5. practice/layer-4-orchestration/weather-alert-report.html
  6. scripts/verify-weather-layers.sh

所有 Layer 已同步！

建议下一步: 运行 /weather-alert 命令查看新增的降水数据
```

---

## 🎯 AI 智能问询的关键原则

### 1️⃣ 提前澄清，避免返工

```
❌ 差的做法:
  用户: "增加下雨机率"
  AI: [直接开始修改]
  [20分钟后]
  结果: 实现错了，需要重做

✅ 好的做法:
  用户: "增加下雨机率"
  AI: "这涉及 5 个 Layer，我有几个问题..."
  [5分钟问询]
  [10分钟正确实现]
  结果: 一次成功
```

### 2️⃣ 识别架构依赖

```
好的 AI 会想:

"用户说'增加下雨机率'，但这不仅仅是加一个字段。

影响:
  - Skill 层: 需要新数据源吗？
  - Agent 层: 分析逻辑如何变化？
  - Command 层: 配置应该如何组织？
  - Config 层: 数据结构如何扩展？
  - HTML 层: UI 应该怎样展示？

这些都需要问清楚。"
```

### 3️⃣ 透明化复杂性

```
用户想听到:
  "这个需求影响这些方面..."
  "这是实施计划..."
  "这是预期的结果..."

而不是:
  AI 默默修改多个文件，
  然后说"完成了"
```

### 4️⃣ 给用户决策权

```
✅ 问询框架给用户选择:
  - 数据格式 (百分比 vs 等级)
  - 显示位置 (卡片 vs 摘要)
  - 告警级别 (单一 vs 多级)
  - 数据保留策略 (无 vs 有限 vs 完整)

这样实现的系统真正满足用户需求
```

---

## 📚 可以重用的提问模板

### 对于任何新功能请求

```
【Phase 1: 需求澄清】
❓ 数据内容: 具体是什么？
❓ 显示位置: 在哪里显示？
❓ 告警需求: 需要警报吗？

【Phase 2: 架构影响】
❓ 涉及哪些 Layer？
❓ 数据源是什么？
❓ 与现有系统的关系？

【Phase 3: 验证策略】
❓ 如何验证正确性？
❓ 需要检查什么？

【Phase 4: 最终确认】
✓ 总结计划
✓ 获取用户确认
✓ 开始实施
```

---

## ✨ 总结

**AI 应该像一个好的产品经理:**

- 🎯 不直接跳到实现
- 🤔 先理解需求的各个维度
- 🏗️ 识别架构影响
- 📋 制定明确的计划
- ✅ 透明地执行
- 🔍 彻底验证

**这样做的好处:**

✓ 避免返工
✓ 用户感到被理解
✓ 实现质量更高
✓ 维护成本更低
✓ 系统扩展性更好
