# 如何向天气系统添加新城市 (Add City to Weather System)

## 🎯 快速开始

### 方式 1: 简单请求（推荐）
只需告诉 AI 要添加什么城市，不需要了解 Layer 1-4 的细节：

```
"增加 Bangkok 到天气警报系统"

或

"Add Bangkok weather monitoring"
```

**AI 会自动：**
- 🔍 识别需要修改的所有层
- ✅ 在 Layer 3 (Command) 添加城市
- ✅ 在 Layer 4a (Config) 添加地理信息
- ✅ 在 Layer 4b (HTML) 添加城市卡片
- 🔄 验证所有层保持同步
- 📊 向你报告变更清单

---

## 📋 工作原理

当你说"增加[城市]"时，AI 会：

### Step 1: 自动识别检查清单
```
AI 加载: .claude/rules/add-city-checklist.md

┌─ Layer 3: Command (.claude/commands/weather-alert.md)
│  └─ 需要在 cities 数组添加新城市
│
└─ Layer 4: Orchestration
   ├─ config.json — 添加地理坐标、时区
   └─ HTML 报告 — 添加城市卡片、更新统计
```

### Step 2: 执行变更
AI 会依次修改：
1. `.claude/commands/weather-alert.md` — 城市列表
2. `config.json` — 地理信息
3. `weather-alert-report.html` — UI 卡片和统计

### Step 3: 验证一致性
```bash
# AI 会自动运行
./scripts/verify-weather-layers.sh

# 检查项:
# ✓ Layer 3 和 Layer 4 城市列表一致
# ✓ HTML 统计数字正确
# ✓ 所有城市都有地理坐标
# ✓ 没有重复或冲突
```

### Step 4: 反馈报告
```
✅ 变更完成

已更新的文件:
  ✓ .claude/commands/weather-alert.md
  ✓ practice/layer-4-orchestration/config.json
  ✓ practice/layer-4-orchestration/weather-alert-report.html

验证结果: ✓ 所有层已同步

建议:
  1. 运行 /weather-alert 命令测试
  2. 查看 HTML 报告确认显示正确
  3. git add && git commit
```

---

## 💡 使用场景

### 场景 1: 添加单个城市
```
"增加 Bangkok 到天气系统"

✓ 自动添加到所有 4 个层
✓ 自动获取地理坐标（曼谷）
✓ 自动在 HTML 生成城市卡片
```

### 场景 2: 添加多个城市
```
"增加 Bangkok, Singapore, Ho Chi Minh City"

✓ 按顺序添加每个城市
✓ 每个添加后验证一致性
✓ 最后生成综合报告
```

### 场景 3: 启用/禁用城市
```
"禁用 Osaka, 启用 Seoul"

✓ 在 config.json 中设置 enabled: false/true
✓ 自动更新 HTML 报告
✓ 验证统计摘要
```

### 场景 4: 替换城市
```
"用 Bangkok 替换 Osaka"

✓ 移除 Osaka (所有层)
✓ 添加 Bangkok (所有层)
✓ 单次验证所有更改
```

---

## 🔍 AI 的智能提示

### AI 会主动警告的情况

#### ⚠️ 警告 1: 部分更新
**情况**: 用户只修改了 Layer 3
```
⚠️ 警告: 你修改了 Layer 3 (Command)，
但 Layer 4 (Config) 还没更新。
HTML 报告不会显示新城市。

需要继续更新:
  1. practice/layer-4-orchestration/config.json
  2. weather-alert-report.html
```

#### ⚠️ 警告 2: 手动编辑 HTML
**情况**: 用户手动改 HTML 报告
```
⚠️ 建议: HTML 报告应该从 config.json 自动生成
而不是手动编辑。

建议流程:
  1. 编辑 config.json (添加城市)
  2. 运行 /weather-orchestrator 命令
  3. HTML 会自动更新
```

#### ❌ 错误 1: 城市名称不一致
**情况**: Layer 3 是 "Bangkok"，Layer 4 是 "Bangkok, Thailand"
```
❌ 错误: 城市名称不一致
  Layer 3: Bangkok
  Layer 4: Bangkok, Thailand

请统一城市名称
```

#### ❌ 错误 2: 坐标无效
**情况**: 坐标超出范围
```
❌ 错误: Bangkok 坐标无效
  纬度: 250.5 (超出范围 -90 ~ 90)

正确坐标: 13.7563°N, 100.5018°E
```

---

## 🛠️ 高级用法

### 手动验证一致性
如果你想手动检查，可以运行：
```bash
./scripts/verify-weather-layers.sh
```

输出示例：
```
🔍 开始验证天气系统各层一致性...

📋 Layer 3: 读取命令层城市列表...
   Layer 3 城市: Taipei,Dubai,Tokyo,Seoul,Bangkok

📋 Layer 4: 读取编排层城市列表...
   Layer 4 城市: Taipei,Dubai,Tokyo,Seoul,Bangkok

🔄 检查: Layer 3 vs Layer 4 config...
✓ 通过: 城市列表一致

════════════════════════════════════════
✓ 所有检查通过！所有 Layer 已同步。
════════════════════════════════════════
```

### 查看城市信息
查看 config.json 中的完整城市定义：
```json
{
  "name": "Bangkok",
  "latitude": 13.7563,
  "longitude": 100.5018,
  "timezone": "Asia/Bangkok",
  "enabled": true
}
```

---

## 📚 相关文档

- **检查清单**: `.claude/rules/add-city-checklist.md` — AI 自动遵循的验证清单
- **验证脚本**: `scripts/verify-weather-layers.sh` — 手动验证一致性
- **架构说明**: `CLAUDE.md` — Layer 1-4 的详细说明

---

## ✅ 最佳实践

### ✓ 推荐做法
```
1. 告诉 AI: "增加 Bangkok"
2. 让 AI 自动修改所有层
3. 运行 /weather-alert 测试
4. 查看生成的 HTML 报告
5. git commit
```

### ✗ 不推荐做法
```
1. ❌ 手动编辑多个文件后再告诉 AI
   → AI 无法追踪哪些文件被修改了

2. ❌ 只修改 HTML，不修改 config
   → 下次运行会被覆盖

3. ❌ 更改城市名称格式
   → Layer 3 和 4 会不一致
```

---

## 🔄 工作流完整示例

### 用户输入
```
"增加 Bangkok 和 Singapore 到天气系统"
```

### AI 自动执行

**Step 1: 识别**
```
✓ 识别 2 个新城市: Bangkok, Singapore
✓ 加载检查清单: .claude/rules/add-city-checklist.md
```

**Step 2: 修改 Layer 3**
```
📝 编辑: .claude/commands/weather-alert.md
修改前: ["Taipei", "Dubai", "Tokyo", "Seoul"]
修改后: ["Taipei", "Dubai", "Tokyo", "Seoul", "Bangkok", "Singapore"]
```

**Step 3: 修改 Layer 4a (Config)**
```
📝 编辑: practice/layer-4-orchestration/config.json
添加:
{
  "name": "Bangkok",
  "latitude": 13.7563,
  "longitude": 100.5018,
  "timezone": "Asia/Bangkok",
  "enabled": true
},
{
  "name": "Singapore",
  "latitude": 1.3521,
  "longitude": 103.8198,
  "timezone": "Asia/Singapore",
  "enabled": true
}
```

**Step 4: 修改 Layer 4b (HTML)**
```
📝 编辑: weather-alert-report.html
添加 Bangkok 卡片
添加 Singapore 卡片
更新统计: "监控城市" 从 4 改为 6
```

**Step 5: 验证**
```
🔍 运行验证脚本
✓ Layer 3 城市列表 == Layer 4 城市列表
✓ HTML 统计数字正确 (6 个城市)
✓ 所有城市都有坐标
```

**Step 6: 反馈**
```
✅ 完成！

已修改:
  ✓ .claude/commands/weather-alert.md
  ✓ practice/layer-4-orchestration/config.json
  ✓ practice/layer-4-orchestration/weather-alert-report.html

下一步:
  1. 运行 /weather-alert 测试新城市
  2. 查看 HTML 报告确认显示
  3. git add -A && git commit
```

---

## 🎓 学到的架构原理

通过这个系统，你看到了：

1. **单一真实源 (Single Source of Truth)**
   - config.json 是真实数据源
   - Command 读取 config
   - HTML 也读取 config

2. **自动化验证**
   - 变更后自动检查一致性
   - 主动提醒用户潜在问题

3. **用户隐藏复杂性**
   - 用户只需说"增加城市"
   - AI 自动处理所有 4 个层

4. **规则驱动**
   - `.claude/rules/` 文件指导 AI 行为
   - 验证脚本保证质量

---

**现在试试说: "增加 Bangkok 到天气系统" 吧！** 🌍
